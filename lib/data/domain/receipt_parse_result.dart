import 'package:family_budget/data/models/receipt_model.dart';

class ReceiptParseResult {
  const ReceiptParseResult({
    required this.receipt,
    this.warnings = const [],
  });

  final ReceiptModel receipt;
  final List<String> warnings;
}
