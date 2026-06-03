import 'package:flutter/services.dart';

class ReceiptOcrService {
  static const MethodChannel _channel =
      MethodChannel('family_budget/receipt_ocr');

  Future<String> recognizeText(String imagePath) async {
    final result = await _channel.invokeMethod<String>('recognizeText', {
      'imagePath': imagePath,
    });
    return result ?? '';
  }
}
