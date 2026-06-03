import 'dart:math' as math;

import 'package:auto_route/annotations.dart';
import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/data/models/credit_simulation_model.dart';
import 'package:family_budget/data/models/debt_obligation_model.dart';
import 'package:family_budget/data/models/financial_profile_model.dart';
import 'package:family_budget/data/repositories/credit_simulator_repository.dart';
import 'package:family_budget/data/repositories/financial_profile_repository.dart';
import 'package:family_budget/helpers/enums.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:family_budget/widgets/app_button.dart';
import 'package:family_budget/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CreditSimulatorScreen extends StatefulWidget {
  const CreditSimulatorScreen({super.key});

  @override
  State<CreditSimulatorScreen> createState() => _CreditSimulatorScreenState();
}

class _CreditSimulatorScreenState extends State<CreditSimulatorScreen> {
  final _amountController = TextEditingController(text: '500000');
  final _rateController = TextEditingController(text: '16');
  final _termController = TextEditingController(text: '36');
  final _initialController = TextEditingController(text: '0');
  final _safetyController = TextEditingController(text: '10000');
  late final TextEditingController _incomeController;
  late final TextEditingController _expensesController;

  final List<DebtObligationModel> _obligations = []; 

  FinancialProfileModel? _profile; 
  String _type = 'credit';  
  bool _loadingProfile = true;  
  bool _calculating = false;
  CreditSimulationModel? _simulation;
 
