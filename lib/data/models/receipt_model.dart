import 'package:family_budget/data/models/receipt_item_model.dart';

class ReceiptModel {
  const ReceiptModel({
    this.id,
    this.expenseId,
    this.storeName,
    this.receiptDateTime,
    required this.totalAmount,
    this.currency = 'RUB',
    this.rawText,
    this.imagePath,
    this.isPartiallyRecognized = false,
    this.isManuallyCorrected = false,
    this.items = const [],
  });

  final int? id;
  final int? expenseId;
  final String? storeName;
  final DateTime? receiptDateTime;
  final double totalAmount;
  final String currency;
  final String? rawText;
  final String? imagePath;
  final bool isPartiallyRecognized;
  final bool isManuallyCorrected;
  final List<ReceiptItemModel> items;

  ReceiptModel copyWith({
    int? id,
    int? expenseId,
    String? storeName,
    DateTime? receiptDateTime,
    double? totalAmount,
    String? currency,
    String? rawText,
    String? imagePath,
    bool? isPartiallyRecognized,
    bool? isManuallyCorrected,
    List<ReceiptItemModel>? items,
  }) {
    return ReceiptModel(
      id: id ?? this.id,
      expenseId: expenseId ?? this.expenseId,
      storeName: storeName ?? this.storeName,
      receiptDateTime: receiptDateTime ?? this.receiptDateTime,
      totalAmount: totalAmount ?? this.totalAmount,
      currency: currency ?? this.currency,
      rawText: rawText ?? this.rawText,
      imagePath: imagePath ?? this.imagePath,
      isPartiallyRecognized:
          isPartiallyRecognized ?? this.isPartiallyRecognized,
      isManuallyCorrected: isManuallyCorrected ?? this.isManuallyCorrected,
      items: items ?? this.items,
    );
  }

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List?) ?? const [];
    return ReceiptModel(
      id: json['id'] as int?,
      expenseId: json['expense_id'] as int? ?? json['expenseId'] as int?,
      storeName: json['store_name'] as String? ?? json['storeName'] as String?,
      receiptDateTime: json['receipt_datetime'] != null
          ? DateTime.tryParse(json['receipt_datetime'] as String)
          : null,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ??
          (json['totalAmount'] as num?)?.toDouble() ??
          0,
      currency: (json['currency'] as String?) ?? 'RUB',
      rawText: json['raw_text'] as String? ?? json['rawText'] as String?,
      imagePath: json['image_path'] as String? ?? json['imagePath'] as String?,
      isPartiallyRecognized: (json['is_partially_recognized'] as bool?) ??
          ((json['is_partially_recognized'] as num?)?.toInt() == 1),
      isManuallyCorrected: (json['is_manually_corrected'] as bool?) ??
          ((json['is_manually_corrected'] as num?)?.toInt() == 1),
      items: rawItems
          .whereType<Map>()
          .map((item) =>
              ReceiptItemModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'expense_id': expenseId,
      'store_name': storeName,
      'receipt_datetime': receiptDateTime?.toIso8601String(),
      'total_amount': totalAmount,
      'currency': currency,
      'raw_text': rawText,
      'image_path': imagePath,
      'is_partially_recognized': isPartiallyRecognized,
      'is_manually_corrected': isManuallyCorrected,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}
