import 'package:family_budget/data/models/analytics_model.dart';
import 'package:family_budget/data/models/expense_model.dart';
import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/data/repositories/expense_repository.dart';
import 'package:family_budget/helpers/extensions.dart';
import 'package:family_budget/helpers/enums.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:family_budget/ui/screens/diagram/bloc/diagram_bloc.dart';
import 'package:family_budget/ui/screens/diagram/widgets/category_analytics_bottom_sheet.dart';
import 'package:family_budget/ui/screens/profile/widgets/receipt_details_bottom_sheet.dart';
import 'package:family_budget/widgets/confirm_dialog.dart';
import 'package:family_budget/widgets/custom_slider_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart' hide SlidableAction;
import 'package:flutter_svg/svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:family_budget/gen/strings.g.dart';

class DiagramBody extends StatelessWidget {
  const DiagramBody({
    super.key,
    required this.expenses,
    required this.currency,
    required this.analyticsData,
  });

  final List<ExpenseModel> expenses;
  final String currency;
  final AnalyticsData analyticsData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _ChartCard(
            analyticsData: analyticsData,
            currency: currency,
          ),
          const SizedBox(height: 14),
          if (expenses.isNotEmpty) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    t.diagram.listExpenses,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                Text(
                  '${expenses.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.white.withOpacity(0.62),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          Expanded(
            child: expenses.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: expenses
                          .map((expense) => _buildExpenseRow(context, expense))
                          .toList()
                          .separateBy(const SizedBox(height: 10)),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseRow(BuildContext context, ExpenseModel expense) {
    final color = hexToColor(expense.category?.color ?? '');
    final categoryIndex =
        analyticsData.titles.indexOf(expense.category?.name ?? '');
    final categoryColor =
        categoryIndex >= 0 ? analyticsData.colors[categoryIndex] : color;
    final theme = Theme.of(context);
    void openCategoryAnalytics() {
      if (categoryIndex < 0) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => CategoryAnalyticsBottomSheet(
          categoryName: analyticsData.titles[categoryIndex],
          categoryColor: categoryColor,
          categoryId: analyticsData.categoryIds[categoryIndex],
          currency: currency,
          icon: analyticsData.icons[categoryIndex],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: AppColors.black.withOpacity(0.12),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ]),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 56,
              width: double.infinity,
              color: AppColors.complementaryBlue,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Slidable(
              closeOnScroll: false,
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                extentRatio: 0.40,
                children: [
                  SlidableAction(
                    onPressed: (_) => context.read<DiagramBloc>().add(
                          DiagramInitEditExpenseEvent(expense: expense),
                        ),
                    backgroundColor: AppColors.complementaryBlue,
                    foregroundColor: Colors.white,
                    icon: SvgPicture.asset(
                      'assets/icons/edit_icon.svg',
                      height: 26,
                      width: 26,
                      color: getIconColor(color),
                    ),
                    label: t.diagram.changeBtn,
                    padding: EdgeInsets.zero,
                  ),
                  SlidableAction(
                    onPressed: (ctx) => showConfirmDialog(
                      context: ctx,
                      title: t.diagram.deletingExpense,
                      message:
                          '${t.diagram.youSureDeleteExpense}"${expense.date?.formatNumberDate}"?',
                      item: expense,
                      onConfirm: () => ctx.read<DiagramBloc>().add(
                            DiagramDeleteExpenseEvent(expenseId: expense.id!),
                          ),
                    ),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    icon: SvgPicture.asset(
                      'assets/icons/delete_icon.svg',
                      height: 26,
                      width: 26,
                      color: getIconColor(color),
                    ),
                    label: t.diagram.deleteBtn,
                    padding: EdgeInsets.zero,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ],
              ),
              child: Material(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.surface,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: openCategoryAnalytics,
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: categoryColor.withOpacity(0.18),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    expense.category?.icon ?? '',
                                    height: 24,
                                    width: 24,
                                    color: categoryColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    expense.category?.name ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${expense.totalCount} $currency',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppColors.white.withOpacity(0.62),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (expense.hasReceipt == true)
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    final receipt =
                                        await getIt<ExpenseRepository>()
                                            .getReceipt(expense.id!);
                                    if (!context.mounted) return;
                                    await showReceiptDetailsBottomSheet(context,
                                        receipt: receipt);
                                  } catch (_) {
                                    showMessage(
                                      message: 'Не удалось загрузить чек.',
                                      type: PageState.error,
                                    );
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.receipt_long,
                                    color: AppColors.lightPrimary,
                                    size: 20,
                                  ),
                                ),
                              ),
                            Text(
                              expense.date!.formatColumnDate,
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.white.withOpacity(0.72)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.analyticsData,
    required this.currency,
  });