  @override
  void initState() {
    super.initState();
    _incomeController = TextEditingController();
    _expensesController = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    _termController.dispose();
    _initialController.dispose();
    _incomeController.dispose();
    _expensesController.dispose();
    _safetyController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final profile = await getIt<FinancialProfileRepository>().getCurrentProfile();
      final obligations = await getIt<CreditSimulatorRepository>().getObligations();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _obligations
          ..clear()
          ..addAll(obligations);
        _incomeController.text = (profile.averageDailyIncome * 30).round().toString();
        _expensesController.text =
            (profile.averageDailyExpense * 30).round().toString();
        _loadingProfile = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingProfile = false);
    }
  }

  double _money(TextEditingController controller) =>
      double.tryParse(controller.text.replaceAll(',', '.')) ?? 0;

  double get _monthlyIncome => _money(_incomeController);

  double get _monthlyExpenses => _money(_expensesController);

  double get _totalDebtPayment =>
      _obligations.fold(0.0, (sum, item) => sum + item.monthlyPayment);

  double get _totalDebtAmount =>
      _obligations.fold(0.0, (sum, item) => sum + item.remainingAmount);

  double get _freeMoney => _monthlyIncome - _monthlyExpenses;

  double get _remainderAfterDebt => _freeMoney - _totalDebtPayment;

  double get _debtToIncomeRatio =>
      _monthlyIncome > 0 ? _totalDebtPayment / _monthlyIncome : 0;

  _RiskState get _risk {
    if (_monthlyIncome <= 0 && _totalDebtPayment > 0) {
      return _RiskState.critical;
    }
    if (_debtToIncomeRatio > 0.5 || _remainderAfterDebt < 0) {
      return _RiskState.critical;
    }
    if (_debtToIncomeRatio > 0.3) return _RiskState.high;
    if (_debtToIncomeRatio > 0.2) return _RiskState.medium;
    return _RiskState.low;
  }

  void _calculate() {
    final term = int.tryParse(_termController.text) ?? 0;
    final principalAmount = _money(_amountController);
    final initialPayment = _money(_initialController);
    final loanAmount = principalAmount - initialPayment;
    if (principalAmount <= 0 || loanAmount <= 0 || _monthlyIncome <= 0 || term <= 0) {
      showMessage(
        message: 'Заполните сумму, доход и срок.',
        type: PageState.info,
      );
      return;
    }

    setState(() {
      _simulation = _buildLocalSimulation(
        loanAmount: loanAmount,
        annualRate: _money(_rateController),
        termMonths: term,
        initialPayment: initialPayment,
        safetyRemainder: _money(_safetyController),
      );
    });
  }

  Future<void> _openAddObligationSheet() async {
    final obligation = await showModalBottomSheet<DebtObligationModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddObligationSheet(),
    );
    if (obligation == null) return;
    try {
      final saved = await getIt<CreditSimulatorRepository>().createObligation(
        obligation,
      );
      if (!mounted) return;
      setState(() {
        _obligations.insert(0, saved);
        _simulation = null;
      });
    } catch (_) {
      showMessage(
        message: 'Не удалось сохранить обязательство.',
        type: PageState.error,
      );
    }
  }

  Future<void> _deleteObligation(int index) async {
    final obligation = _obligations[index];
    final id = obligation.id;
    if (id == null) return;
    try {
      await getIt<CreditSimulatorRepository>().deleteObligation(id);
      if (!mounted) return;
      setState(() {
        _obligations.removeAt(index);
        _simulation = null;
      });
    } catch (_) {
      showMessage(
        message: 'Не удалось удалить обязательство.',
        type: PageState.error,
      );
    }
  }

  double _annuityPayment({
    required double loanAmount,
    required double annualRate,
    required int termMonths,
  }) {
    final monthlyRate = annualRate / 100 / 12;
    if (monthlyRate <= 0) {
      return loanAmount / termMonths;
    }

    final denominator = (1 - math.pow(1 + monthlyRate, -termMonths)).toDouble();
    return loanAmount * monthlyRate / denominator;
  }

  CreditSimulationModel _buildLocalSimulation({
    required double loanAmount,
    required double annualRate,
    required int termMonths,
    required double initialPayment,
    required double safetyRemainder,
  }) {
    final monthlyPayment = _annuityPayment(
      loanAmount: loanAmount,
      annualRate: annualRate,
      termMonths: termMonths,
    );
    final creditTotal = monthlyPayment * termMonths;
    final totalPaid = creditTotal + initialPayment;
    final overpayment = creditTotal - loanAmount;
    final currentExpensesWithDebt = _monthlyExpenses + _totalDebtPayment;
    final freeMoney = _monthlyIncome - currentExpensesWithDebt;
    final expectedRemainder = freeMoney - monthlyPayment;
    final paymentToIncomeRatio = monthlyPayment / _monthlyIncome;
    final paymentToFreeMoneyRatio =
        freeMoney > 0 ? monthlyPayment / freeMoney : 1.0;

    var riskLevel = 'low';
    if (paymentToIncomeRatio > 0.5 || expectedRemainder < 0) {
      riskLevel = 'critical';
    } else if (paymentToIncomeRatio > 0.3 ||
        paymentToFreeMoneyRatio > 0.7) {
      riskLevel = 'high';
    } else if (paymentToIncomeRatio > 0.2 ||
        expectedRemainder < safetyRemainder) {
      riskLevel = 'medium';
    }

    final profile = _profile;
    final awarenessIndex = profile?.awarenessIndex ?? 0;
    var incomeThreshold = 0.30;
    if (awarenessIndex < 40) {
      incomeThreshold = 0.25;
    } else if (awarenessIndex >= 70 &&
        (profile?.balanceStabilityScore ?? 0) >= 0.5) {
      incomeThreshold = 0.35;
    }
    final safeByIncome = _monthlyIncome * incomeThreshold;
    final safeByFreeMoney = math.max(0.0, freeMoney - safetyRemainder);
    final safePayment = math.max(0.0, math.min(safeByIncome, safeByFreeMoney));
    final shorterTerm = math.max(1, (termMonths * 0.75).round());
    final longerTerm = math.max(termMonths + 1, (termMonths * 1.25).round());
    final riskLabel = _riskLabel(riskLevel);
    CreditSimulationScenarioModel scenario(
      String name,
      int months,
      double payment,
      String note,
    ) {
      final paidByCredit = payment * months;
      return CreditSimulationScenarioModel(
        name: name,
        termMonths: months,
        monthlyPayment: payment,
        note: note,
        overpayment: math.max(0.0, paidByCredit - loanAmount),
        expectedRemainder: freeMoney - payment,
      );
    }

    return CreditSimulationModel(
      obligationType: _type,
      loanAmount: loanAmount,
      monthlyPayment: monthlyPayment,
      totalPaid: totalPaid,
      overpayment: overpayment,
      paymentToIncomeRatio: paymentToIncomeRatio,
      paymentToFreeMoneyRatio: paymentToFreeMoneyRatio,
      expectedMonthlyRemainder: expectedRemainder,
      riskLevel: riskLevel,
      riskLabel: riskLabel,
      explanation: '',
      awarenessIndex: awarenessIndex,
      safeMonthlyPayment: safePayment,
      behaviorNote: '',
      monthlyIncomeBase: _monthlyIncome,
      fixedOutflowBase: _monthlyExpenses,
      currentDebtBase: _totalDebtPayment,
      scenarios: [
        scenario(
          'Текущий сценарий',
          termMonths,
          monthlyPayment,
          riskLabel,
        ),
        scenario(
          'Безопаснее',
          termMonths,
          safePayment,
          'Платеж с учетом текущей нагрузки',
        ),
        scenario(
          'Быстрее закрыть',
          shorterTerm,
          _annuityPayment(
            loanAmount: loanAmount,
            annualRate: annualRate,
            termMonths: shorterTerm,
          ),
          'Меньше срок, выше ежемесячная нагрузка',
        ),
        scenario(
          'Мягче в месяц',
          longerTerm,
          _annuityPayment(
            loanAmount: loanAmount,
            annualRate: annualRate,
            termMonths: longerTerm,
          ),
          'Ниже платеж, выше общая переплата',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      appBar: AppBar(
        title: Text('Нагрузка', style: theme.textTheme.headlineLarge),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      statusBarPadding: false,
      willPop: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SummaryCard(
              risk: _risk,
              monthlyPayment: _totalDebtPayment,
              debtToIncomeRatio: _debtToIncomeRatio,
              remainder: _remainderAfterDebt,
              loading: _loadingProfile,
            ),
            const SizedBox(height: 14),
            _ObligationsCard(
              obligations: _obligations,
              totalDebtAmount: _totalDebtAmount,
              onAdd: _openAddObligationSheet,
              onDelete: _deleteObligation,
            ),
            const SizedBox(height: 14),
            _SimulatorCard(
              type: _type,
              amountController: _amountController,
              rateController: _rateController,
              termController: _termController,
              initialController: _initialController,
              incomeController: _incomeController,
              expensesController: _expensesController,
              safetyController: _safetyController,
              profile: _profile,
              isCalculating: _calculating,
              result: _simulation,
              onTypeChanged: (value) => setState(() => _type = value),
              onCalculate: _calculate,
            ),
          ],
        ),
      ),
    );
  }
}

