import 'package:bloc/bloc.dart';
import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/data/bloc_categories/categories_cubit.dart';
import 'package:family_budget/data/models/analytics_model.dart';
import 'package:family_budget/data/models/expense_model.dart';
import 'package:family_budget/data/models/user_model.dart';
import 'package:family_budget/data/repositories/expense_repository.dart';
import 'package:family_budget/data/repositories/user_repository.dart';
import 'package:family_budget/helpers/enums.dart';
import 'package:family_budget/helpers/mixins/error_handler_mixin.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:family_budget/helpers/preferences.dart';
import 'package:family_budget/helpers/mixins/state_saver_mixin.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'diagram_event.dart';
part 'diagram_state.dart';

@injectable
class DiagramBloc extends Bloc<DiagramEvent, DiagramState>
    with
        ErrorHandlerMixin<DiagramEvent, DiagramState>,
        StateSaverMixin<DiagramEvent, DiagramState> {
  DiagramBloc(this.prefs, this.userRepository, this.expenseRepository)
      : super(DiagramLoadingState()) {
    on<DiagramInitialEvent>(_onInitialEvent);
    on<DiagramInitEditExpenseEvent>(_onInitEditExpenseEvent);
    on<DiagramEditExpenseEvent>(_onEditExpenseEvent);
    on<DiagramDeleteExpenseEvent>(_onDeleteExpenseEvent);
    on<DiagramSelectTypeViewEvent>(_onSelectTypeViewEvent);
    on<DiagramSetCustomPeriodEvent>(_onSetCustomPeriodEvent);
  }

  final UserRepository userRepository;
  final ExpenseRepository expenseRepository;
  final Preferences prefs;

  UserModel? _curUser;
  int type = 1;
  ({DateTime dateFrom, DateTime dateTo})? customPeriod;

  Future<void> _onInitialEvent(
      DiagramInitialEvent event, Emitter<DiagramState> emit) async {
    emit(DiagramLoadingState());

    try {
      _curUser ??= await userRepository.getCurrentUser();
      await getIt<CategoriesCubit>().loadCategories();
      await _getExpensesAndEmit(emit);
    } catch (ex) {
      emitError(emit, ex);
    }
  }

  Future<void> _onInitEditExpenseEvent(
      DiagramInitEditExpenseEvent event, Emitter<DiagramState> emit) async {
    emit(DiagramLoadingState());
    try {
      final newState = DiagramEditExpenseState(expense: event.expense);
      emit(newState);
    } catch (ex) {
      emitError(emit, ex);
    }
  }

  Future<void> _onEditExpenseEvent(
      DiagramEditExpenseEvent event, Emitter<DiagramState> emit) async {
    emit(DiagramLoadingState());
    try {
      await expenseRepository.updateExpense(
        event.expenseId,
        event.categoryId,
        event.totalCount,
        event.date,
      );
      await _getExpensesAndEmit(emit);
    } catch (ex) {
      emit(oldState);
      rethrow;
    }
  }

  Future<void> _onDeleteExpenseEvent(
      DiagramDeleteExpenseEvent event, Emitter<DiagramState> emit) async {
    emit(DiagramLoadingState());
    try {
      await expenseRepository.delete(event.expenseId);
      await _getExpensesAndEmit(emit);
    } catch (ex) {
      emit(oldState);
      rethrow;
    }
  }

  Future<void> _onSelectTypeViewEvent(
      DiagramSelectTypeViewEvent event, Emitter<DiagramState> emit) async {
    emit(DiagramLoadingState());
    try {
      type = event.type;
      // Сбрасываем customPeriod, если выбран День или Неделя
      if (type == 1 || type == 2) {
        customPeriod = null;
      }
      await _getExpensesAndEmit(emit);
    } catch (ex) {
      emitError(emit, ex);
    }
  }

  Future<void> _onSetCustomPeriodEvent(
      DiagramSetCustomPeriodEvent event, Emitter<DiagramState> emit) async {
    emit(DiagramLoadingState());
    try {
      type = 3;
      customPeriod = (dateFrom: event.dateFrom, dateTo: event.dateTo);
      await _getExpensesAndEmit(emit);
    } catch (ex) {
      emitError(emit, ex);
    }
  }

  Future<void> _getExpensesAndEmit(Emitter<DiagramState> emit) async {
    try {
      final dateRange = _getDateRange(type);
      final expenses = await expenseRepository.getAll(
        dateRange.dateFrom,
        dateRange.dateTo,
      );
      final processedData = await _processExpenses(expenses);
      _emitInitialState(emit, expenses, type, processedData);
    } catch (e) {
      rethrow;
    }
  }

  Future<AnalyticsData> _processExpenses(List<ExpenseModel> expenses) async {
    final colors = List<Color>.empty(growable: true);
    final titles = List<String>.empty(growable: true);
    final icons = List<String>.empty(growable: true);
    final totalCounts = List<double>.empty(growable: true);
    final transactionCounts = List<int>.empty(growable: true);
    final categoryIds = List<int>.empty(growable: true);
    double allCount = 0;

    for (final expense in expenses) {
      final categoryName = expense.category?.name ?? '';
      final categoryColor = hexToColor(expense.category?.color ?? '');
      final count = expense.totalCount ?? 0;

      if (!titles.contains(categoryName)) {
        titles.add(categoryName);
        colors.add(categoryColor);
        totalCounts.add(count);
        transactionCounts.add(1);
        categoryIds.add(expense.category?.id ?? 0);
        icons.add(expense.category?.icon ?? '');
      } else {
        final index = titles.indexOf(categoryName);
        totalCounts[index] += count;
        transactionCounts[index] += 1;
      }
      allCount += count;
    }

    return AnalyticsData(
      colors: colors,
      titles: titles,
      totalCounts: totalCounts,
      allCount: allCount,
      transactionCounts: transactionCounts,
      categoryIds: categoryIds,
      icons: icons,
    );
  }

  void _emitInitialState(
    Emitter<DiagramState> emit,
    List<ExpenseModel> expenses,
    int type,
    AnalyticsData analytics,
  ) {
    final newState = DiagramInitialState(
      currency: _curUser!.currency!,
      expensesList: expenses,
      type: type,
      analytics: analytics,
    );
    emit(newState);
  }

  @override
  DiagramState createErrorState(
      {required String message, required PageState pageState}) {
    return DiagramInfoState(message: message, pageState: pageState);
  }

  /// Получает диапазон дат в зависимости от выбранного типа
  ({DateTime dateFrom, DateTime dateTo}) _getDateRange(int type) {
    final now = DateTime.now();
    return switch (type) {
      1 => (dateFrom: now, dateTo: now),
      2 => (dateFrom: now.subtract(const Duration(days: 7)), dateTo: now),
      3 => customPeriod ??
          (dateFrom: now.subtract(const Duration(days: 30)), dateTo: now),
      _ => (dateFrom: now, dateTo: now),
    };
  }
}
