class CreditSimulationModel {
  const CreditSimulationModel({
    required this.obligationType,
    required this.loanAmount,
    required this.monthlyPayment,
    required this.totalPaid,
    required this.overpayment,
    required this.paymentToIncomeRatio,
    required this.paymentToFreeMoneyRatio,
    required this.expectedMonthlyRemainder,
    required this.riskLevel,
    required this.riskLabel,
    required this.explanation,
    required this.awarenessIndex,
    required this.safeMonthlyPayment,
    required this.behaviorNote,
    required this.scenarios,
    this.monthlyIncomeBase = 0,
    this.fixedOutflowBase = 0,
    this.currentDebtBase = 0,
  });

  final String obligationType;
  final double loanAmount;
  final double monthlyPayment;
  final double totalPaid;
  final double overpayment;
  final double paymentToIncomeRatio;
  final double paymentToFreeMoneyRatio;
  final double expectedMonthlyRemainder;
  final String riskLevel;
  final String riskLabel;
  final String explanation;
  final int awarenessIndex;
  final double safeMonthlyPayment;
  final String behaviorNote;
  final List<CreditSimulationScenarioModel> scenarios;
  final double monthlyIncomeBase;
  final double fixedOutflowBase;
  final double currentDebtBase;

  factory CreditSimulationModel.fromJson(Map<String, dynamic> json) {
    return CreditSimulationModel(
      obligationType: json['obligation_type'] as String? ?? 'credit',
      loanAmount: (json['loan_amount'] as num?)?.toDouble() ?? 0,
      monthlyPayment: (json['monthly_payment'] as num?)?.toDouble() ?? 0,
      totalPaid: (json['total_paid'] as num?)?.toDouble() ?? 0,
      overpayment: (json['overpayment'] as num?)?.toDouble() ?? 0,
      paymentToIncomeRatio:
          (json['payment_to_income_ratio'] as num?)?.toDouble() ?? 0,
      paymentToFreeMoneyRatio:
          (json['payment_to_free_money_ratio'] as num?)?.toDouble() ?? 0,
      expectedMonthlyRemainder:
          (json['expected_monthly_remainder'] as num?)?.toDouble() ?? 0,
      riskLevel: json['risk_level'] as String? ?? 'low',
      riskLabel: json['risk_label'] as String? ?? 'Низкая нагрузка',
      explanation: json['explanation'] as String? ?? '',
      awarenessIndex: json['awareness_index'] as int? ?? 0,
      safeMonthlyPayment:
          (json['safe_monthly_payment'] as num?)?.toDouble() ?? 0,
      behaviorNote: json['behavior_note'] as String? ?? '',
      scenarios: ((json['scenarios'] as List?) ?? const [])
          .whereType<Map>()
          .map((item) => CreditSimulationScenarioModel.fromJson(
                Map<String, dynamic>.from(item),
              ))
          .toList(),
      monthlyIncomeBase:
          (json['monthly_income_base'] as num?)?.toDouble() ?? 0,
      fixedOutflowBase:
          (json['fixed_outflow_base'] as num?)?.toDouble() ?? 0,
      currentDebtBase:
          (json['current_debt_base'] as num?)?.toDouble() ?? 0,
    );
  }

  int get paymentToIncomePercent => (paymentToIncomeRatio * 100).round();

  int get paymentToFreeMoneyPercent =>
      (paymentToFreeMoneyRatio * 100).round();
}

class CreditSimulationScenarioModel {
  const CreditSimulationScenarioModel({
    required this.name,
    required this.termMonths,
    required this.monthlyPayment,
    required this.note,
    this.overpayment = 0,
    this.expectedRemainder = 0,
  });

  final String name;
  final int termMonths;
  final double monthlyPayment;
  final String note;
  final double overpayment;
  final double expectedRemainder;

  factory CreditSimulationScenarioModel.fromJson(Map<String, dynamic> json) {
    return CreditSimulationScenarioModel(
      name: json['name'] as String? ?? '',
      termMonths: json['term_months'] as int? ?? 0,
      monthlyPayment: (json['monthly_payment'] as num?)?.toDouble() ?? 0,
      note: json['note'] as String? ?? '',
      overpayment: (json['overpayment'] as num?)?.toDouble() ?? 0,
      expectedRemainder:
          (json['expected_remainder'] as num?)?.toDouble() ?? 0,
    );
  }
}
