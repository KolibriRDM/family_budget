class FinancialProfileModel {
  const FinancialProfileModel({
    required this.activeDays,
    required this.currentStreakDays,
    required this.totalOperations,
    required this.incomeOperations,
    required this.expenseOperations,
    required this.categorizedOperationsRatio,
    required this.expensesWithReceiptsRatio,
    required this.manuallyCorrectedReceiptsRatio,
    required this.averageDailyExpense,
    required this.averageDailyIncome,
    required this.balanceStabilityScore,
    required this.debtMonthlyPayment,
    required this.debtRemainingAmount,
    required this.debtToIncomeRatio,
    required this.debtRemainderAfterPayments,
    required this.debtRiskLevel,
    required this.debtRiskLabel,
    required this.awarenessIndex,
    required this.awarenessLevel,
  });

  final int activeDays;
  final int currentStreakDays;
  final int totalOperations;
  final int incomeOperations;
  final int expenseOperations;
  final double categorizedOperationsRatio;
  final double expensesWithReceiptsRatio;
  final double manuallyCorrectedReceiptsRatio;
  final double averageDailyExpense;
  final double averageDailyIncome;
  final double balanceStabilityScore;
  final double debtMonthlyPayment;
  final double debtRemainingAmount;
  final double debtToIncomeRatio;
  final double debtRemainderAfterPayments;
  final String debtRiskLevel;
  final String debtRiskLabel;
  final int awarenessIndex;
  final String awarenessLevel;

  factory FinancialProfileModel.fromJson(Map<String, dynamic> json) {
    return FinancialProfileModel(
      activeDays: json['active_days'] as int? ?? 0,
      currentStreakDays: json['current_streak_days'] as int? ?? 0,
      totalOperations: json['total_operations'] as int? ?? 0,
      incomeOperations: json['income_operations'] as int? ?? 0,
      expenseOperations: json['expense_operations'] as int? ?? 0,
      categorizedOperationsRatio:
          (json['categorized_operations_ratio'] as num?)?.toDouble() ?? 0,
      expensesWithReceiptsRatio:
          (json['expenses_with_receipts_ratio'] as num?)?.toDouble() ?? 0,
      manuallyCorrectedReceiptsRatio:
          (json['manually_corrected_receipts_ratio'] as num?)?.toDouble() ?? 0,
      averageDailyExpense:
          (json['average_daily_expense'] as num?)?.toDouble() ?? 0,
      averageDailyIncome:
          (json['average_daily_income'] as num?)?.toDouble() ?? 0,
      balanceStabilityScore:
          (json['balance_stability_score'] as num?)?.toDouble() ?? 0,
      debtMonthlyPayment:
          (json['debt_monthly_payment'] as num?)?.toDouble() ?? 0,
      debtRemainingAmount:
          (json['debt_remaining_amount'] as num?)?.toDouble() ?? 0,
      debtToIncomeRatio:
          (json['debt_to_income_ratio'] as num?)?.toDouble() ?? 0,
      debtRemainderAfterPayments:
          (json['debt_remainder_after_payments'] as num?)?.toDouble() ?? 0,
      debtRiskLevel: json['debt_risk_level'] as String? ?? 'low',
      debtRiskLabel:
          json['debt_risk_label'] as String? ?? 'Низкая нагрузка',
      awarenessIndex: json['awareness_index'] as int? ?? 0,
      awarenessLevel:
          json['awareness_level'] as String? ?? 'Низкая осознанность',
    );
  }

  int get categorizedOperationsPercent =>
      (categorizedOperationsRatio * 100).round();

  int get expensesWithReceiptsPercent =>
      (expensesWithReceiptsRatio * 100).round();

  int get balanceStabilityPercent => (balanceStabilityScore * 100).round();

  int get debtToIncomePercent => (debtToIncomeRatio * 100).round();
}
