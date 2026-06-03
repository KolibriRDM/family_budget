import 'package:family_budget/data/services/receipt_qr_parser_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses russian fiscal qr payload', () {
    const rawValue =
        't=20230223T1644&s=369.00&fn=3111680924&i=0000128734&fp=960440301856365&n=1';

    final result = ReceiptQrParserService().parse(rawValue);

    expect(result, isNotNull);
    expect(result!.totalAmount, 369.00);
    expect(result.receiptDateTime, DateTime(2023, 2, 23, 16, 44));
    expect(result.fiscalDriveNumber, '3111680924');
    expect(result.fiscalDocumentNumber, '0000128734');
    expect(result.fiscalSign, '960440301856365');
    expect(result.operationType, '1');
  });
}
