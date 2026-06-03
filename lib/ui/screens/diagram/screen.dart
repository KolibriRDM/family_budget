import 'package:auto_route/annotations.dart';
import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/helpers/extensions.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:family_budget/ui/screens/profile/widgets/add_expense_body.dart';
import 'package:family_budget/ui/screens/diagram/widgets/date_range_picker.dart';
import 'package:family_budget/widgets/app_scaffold.dart';
import 'package:family_budget/widgets/gif_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:family_budget/gen/strings.g.dart';

import 'bloc/diagram_bloc.dart';
import 'widgets/description_bottom_sheet.dart';
import 'widgets/diagram_body.dart';

@RoutePage()
class DiagramScreen extends StatelessWidget {
  const DiagramScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DiagramBloc>(
      create: (_) => getIt<DiagramBloc>()..add(const DiagramInitialEvent()),
      child: BlocConsumer<DiagramBloc, DiagramState>(
        listenWhen: (prev, cur) => cur is DiagramInfoState,
        listener: (context, state) {
          final info = state as DiagramInfoState;
          showMessage(message: info.message, type: info.pageState);
        },
        builder: (context, state) {
          return switch (state) {
            DiagramEditExpenseState s => AddExpenseBody(expense: s.expense),
            _ => _buildMainLayout(context, state),
          };
        },
      ),
    );
  }

  Widget _buildMainLayout(BuildContext context, DiagramState state) {
    final bloc = context.read<DiagramBloc>();
    final theme = Theme.of(context);

    return AppScaffold(
      appBar: AppBar(
        title: Text(t.diagram.diagram, style: theme.textTheme.headlineLarge),
        centerTitle: true,
        backgroundColor: AppColors.background,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () => _showDescription(context),
              child: SvgPicture.asset(
                'assets/icons/info.svg',
                color: AppColors.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      statusBarPadding: false,
      willPop: false,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withOpacity(0.18)),
            ),
            child: _FilterSelection(
              selectedType: bloc.type,
              customPeriod: bloc.customPeriod,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<DiagramBloc, DiagramState>(
              buildWhen: (previous, current) =>
                  current is DiagramLoadingState ||
                  current is DiagramInitialState,
              builder: (_, state) {
                return switch (state) {
                  DiagramLoadingState _ => AppScaffold(
                      child: LoadingGif(),
                    ),
                  DiagramInitialState s => DiagramBody(
                      currency: s.currency,
                      expenses: s.expensesList,
                      analyticsData: s.analytics,
                    ),
                  _ => const SizedBox.shrink(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDescription(BuildContext context) {
    final state = context.read<DiagramBloc>().state;
    if (state is DiagramInitialState) {
      showDescriptionBottomSheet(context, state.analytics);
    }
  }
}

class _FilterSelection extends StatelessWidget {
  const _FilterSelection({
    required this.selectedType,
    required this.customPeriod,
  });

  final int selectedType;
  final ({DateTime dateFrom, DateTime dateTo})? customPeriod;

  @override
  Widget build(BuildContext context) {
    final _options = [
      (t.diagram.dayBtn, 1, Icons.today),
      (t.diagram.weekBtn, 2, Icons.date_range),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ..._options.map((option) =>
            _buildFilterOption(context, option.$1, option.$2, option.$3)),
        _buildCustomPeriodOption(context),
      ],
    );
  }

  Widget _buildFilterOption(
      BuildContext context, String label, int type, IconData icon) {
    final isSelected = selectedType == type;
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => context
          .read<DiagramBloc>()
          .add(DiagramSelectTypeViewEvent(type: type)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.56)
              : AppColors.background,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: isSelected
                ? AppColors.lightPrimary.withOpacity(0.62)
                : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: isSelected
              ? theme.textTheme.labelMedium?.copyWith(color: Colors.white)
              : theme.textTheme.labelMedium,
        ),
      ),
    );
  }

  Widget _buildCustomPeriodOption(BuildContext context) {
    final isSelected = selectedType == 3;
    final theme = Theme.of(context);

    // Отображаем диапазон дат вместо слова "Период", если период выбран
    final text = customPeriod != null
        ? '${customPeriod!.dateFrom.formatShortDate} - ${customPeriod!.dateTo.formatShortDate}'
        : t.diagram.periodBtn;

    return InkWell(
      onTap: () => _showDateRangePicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.56)
              : AppColors.background,
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: isSelected
                ? AppColors.lightPrimary.withOpacity(0.62)
                : Colors.transparent,
          ),
        ),
        child: Text(
          text,
          style: isSelected
              ? theme.textTheme.labelMedium?.copyWith(color: Colors.white)
              : theme.textTheme.labelMedium,
        ),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) async {
    final dateRange = await showCustomDateRangePicker(
      context: context,
      customPeriod: customPeriod,
    );

    if (dateRange != null) {
      context.read<DiagramBloc>().add(
            DiagramSetCustomPeriodEvent(
              dateFrom: dateRange.dateFrom,
              dateTo: dateRange.dateTo,
            ),
          );
    }
  }
}