enum _RiskState {
  low('Низкая нагрузка', AppColors.success),
  medium('Умеренная нагрузка', AppColors.checkStatus),
  high('Высокая нагрузка', AppColors.lightPrimary),
  critical('Критическая нагрузка', _softDanger);

  const _RiskState(this.label, this.color);

  final String label;
  final Color color;
}

const _softDanger = Color(0xFFE08A6A);
const _softDangerText = Color(0xFFFFB39A);

Color _riskColor(String level) {
  return switch (level) {
    'critical' => _softDanger,
    'high' => AppColors.lightPrimary,
    'medium' => AppColors.checkStatus,
    _ => AppColors.success,
  };
}

Color _moneyStateColor(double value) {
  return value < 0 ? _softDangerText : AppColors.success;
}

String _riskLabel(String level) {
  return switch (level) {
    'critical' => 'Критическая нагрузка',
    'high' => 'Высокая нагрузка',
    'medium' => 'Умеренная нагрузка',
    _ => 'Низкая нагрузка',
  };
}

String _moneyLabel(double value) => '${value.toStringAsFixed(0)} RUB';

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.risk,
    required this.monthlyPayment,
    required this.debtToIncomeRatio,
    required this.remainder,
    required this.loading,
  });

  final _RiskState risk;
  final double monthlyPayment;
  final double debtToIncomeRatio;
  final double remainder;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.lightPrimary,
            AppColors.primary,
            AppColors.complementaryBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.24),
            blurRadius: 18,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  loading ? 'Считаем нагрузку...' : risk.label,
                  style: theme.textTheme.displayMedium
                      ?.copyWith(color: AppColors.white),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: risk.color.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: risk.color.withOpacity(0.9)),
                ),
                child: Text(
                  '${(debtToIncomeRatio * 100).round()}%',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Платежи',
                  value: '${monthlyPayment.toStringAsFixed(0)} RUB',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryMetric(
                  label: 'После расходов',
                  value: '${remainder.toStringAsFixed(0)} RUB',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 64,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.16),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: theme.textTheme.titleMedium),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.white.withOpacity(0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _ObligationsCard extends StatelessWidget {
  const _ObligationsCard({
    required this.obligations,
    required this.totalDebtAmount,
    required this.onAdd,
    required this.onDelete,
  });

  final List<DebtObligationModel> obligations;
  final double totalDebtAmount;
  final VoidCallback onAdd;
  final ValueChanged<int> onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Текущие обязательства',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 3),
                    Text(
                      'Остаток: ${totalDebtAmount.toStringAsFixed(0)} RUB',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.white.withOpacity(0.64),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle_outline,
                    color: AppColors.lightPrimary),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (obligations.isEmpty)
            Text(
              'Добавьте кредит, ипотеку, рассрочку или долг.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.white.withOpacity(0.7),
              ),
            )
          else
            ...List.generate(
              obligations.length,
              (index) {
                final item = obligations[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.22),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.account_balance_wallet,
                              color: AppColors.lightPrimary, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title,
                                  style: theme.textTheme.bodyMedium),
                              const SizedBox(height: 2),
                              Text(
                                '${item.typeLabel} • ${item.monthsLeft} мес.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.white.withOpacity(0.64),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${item.monthlyPayment.toStringAsFixed(0)} RUB',
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.lightPrimary),
                            ),
                            GestureDetector(
                              onTap: () => onDelete(index),
                              child: Text(
                                'удалить',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: _softDangerText.withOpacity(0.82),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _SimulatorCard extends StatelessWidget {
  const _SimulatorCard({
    required this.type,
    required this.amountController,
    required this.rateController,
    required this.termController,
    required this.initialController,
    required this.incomeController,
    required this.expensesController,
    required this.safetyController,
    required this.profile,
    required this.isCalculating,
    required this.result,
    required this.onTypeChanged,
    required this.onCalculate,
  });

  final String type;
  final TextEditingController amountController;
  final TextEditingController rateController;
  final TextEditingController termController;
  final TextEditingController initialController;
  final TextEditingController incomeController;
  final TextEditingController expensesController;
  final TextEditingController safetyController;
  final FinancialProfileModel? profile;
  final bool isCalculating;
  final CreditSimulationModel? result;
  final ValueChanged<String> onTypeChanged;
  final VoidCallback onCalculate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Симулятор нового сценария',
              style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Расчет учитывает текущие платежи и ваш финансовый след.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.white.withOpacity(0.66),
            ),
          ),
          const SizedBox(height: 14),
          _ObligationTypeTabs(
            value: type,
            options: const [
              _TypeTabOption('credit', 'Кредит'),
              _TypeTabOption('mortgage', 'Ипотека'),
              _TypeTabOption('installment', 'Рассрочка'),
            ],
            onChanged: onTypeChanged,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _Input(controller: amountController, label: 'Сумма')),
              const SizedBox(width: 10),
              Expanded(child: _Input(controller: rateController, label: 'Ставка')),
            ],
          ),
          Row(
            children: [
              Expanded(child: _Input(controller: termController, label: 'Срок')),
              const SizedBox(width: 10),
              Expanded(child: _Input(controller: initialController, label: 'Взнос')),
            ],
          ),
          Row(
            children: [
              Expanded(child: _Input(controller: incomeController, label: 'Доход')),
              const SizedBox(width: 10),
              Expanded(child: _Input(controller: expensesController, label: 'Расходы')),
            ],
          ),
          _Input(controller: safetyController, label: 'Желаемый запас'),
          const SizedBox(height: 8),
          AppButton(
            title: isCalculating ? 'Считаем...' : 'Рассчитать сценарий',
            onPressed: onCalculate,
            isDisabled: isCalculating,
            gradientColors: const [
              AppColors.lightPrimary,
              AppColors.primary,
              AppColors.primary,
              AppColors.complementaryBlue,
            ],
          ),
          if (result != null) ...[
            const SizedBox(height: 14),
            _SimulationResult(result: result!),
          ],
        ],
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.white.withOpacity(0.62),
              ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary.withOpacity(0.45)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.lightPrimary),
          ),
        ),
      ),
    );
  }
}

