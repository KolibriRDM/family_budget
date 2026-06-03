part of 'diagram_bloc.dart';

abstract class DiagramState {}

class DiagramLoadingState extends DiagramState {}

class DiagramInitialState extends DiagramState {
  final String currency;
  final List<ExpenseModel> expensesList;
  final int type;
  final AnalyticsData analytics;

  DiagramInitialState({
    required this.currency,
    required this.expensesList,
    required this.type,
    required this.analytics,
  });
}

class DiagramEditExpenseState extends DiagramState {
  final ExpenseModel expense;

  DiagramEditExpenseState({required this.expense});
}

class DiagramInfoState extends DiagramState {
  final String message;
  final PageState pageState;

  DiagramInfoState({
    required this.message,
    required this.pageState,
  });
}
