import 'package:flutter/services.dart';

class ReceiptQrScannerService {
  static const MethodChannel _channel =
      MethodChannel('family_budget/receipt_ocr');

  Future<String?> recognizeQr(String imagePath) async {
    try {
      final result = await _channel.invokeMethod<String>('recognizeQr', {
        'imagePath': imagePath,
      });
      if (result == null || result.trim().isEmpty) {
        return null;
      }
      return result.trim();
    } on PlatformException {
      return null;
    }
  }
}
