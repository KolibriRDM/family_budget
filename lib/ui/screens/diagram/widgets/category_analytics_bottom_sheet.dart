import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/data/models/expense_model.dart';
import 'package:family_budget/data/repositories/category_repository.dart';
import 'package:family_budget/helpers/extensions.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:family_budget/widgets/gif_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:family_budget/gen/strings.g.dart';
import 'dart:math' as math;

class CategoryAnalyticsBottomSheet extends StatefulWidget {
  final String categoryName;
  final Color categoryColor;
  final int categoryId;
  final String currency;
  final String icon;

  const CategoryAnalyticsBottomSheet({
    super.key,
    required this.categoryName,
    required this.categoryColor,
    required this.categoryId,
    required this.currency,
    required this.icon,
  });

  @override
  State<CategoryAnalyticsBottomSheet> createState() =>
      _CategoryAnalyticsBottomSheetState();
}

class _CategoryAnalyticsBottomSheetState
    extends State<CategoryAnalyticsBottomSheet> {
  final _categoryRepository = getIt<CategoryRepository>();
  String _selectedTimeSegment = 'days';
  List<double> _statistics = List.empty(growable: true);
  List<ExpenseModel> _recentExpenses = List.empty(growable: true);
  bool _isLoading = true;
  List<DateTime> _dates = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final statistics = await _categoryRepository.getCategoryStatistics(
        widget.categoryId,
        _selectedTimeSegment,
      );
      final recentExpenses =
          await _categoryRepository.getRecentCategoryExpenses(
        widget.categoryId,
      );

      _dates = _generateDates();

      setState(() {
        _statistics = statistics;
        _recentExpenses = recentExpenses;
      });
    } catch (e) {
    } finally {
      await Future.delayed(Duration(milliseconds: 200));
      setState(() => _isLoading = false);
    }
  }

  List<DateTime> _generateDates() {
    final now = DateTime.now();
    switch (_selectedTimeSegment) {
      case 'days':
        return List.generate(
            7, (index) => now.subtract(Duration(days: 6 - index)));
      case 'weeks':
        // Находим понедельник текущей недели
        final monday = now.subtract(Duration(days: now.weekday - 1));
        return List.generate(
            7, (index) => monday.subtract(Duration(days: (6 - index) * 7)));
      case 'months':
        return List.generate(12, (index) {
          final month = now.month + (index) + 1;
          final year = now.year + (month <= 0 ? -1 : 0);
          final adjustedMonth = month <= 0 ? month + 12 : month;
          return DateTime(year, adjustedMonth, 1);
        });
      default:
        return List.empty(growable: true);
    }
  }

  String _formatDate(DateTime date) {
    final tt = t.diagram;
    switch (_selectedTimeSegment) {
      case 'days':
        return DateFormat('dd.MM').format(date);
      case 'weeks':
        final endOfWeek = date.add(Duration(days: 6));
        return '${DateFormat('dd.MM').format(date)}\n${DateFormat('dd.MM').format(endOfWeek)}';
      case 'months':
        final months = [
          tt.januaryShort,
          tt.februaryShort,
          tt.marchShort,
          tt.aprilShort,
          tt.mayShort,
          tt.juneShort,
          tt.julyShort,
          tt.augustShort,
          tt.septemberShort,
          tt.octoberShort,
          tt.novemberShort,
          tt.decemberShort
        ];
        return months[date.month - 1];
      default:
        return '';
    }
  }

  Future<void> _changeTimeSegment(String segment) async {
    setState(() {
      _selectedTimeSegment = segment;
      _isLoading = true;
    });
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxHeight = MediaQuery.of(context).size.height * 0.8;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
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
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: widget.categoryColor.withOpacity(0.18),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              widget.icon,
                              height: 24,
                              width: 24,
                              color: widget.categoryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            widget.categoryName,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: AppColors.onSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      t.diagram.statistics,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.onSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTimeSegmentSelector(),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: _isLoading
                          ? Center(
                              child: SizedBox(
                                  height: 100, width: 100, child: LoadingGif()))
                          : _buildStatisticsChart(),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.diagram.lastTransactions,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.onSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _isLoading
                          ? Center(
                              child: SizedBox(
                                  height: 100, width: 100, child: LoadingGif()))
                          : _buildRecentExpensesList(),
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

  Widget _buildTimeSegmentSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimeSegmentRadio('days', t.diagram.daysBtn),
        _buildTimeSegmentRadio('weeks', t.diagram.weeksBtn),
        _buildTimeSegmentRadio('months', t.diagram.monthsBtn),
      ],
    );
  }

  Widget _buildTimeSegmentRadio(String value, String label) {
    final isSelected = _selectedTimeSegment == value;

    return InkWell(
      onTap: () => _changeTimeSegment(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? widget.categoryColor : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: widget.categoryColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? getIconColor(widget.categoryColor)
                : AppColors.onSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsChart() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // child: Padding(
      // padding: const EdgeInsets.only(right: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width < 350
            ? 400
            : MediaQuery.of(context).size.width - 48,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(enabled: false),
            gridData: FlGridData(
              show: true,
              horizontalInterval: 100,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: AppColors.onSecondary.withOpacity(0.1),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (value < 0 || value >= _dates.length) {
                      return const Text('');
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Transform.rotate(
                        angle: _dates.length == 12 ? -math.pi / 2 : 0,
                        child: Center(
                          child: Text(
                            _formatDate(_dates[value.toInt()]),
                            style: const TextStyle(
                              color: AppColors.onSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  reservedSize: _dates.length == 7 ? 40 : 30,
                ),
              ),
              leftTitles: AxisTitles(
                axisNameWidget: Text(widget.currency),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    if (value < 0 || value >= _statistics.length) {
                      return const Text('');
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        _statistics[value.toInt()].toStringAsFixed(0),
                        style: TextStyle(
                          color: widget.categoryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                  reservedSize: 20,
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                left: BorderSide(color: AppColors.onSecondary.withOpacity(0.2)),
                bottom:
                    BorderSide(color: AppColors.onSecondary.withOpacity(0.2)),
              ),
            ),
            minX: 0,
            maxX: _statistics.length - 1.0,
            minY: 0,
            maxY: _statistics.isEmpty
                ? 0
                : _statistics.reduce((a, b) => a > b ? a : b) * 1.4,
            lineBarsData: [
              LineChartBarData(
                preventCurveOverShooting: true,
                spots: List.generate(
                  _statistics.length,
                  (index) => FlSpot(index.toDouble(), _statistics[index]),
                ),
                isCurved: true,
                color: widget.categoryColor,
                barWidth: 3,
                isStrokeCapRound: false,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: widget.categoryColor,
                      strokeWidth: 1.5,
                      strokeColor: Colors.white,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: widget.categoryColor.withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
      // ),
    );
  }

  Widget _buildRecentExpensesList() {
    if (_recentExpenses.isEmpty) {
      return Center(
        child: Text(
          t.diagram.noTransactions,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.onSecondary,
              ),
        ),
      );
    }

    return ListView.builder(
      itemCount: _recentExpenses.length,
      itemBuilder: (context, index) {
        final expense = _recentExpenses[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: widget.categoryColor.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${expense.totalCount} ${widget.currency}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: widget.categoryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                expense.date?.formatColumnDate ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSecondary,
                    ),
              ),
            ],
          ),
        );
      },
    );
  }
}