  final AnalyticsData analyticsData;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasData = analyticsData.colors.isNotEmpty;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.18)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  t.diagram.categoryExpenses,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              Text(
                '${analyticsData.allCount.toStringAsFixed(0)} $currency',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.white.withOpacity(0.68),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: hasData
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 3,
                          centerSpaceRadius: 48,
                          startDegreeOffset: 90,
                          sections: List.generate(
                            analyticsData.colors.length,
                            (i) {
                              return PieChartSectionData(
                                color: analyticsData.colors[i],
                                value: analyticsData.totalCounts[i],
                                title: '',
                                radius: 54,
                              );
                            },
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            analyticsData.allCount.toStringAsFixed(0),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            currency,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppColors.white.withOpacity(0.58),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(
                    child: Text(
                      t.diagram.noExpenses,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.white.withOpacity(0.68),
                      ),
                    ),
                  ),
          ),
          if (hasData) ...[
            const SizedBox(height: 10),
            _CategoryLegendCloud(
              analyticsData: analyticsData,
              currency: currency,
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryLegendCloud extends StatelessWidget {
  const _CategoryLegendCloud({
    required this.analyticsData,
    required this.currency,
  });

  final AnalyticsData analyticsData;
  final String currency;

  int get _rowsCount {
    final count = analyticsData.colors.length;
    if (count <= 3) return 1;
    if (count <= 8) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final rowsCount = _rowsCount;
    final itemsPerRow = (analyticsData.colors.length / rowsCount).ceil();
    final rows = List.generate(rowsCount, (rowIndex) {
      final start = rowIndex * itemsPerRow;
      final end = (start + itemsPerRow).clamp(
        0,
        analyticsData.colors.length,
      );
      return List.generate(
        end - start,
        (index) => start + index,
      );
    }).where((row) => row.isNotEmpty).toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows.map((row) {
          final isLastRow = row == rows.last;
          return Padding(
            padding: EdgeInsets.only(bottom: isLastRow ? 0 : 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: row.map((index) {
                final isLast = index == row.last;
                return Padding(
                  padding: EdgeInsets.only(right: isLast ? 0 : 8),
                  child: _CategoryLegendChip(
                    analyticsData: analyticsData,
                    index: index,
                    currency: currency,
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CategoryLegendChip extends StatelessWidget {
  const _CategoryLegendChip({
    required this.analyticsData,
    required this.index,
    required this.currency,
  });

  final AnalyticsData analyticsData;
  final int index;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final color = analyticsData.colors[index];
    final share = analyticsData.allCount > 0
        ? analyticsData.totalCounts[index] / analyticsData.allCount
        : 0.0;
    final theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => CategoryAnalyticsBottomSheet(
            categoryName: analyticsData.titles[index],
            categoryColor: color,
            categoryId: analyticsData.categoryIds[index],
            currency: currency,
            icon: analyticsData.icons[index],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.32)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 7),
            Text(
              analyticsData.titles[index],
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.white.withOpacity(0.82),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${(share * 100).round()}%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.white.withOpacity(0.52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
