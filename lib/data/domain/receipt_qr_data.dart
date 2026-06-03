class ReceiptQrData {
  const ReceiptQrData({
    required this.rawValue,
    this.receiptDateTime,
    this.totalAmount,
    this.fiscalDriveNumber,
    this.fiscalDocumentNumber,
    this.fiscalSign,
    this.operationType,
  });

  final String rawValue;
  final DateTime? receiptDateTime;
  final double? totalAmount;
  final String? fiscalDriveNumber;
  final String? fiscalDocumentNumber;
  final String? fiscalSign;
  final String? operationType;
}
