import 'package:family_budget/data/models/analytics_model.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:family_budget/gen/strings.g.dart';

Future<void> showDescriptionBottomSheet(
  BuildContext context,
  AnalyticsData analyticsData,
) {
  return showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    clipBehavior: Clip.hardEdge,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.sizeOf(context).height * 0.7,
    ),
    context: context,
    builder: (_) => _Body(
      analyticsData: analyticsData,
    ),
  );
}

class _Body extends StatelessWidget {
  const _Body({
    required this.analyticsData,
  });

  final AnalyticsData analyticsData;

  @override
  Widget build(BuildContext context) {
    final percents = _calculatePercents();
    final formattedTotal =
        NumberFormat('#,##0.00').format(analyticsData.allCount);
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.onSecondary.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 15, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        t.diagram.analytics,
                        style: theme.textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.diagram.allExpenses,
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: AppColors.onSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                color: AppColors.primary,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                formattedTotal,
                                style: theme.textTheme.displayLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      t.diagram.categoryExpenses,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: AppColors.onSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (analyticsData.titles.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: AppColors.onSecondary,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                t.diagram.noDataExpenses,
                                style: theme.textTheme.bodyLarge
                                    ?.copyWith(color: AppColors.onSecondary),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: List.generate(
                              analyticsData.titles.length,
                              (i) => Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildCategoryItem(
                                  context,
                                  analyticsData.colors[i],
                                  analyticsData.titles[i],
                                  analyticsData.totalCounts[i],
                                  percents[i],
                                  analyticsData.transactionCounts != null &&
                                          i <
                                              analyticsData
                                                  .transactionCounts!.length
                                      ? analyticsData.transactionCounts![i]
                                      : 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<double> _calculatePercents() {
    final percents = List<double>.empty(growable: true);
    double allPercents = 0;

    for (var i = 0; i < analyticsData.totalCounts.length; i++) {
      if (analyticsData.allCount == 0) {
        percents.add(0);
        continue;
      }

      final percent = double.parse(
          (analyticsData.totalCounts[i] * 100 / analyticsData.allCount)
              .toStringAsFixed(1));

      if (i != analyticsData.totalCounts.length - 1) {
        percents.add(percent);
        allPercents += percent;
      } else {
        percents.add(double.parse((100 - allPercents).toStringAsFixed(1)));
      }
    }
    return percents;
  }

  Widget _buildCategoryItem(
    BuildContext context,
    Color color,
    String title,
    double amount,
    double percent,
    int transactionCount,
  ) {
    final formattedAmount = NumberFormat('#,##0.00').format(amount);
    final screenWidth = MediaQuery.of(context).size.width - 48;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$percent%',
                  style: theme.textTheme.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              children: [
                Text(
                  formattedAmount,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: AppColors.onSurface),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.receipt_outlined,
                        size: 14,
                        color: color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatTransactionCount(transactionCount),
                        style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: AppColors.onSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Container(
                  height: 12,
                  width: double.infinity,
                  color: AppColors.onSecondary.withOpacity(0.2),
                ),
                Container(
                  height: 12,
                  width: (screenWidth - 24) * percent / 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.7),
                        color,
                        color.withOpacity(0.8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTransactionCount(int count) {
    if (count == 0) return '0 ${t.diagram.transactions}';

    if (count % 10 == 1 && count % 100 != 11) {
      return '$count транзакция';
    } else if ([2, 3, 4].contains(count % 10) &&
        ![12, 13, 14].contains(count % 100)) {
      return '$count транзакции';
    } else {
      return '$count транзакций';
    }
  }
}
