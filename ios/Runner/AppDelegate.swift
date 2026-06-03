import UIKit
import Flutter
import flutter_local_notifications
import Vision
import ImageIO
import CoreImage

@main
@objc class AppDelegate: FlutterAppDelegate {
  private let receiptChannelName = "family_budget/receipt_ocr"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    if let controller = window?.rootViewController as? FlutterViewController {
      let receiptChannel = FlutterMethodChannel(
        name: receiptChannelName,
        binaryMessenger: controller.binaryMessenger
      )
      receiptChannel.setMethodCallHandler { [weak self] call, result in
        guard
          let args = call.arguments as? [String: Any],
          let imagePath = args["imagePath"] as? String
        else {
          result(
            FlutterError(
              code: "bad_args",
              message: "imagePath is required",
              details: nil
            )
          )
          return
        }

        switch call.method {
        case "recognizeText":
          self?.recognizeReceiptText(imagePath: imagePath, result: result)
        case "recognizeQr":
          self?.recognizeReceiptQr(imagePath: imagePath, result: result)
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }

    // Настройка для iOS 10 и выше
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
    }

    // Настройка уведомлений
    configureLocalNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Метод для настройки уведомлений
  private func configureLocalNotifications() {
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      if let error = error {
        print("Ошибка при запросе разрешений на уведомления: \(error.localizedDescription)")
      }
      if granted {
        print("Разрешение на уведомления получено.")
      } else {
        print("Разрешение на уведомления отклонено.")
      }
    }
  }

  private func recognizeReceiptText(imagePath: String, result: @escaping FlutterResult) {
    guard let uiImage = UIImage(contentsOfFile: imagePath), let image = uiImage.cgImage else {
      result(
        FlutterError(
          code: "image_load_failed",
          message: "Unable to load image at path",
          details: imagePath
        )
      )
      return
    }

    let orientation = cgImageOrientation(from: uiImage.imageOrientation)
    let candidates = textCandidateImages(from: image)
    var lines: [String] = []
    var seen = Set<String>()
    var lastError: Error?

    for candidate in candidates {
      do {
        let candidateLines = try recognizeTextLines(in: candidate, orientation: orientation)
        for line in candidateLines {
          let key = normalizeRecognizedLineKey(line)
          if key.isEmpty || seen.contains(key) {
            continue
          }
          seen.insert(key)
          lines.append(line)
        }
      } catch {
        lastError = error
      }
    }

    if lines.isEmpty, let lastError {
      result(
        FlutterError(
          code: "ocr_failed",
          message: lastError.localizedDescription,
          details: nil
        )
      )
      return
    }

    result(lines.joined(separator: "\n"))
  }

  private func recognizeTextLines(
    in image: CGImage,
    orientation: CGImagePropertyOrientation
  ) throws -> [String] {
    var recognizedLines: [String] = []
    var recognitionError: Error?

    let request = VNRecognizeTextRequest { request, error in
      if let error = error {
        recognitionError = error
        return
      }

      let observations = (request.results as? [VNRecognizedTextObservation]) ?? []
      let textBlocks = observations.compactMap { observation -> (text: String, box: CGRect)? in
        guard let candidate = observation.topCandidates(1).first else {
          return nil
        }
        let text = candidate.string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else {
          return nil
        }
        return (text: text, box: observation.boundingBox)
      }

      recognizedLines = self.groupTextBlocksIntoLines(textBlocks)
    }

    request.recognitionLevel = .accurate
    request.usesLanguageCorrection = true
    request.minimumTextHeight = 0.008
    if #available(iOS 16.0, *) {
      request.automaticallyDetectsLanguage = false
    }
    request.recognitionLanguages = ["ru-RU", "en-US"]

    let handler = VNImageRequestHandler(cgImage: image, orientation: orientation, options: [:])
    try handler.perform([request])

    if let recognitionError {
      throw recognitionError
    }