class _TypeTabOption {
  const _TypeTabOption(this.value, this.label);

  final String value;
  final String label;
}

class _ObligationTypeTabs extends StatelessWidget {
  const _ObligationTypeTabs({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<_TypeTabOption> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 42,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.28)),
      ),
      child: Row(
        children: options.map((option) {
          final isSelected = option.value == value;
          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(option.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withOpacity(0.52)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.lightPrimary.withOpacity(0.72)
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  option.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? AppColors.white
                        : AppColors.white.withOpacity(0.68),
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SimulationResult extends StatelessWidget {
  const _SimulationResult({required this.result});

  final CreditSimulationModel result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final riskColor = _riskColor(result.riskLevel);
    final paymentLimit = result.safeMonthlyPayment > 0
        ? result.safeMonthlyPayment
        : result.monthlyPayment;
    final loadRatio = paymentLimit > 0
        ? (result.monthlyPayment / paymentLimit).clamp(0.0, 1.35).toDouble()
        : 1.0;
    final monthlyIncome = result.monthlyIncomeBase;
    final fixedOutflow = result.fixedOutflowBase;
    final currentDebt = result.currentDebtBase;
    final freeBeforeScenario = monthlyIncome - fixedOutflow - currentDebt;
    final deficit = math.max(0.0, -result.expectedMonthlyRemainder);
    final maxScenarioPayment = math.max(
      result.monthlyPayment,
      result.scenarios.fold<double>(
        0,
        (maxValue, item) => math.max(maxValue, item.monthlyPayment),
      ),
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  result.riskLabel,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: riskColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: riskColor.withOpacity(0.42)),
                ),
                child: Text(
                  '${result.paymentToIncomePercent}% дохода',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: riskColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _CashGapCard(
            freeBeforeScenario: freeBeforeScenario,
            monthlyPayment: result.monthlyPayment,
            remainder: result.expectedMonthlyRemainder,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 118,
            child: CustomPaint(
              painter: _LoadGaugePainter(
                ratio: loadRatio,
                color: riskColor,
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _moneyLabel(result.monthlyPayment),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'ежемесячный платеж',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.white.withOpacity(0.62),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (deficit > 0) ...[
            const SizedBox(height: 2),
            Text(
              'Дефицит ${_moneyLabel(deficit)} после расходов, текущих обязательств и нового платежа.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _softDangerText.withOpacity(0.86),
              ),
            ),
          ],
          if (result.scenarios.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text('Сценарии', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 10),
            ...result.scenarios.map(
              (scenario) => _ScenarioBar(
                scenario: scenario,
                maxPayment: maxScenarioPayment,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CashGapCard extends StatelessWidget {
  const _CashGapCard({
    required this.freeBeforeScenario,
    required this.monthlyPayment,
    required this.remainder,
  });

  final double freeBeforeScenario;
  final double monthlyPayment;
  final double remainder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remainderColor = _moneyStateColor(remainder);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _CompactValue(
              label: 'До сценария',
              value: _moneyLabel(freeBeforeScenario),
              color: freeBeforeScenario < 0
                  ? _softDangerText
                  : AppColors.white,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CompactValue(
              label: 'Новый платеж',
              value: _moneyLabel(monthlyPayment),
              color: AppColors.lightPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _CompactValue(
              label: 'После',
              value: _moneyLabel(remainder),
              color: remainderColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _CompactValue extends StatelessWidget {
  const _CompactValue({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.white.withOpacity(0.58),
          ),
        ),
      ],
    );
  }
}

class _LoadGaugePainter extends CustomPainter {
  const _LoadGaugePainter({
    required this.ratio,
    required this.color,
  });

  final double ratio;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 12.0;
    final rect = Rect.fromLTWH(
      strokeWidth,
      strokeWidth,
      size.width - strokeWidth * 2,
      size.height * 1.58,
    );
    final startAngle = math.pi;
    final sweepAngle = math.pi;
    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..color = AppColors.surface;
    final activePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(
        colors: [
          AppColors.success,
          AppColors.checkStatus,
          color,
        ],
      ).createShader(rect);

    canvas.drawArc(rect, startAngle, sweepAngle, false, backgroundPaint);
    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle * ratio.clamp(0.0, 1.0).toDouble(),
      false,
      activePaint,
    );

    if (ratio > 1) {
      final overflowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..color = _softDanger;
      canvas.drawArc(
        rect,
        startAngle + sweepAngle * 0.88,
        sweepAngle * 0.12,
        false,
        overflowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LoadGaugePainter oldDelegate) {
    return oldDelegate.ratio != ratio || oldDelegate.color != color;
  }
}

class _ScenarioBar extends StatelessWidget {
  const _ScenarioBar({
    required this.scenario,
    required this.maxPayment,
  });

  final CreditSimulationScenarioModel scenario;
  final double maxPayment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = maxPayment > 0
        ? (scenario.monthlyPayment / maxPayment).clamp(0.08, 1.0).toDouble()
        : 0.08;
    final remainder = scenario.expectedRemainder;
    final remainderColor = _moneyStateColor(remainder);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${scenario.name}, ${scenario.termMonths} мес.',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ),
              Text(
                _moneyLabel(scenario.monthlyPayment),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.lightPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: ratio,
              backgroundColor: AppColors.surface,
              valueColor:
                  const AlwaysStoppedAnimation(AppColors.lightPrimary),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'после платежа',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.white.withOpacity(0.58),
                  ),
                ),
              ),
              Text(
                _moneyLabel(remainder),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: remainderColor.withOpacity(
                    remainder < 0 ? 0.82 : 1,
                  ),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddObligationSheet extends StatefulWidget {
  const _AddObligationSheet();

  @override
  State<_AddObligationSheet> createState() => _AddObligationSheetState();
}

class _AddObligationSheetState extends State<_AddObligationSheet> {
  final _titleController = TextEditingController(text: 'Новый кредит');
  final _amountController = TextEditingController();
  final _paymentController = TextEditingController();
  final _monthsController = TextEditingController();
  String _type = 'credit';

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _paymentController.dispose();
    _monthsController.dispose();
    super.dispose();
  }

  double _money(TextEditingController controller) =>
      double.tryParse(controller.text.replaceAll(',', '.')) ?? 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        14,
        16,
        MediaQuery.of(context).viewInsets.bottom + 18,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.onSecondary.withOpacity(0.55),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Добавить обязательство',
                style: theme.textTheme.displaySmall),
            const SizedBox(height: 14),
            _ObligationTypeTabs(
              value: _type,
              options: const [
                _TypeTabOption('credit', 'Кредит'),
                _TypeTabOption('mortgage', 'Ипотека'),
                _TypeTabOption('installment', 'Рассрочка'),
                _TypeTabOption('debt', 'Долг'),
              ],
              onChanged: (value) => setState(() => _type = value),
            ),
            const SizedBox(height: 12),
            _Input(controller: _titleController, label: 'Название'),
            _Input(controller: _amountController, label: 'Остаток долга'),
            _Input(controller: _paymentController, label: 'Платеж в месяц'),
            _Input(controller: _monthsController, label: 'Осталось месяцев'),
            const SizedBox(height: 8),
            AppButton(
              title: 'Добавить',
              onPressed: () {
                final amount = _money(_amountController);
                final payment = _money(_paymentController);
                final months = int.tryParse(_monthsController.text) ?? 0;
                if (amount <= 0 || payment <= 0 || months <= 0) {
                  showMessage(
                    message: 'Заполните остаток, платеж и срок.',
                    type: PageState.info,
                  );
                  return;
                }
                Navigator.of(context).pop(
                  DebtObligationModel(
                    title: _titleController.text.trim().isEmpty
                        ? 'Обязательство'
                        : _titleController.text.trim(),
                    type: _type,
                    remainingAmount: amount,
                    monthlyPayment: payment,
                    monthsLeft: months,
                  ),
                );
              },
              gradientColors: const [
                AppColors.lightPrimary,
                AppColors.primary,
                AppColors.primary,
                AppColors.complementaryBlue,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.primary.withOpacity(0.28)),
  );
}
