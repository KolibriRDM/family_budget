class ReceiptItemModel {
  const ReceiptItemModel({
    this.id,
    required this.name,
    required this.quantity,
    required this.lineTotal,
    this.unitPrice,
    this.isManuallyCorrected = false,
  });

  final int? id;
  final String name;
  final double quantity;
  final double lineTotal;
  final double? unitPrice;
  final bool isManuallyCorrected;

  ReceiptItemModel copyWith({
    int? id,
    String? name,
    double? quantity,
    double? lineTotal,
    double? unitPrice,
    bool? isManuallyCorrected,
  }) {
    return ReceiptItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      lineTotal: lineTotal ?? this.lineTotal,
      unitPrice: unitPrice ?? this.unitPrice,
      isManuallyCorrected: isManuallyCorrected ?? this.isManuallyCorrected,
    );
  }

  factory ReceiptItemModel.fromJson(Map<String, dynamic> json) {
    return ReceiptItemModel(
      id: json['id'] as int?,
      name: (json['name'] as String?) ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1,
      lineTotal: (json['line_total'] as num?)?.toDouble() ?? 0,
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
      isManuallyCorrected: (json['is_manually_corrected'] as bool?) ??
          ((json['is_manually_corrected'] as num?)?.toInt() == 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'line_total': lineTotal,
      'unit_price': unitPrice,
      'is_manually_corrected': isManuallyCorrected,
    };
  }
}