    return recognizedLines
  }

  private func groupTextBlocksIntoLines(
    _ textBlocks: [(text: String, box: CGRect)]
  ) -> [String] {
    let sorted = textBlocks.sorted { lhs, rhs in
      if abs(lhs.box.midY - rhs.box.midY) > 0.018 {
        return lhs.box.midY > rhs.box.midY
      }
      return lhs.box.minX < rhs.box.minX
    }

    var groupedRows: [[(text: String, box: CGRect)]] = []
    var rowAnchors: [CGFloat] = []

    for block in sorted {
      if let lastIndex = rowAnchors.indices.last {
        let anchorY = rowAnchors[lastIndex]
        let threshold = max(block.box.height * 0.75, 0.014)
        if abs(block.box.midY - anchorY) <= threshold {
          groupedRows[lastIndex].append(block)
          let currentCount = CGFloat(groupedRows[lastIndex].count)
          rowAnchors[lastIndex] = ((anchorY * (currentCount - 1)) + block.box.midY) / currentCount
          continue
        }
      }

      groupedRows.append([block])
      rowAnchors.append(block.box.midY)
    }

    return groupedRows.map { row in
      row
        .sorted { $0.box.minX < $1.box.minX }
        .map(\.text)
        .joined(separator: " ")
    }
  }

  private func textCandidateImages(from image: CGImage) -> [CGImage] {
    var candidates: [CGImage] = [image]
    let width = CGFloat(image.width)
    let height = CGFloat(image.height)

    let cropRects = [
      CGRect(x: width * 0.02, y: height * 0.02, width: width * 0.96, height: height * 0.72),
      CGRect(x: width * 0.02, y: height * 0.02, width: width * 0.96, height: height * 0.55),
      CGRect(x: width * 0.02, y: height * 0.18, width: width * 0.96, height: height * 0.48),
      CGRect(x: width * 0.02, y: height * 0.02, width: width * 0.72, height: height * 0.82),
    ]

    for rect in cropRects {
      let integralRect = rect.integral
      if let cropped = image.cropping(to: integralRect) {
        candidates.append(cropped)
      }
    }

    return candidates
  }

  private func normalizeRecognizedLineKey(_ line: String) -> String {
    return line
      .uppercased()
      .components(separatedBy: CharacterSet.alphanumerics.inverted)
      .joined()
  }

  private func recognizeReceiptQr(imagePath: String, result: @escaping FlutterResult) {
    guard let uiImage = UIImage(contentsOfFile: imagePath), let image = uiImage.cgImage else {
      result(
        FlutterError(
          code: "image_load_failed",
          message: "Unable to load image at path",
          details: imagePath
        )
      )
      return
    }

    let orientation = cgImageOrientation(from: uiImage.imageOrientation)
    let candidates = qrCandidateImages(from: image)

    for candidate in candidates {
      if let payload = detectQrPayload(in: candidate, orientation: orientation) {
        result(payload)
        return
      }

      if let payload = detectQrPayloadWithCoreImage(in: candidate, orientation: orientation) {
        result(payload)
        return
      }
    }

    result(nil)
  }

  private func detectQrPayload(in image: CGImage, orientation: CGImagePropertyOrientation) -> String? {
    let request = VNDetectBarcodesRequest()
    request.symbologies = [.qr]

    let handler = VNImageRequestHandler(cgImage: image, orientation: orientation, options: [:])
    do {
      try handler.perform([request])
      let observations = (request.results as? [VNBarcodeObservation]) ?? []
      return observations
        .sorted { lhs, rhs in
          let lhsArea = lhs.boundingBox.width * lhs.boundingBox.height
          let rhsArea = rhs.boundingBox.width * rhs.boundingBox.height
          return lhsArea > rhsArea
        }
        .first(where: { $0.symbology == .qr })?
        .payloadStringValue
    } catch {
      return nil
    }
  }

  private func qrCandidateImages(from image: CGImage) -> [CGImage] {
    var candidates: [CGImage] = [image]
    let width = image.width
    let height = image.height

    let cropRects = [
      CGRect(x: CGFloat(width) * 0.35, y: CGFloat(height) * 0.35, width: CGFloat(width) * 0.65, height: CGFloat(height) * 0.65),
      CGRect(x: CGFloat(width) * 0.45, y: CGFloat(height) * 0.45, width: CGFloat(width) * 0.55, height: CGFloat(height) * 0.55),
      CGRect(x: 0, y: CGFloat(height) * 0.4, width: CGFloat(width), height: CGFloat(height) * 0.6),
      CGRect(x: CGFloat(width) * 0.25, y: CGFloat(height) * 0.5, width: CGFloat(width) * 0.75, height: CGFloat(height) * 0.5),
    ]

    for rect in cropRects {
      let integralRect = rect.integral
      if let cropped = image.cropping(to: integralRect) {
        candidates.append(cropped)
      }
    }

    return candidates
  }

  private func detectQrPayloadWithCoreImage(
    in image: CGImage,
    orientation: CGImagePropertyOrientation
  ) -> String? {
    let options: [String: Any] = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
    guard let detector = CIDetector(
      ofType: CIDetectorTypeQRCode,
      context: nil,
      options: options
    ) else {
      return nil
    }

    let ciImage = CIImage(cgImage: image).oriented(forExifOrientation: Int32(orientation.rawValue))
    let features = detector.features(in: ciImage)
    for feature in features {
      if let qrFeature = feature as? CIQRCodeFeature,
         let message = qrFeature.messageString,
         !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        return message
      }
    }
    return nil
  }

  private func cgImageOrientation(from orientation: UIImage.Orientation) -> CGImagePropertyOrientation {
    switch orientation {
    case .up:
      return .up
    case .down:
      return .down
    case .left:
      return .left
    case .right:
      return .right
    case .upMirrored:
      return .upMirrored
    case .downMirrored:
      return .downMirrored
    case .leftMirrored:
      return .leftMirrored
    case .rightMirrored:
      return .rightMirrored
    @unknown default:
      return .up
    }
  }
}
