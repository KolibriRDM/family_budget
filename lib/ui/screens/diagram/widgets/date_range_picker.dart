import 'package:family_budget/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:family_budget/gen/strings.g.dart';

Future<({DateTime dateFrom, DateTime dateTo})?> showCustomDateRangePicker({
  required BuildContext context,
  ({DateTime dateFrom, DateTime dateTo})? customPeriod,
}) async {
  // final t = Translations.of(context);
  final now = DateTime.now();
  final initialDateRange = customPeriod != null
      ? DateTimeRange(
          start: customPeriod.dateFrom,
          end: customPeriod.dateTo,
        )
      : DateTimeRange(
          start: now.subtract(const Duration(days: 30)),
          end: now,
        );

  final dateRange = await showDateRangePicker(
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    context: context,
    firstDate: DateTime(2020),
    lastDate: DateTime.now().add(const Duration(days: 1)),
    initialDateRange: initialDateRange,
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.copyWith(
                bodySmall: TextStyle(color: AppColors.onSecondary),
                bodyMedium: TextStyle(color: AppColors.onSecondary),
                bodyLarge: TextStyle(color: AppColors.onSecondary),
              ),
          colorScheme: ColorScheme.dark(
            primary: AppColors.colorScheme.primary,
            onPrimary: Colors.white,
            surface: AppColors.background,
            onSurface: AppColors.onSecondary,
            onSecondary: AppColors.onSecondary,
          ),
          dialogBackgroundColor: AppColors.background,
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
          datePickerTheme: DatePickerThemeData(
            headerForegroundColor: Colors.white,
            weekdayStyle: TextStyle(color: AppColors.onSecondary),
            dayForegroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return AppColors.onSecondary;
              },
            ),
            dayOverlayColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.colorScheme.primary;
                }
                return Colors.transparent;
              },
            ),
            todayForegroundColor:
                WidgetStateProperty.all(AppColors.onSecondary),
            todayBackgroundColor: WidgetStateProperty.all(Colors.transparent),
            todayBorder:
                BorderSide(color: AppColors.colorScheme.primary, width: 1),
            dayStyle: TextStyle(color: AppColors.onSecondary),
            rangePickerBackgroundColor: AppColors.background,
            rangeSelectionBackgroundColor:
                AppColors.colorScheme.primary.withOpacity(0.3),
            yearForegroundColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }
                return AppColors.onSecondary;
              },
            ),
            yearOverlayColor: WidgetStateProperty.resolveWith<Color>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.colorScheme.primary;
                }
                return Colors.transparent;
              },
            ),
            yearStyle: TextStyle(color: AppColors.onSecondary),
          ),
        ),
        child: child!,
      );
    },
    confirmText: t.diagram.confirmText,
    cancelText: t.diagram.cancelText,
    saveText: t.diagram.saveText,
    fieldStartHintText: t.diagram.fieldStartHintText,
    fieldEndHintText: t.diagram.fieldEndHintText,
  );

  if (dateRange != null) {
    return (
      dateFrom: dateRange.start,
      dateTo: dateRange.end,
    );
  }
  return null;
}

Future<DateTimeRange?> showMaterialDateRangePicker({
  required BuildContext context,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTimeRange? initialDateRange,
  Widget Function(BuildContext, Widget?)? builder,
}) {
  // final t = Translations.of(context);
  return showDateRangePicker(
    context: context,
    firstDate: firstDate,
    lastDate: lastDate,
    initialDateRange: initialDateRange,
    builder: builder,
    confirmText: t.diagram.confirmText,
    cancelText: t.diagram.cancelText,
    saveText: t.diagram.saveText,
    fieldStartHintText: t.diagram.fieldStartHintText,
    fieldEndHintText: t.diagram.fieldEndHintText,
  );
}
