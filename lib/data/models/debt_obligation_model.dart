class DebtObligationModel {
  const DebtObligationModel({
    this.id,
    required this.title,
    required this.type,
    required this.remainingAmount,
    required this.monthlyPayment,
    required this.monthsLeft,
  });

  final int? id;
  final String title;
  final String type;
  final double remainingAmount;
  final double monthlyPayment;
  final int monthsLeft;

  factory DebtObligationModel.fromJson(Map<String, dynamic> json) {
    return DebtObligationModel(
      id: json['id'] as int?,
      title: json['title'] as String? ?? 'Обязательство',
      type: json['type'] as String? ?? 'credit',
      remainingAmount:
          (json['remaining_amount'] as num?)?.toDouble() ?? 0,
      monthlyPayment:
          (json['monthly_payment'] as num?)?.toDouble() ?? 0,
      monthsLeft: json['months_left'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'type': type,
      'remaining_amount': remainingAmount,
      'monthly_payment': monthlyPayment,
      'months_left': monthsLeft,
    };
  }

  String get typeLabel {
    return switch (type) {
      'mortgage' => 'Ипотека',
      'installment' => 'Рассрочка',
      'debt' => 'Долг',
      _ => 'Кредит',
    };
  }
}
