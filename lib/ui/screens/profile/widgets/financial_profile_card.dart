import 'package:family_budget/data/models/financial_profile_model.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:flutter/material.dart';

class FinancialProfileCard extends StatelessWidget {
  const FinancialProfileCard({
    super.key,
    required this.profile,
    required this.currency,
  });

  final FinancialProfileModel profile;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Финансовый след',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
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
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Text(
                  '${profile.awarenessIndex}',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.awarenessLevel,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Индекс финансовой осознанности',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.white.withOpacity(0.72),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _MetricStrip(
            items: [
              _MetricItem('Дни', '${profile.activeDays}'),
              _MetricItem('Серия', '${profile.currentStreakDays}'),
              _MetricItem('Операции', '${profile.totalOperations}'),
            ],
          ),
          const SizedBox(height: 10),
          _MetricStrip(
            items: [
              _MetricItem('Доходы', '${profile.incomeOperations}'),
              _MetricItem('Расходы', '${profile.expenseOperations}'),
              _MetricItem('Чеки', '${profile.expensesWithReceiptsPercent}%'),
            ],
          ),
          const SizedBox(height: 12),
          _ProgressLine(
            label: 'Стабильность баланса',
            percent: profile.balanceStabilityPercent,
          ),
          const SizedBox(height: 12),
          Text(
            'В среднем в день: -${profile.averageDailyExpense} $currency / +${profile.averageDailyIncome} $currency',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.white.withOpacity(0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricItem {
  const _MetricItem(this.label, this.value);

  final String label;
  final String value;
}

class _MetricStrip extends StatelessWidget {
  const _MetricStrip({required this.items});

  final List<_MetricItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: items.map((item) {
          final isLast = item == items.last;
          return Expanded(
            child: Container(
              padding: EdgeInsets.only(right: isLast ? 0 : 8),
              decoration: BoxDecoration(
                border: isLast
                    ? null
                    : Border(
                        right: BorderSide(
                          color: AppColors.white.withOpacity(0.08),
                        ),
                      ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    item.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.white.withOpacity(0.62),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    required this.label,
    required this.percent,
  });

  final String label;
  final int percent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodySmall),
            Text('$percent%', style: theme.textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            minHeight: 7,
            value: percent / 100,
            backgroundColor: AppColors.background,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ],
    );
  }
}
