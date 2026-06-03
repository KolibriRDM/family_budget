import 'package:family_budget/data/domain/receipt_qr_data.dart';

class ReceiptQrParserService {
  ReceiptQrData? parse(String? rawValue) {
    if (rawValue == null || rawValue.trim().isEmpty) return null;

    final normalized = rawValue.trim();
    final params = <String, String>{};

    for (final part in normalized.split('&')) {
      final separatorIndex = part.indexOf('=');
      if (separatorIndex <= 0) continue;
      final key = part.substring(0, separatorIndex).trim().toLowerCase();
      final value = part.substring(separatorIndex + 1).trim();
      if (key.isEmpty || value.isEmpty) continue;
      params[key] = value;
    }

    return ReceiptQrData(
      rawValue: normalized,
      receiptDateTime: _parseDateTime(params['t']),
      totalAmount: _parseAmount(params['s']),
      fiscalDriveNumber: params['fn'],
      fiscalDocumentNumber: params['i'],
      fiscalSign: params['fp'],
      operationType: params['n'],
    );
  }

  DateTime? _parseDateTime(String? value) {
    if (value == null || value.isEmpty) return null;
    final match = RegExp(
      r'^(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})(\d{2})?$',
    ).firstMatch(value);
    if (match == null) return null;

    return DateTime(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
      int.parse(match.group(4)!),
      int.parse(match.group(5)!),
      int.tryParse(match.group(6) ?? '') ?? 0,
    );
  }

  double? _parseAmount(String? value) {
    if (value == null || value.isEmpty) return null;
    return double.tryParse(value.replaceAll(',', '.'));
  }
}
