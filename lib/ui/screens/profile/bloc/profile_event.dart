part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

class ProfileInitialEvent extends ProfileEvent {
  const ProfileInitialEvent();
}

class ProfileInitExpenseEvent extends ProfileEvent {
  final ExpenseModel? expense;

  const ProfileInitExpenseEvent({
    this.expense,
  });
}

class ProfileInitIncomeEvent extends ProfileEvent {
  final IncomeModel? income;

  const ProfileInitIncomeEvent({
    this.income,
  });
}

class ProfileAddExpenseEvent extends ProfileEvent {
  final double totalCount;
  final int categoryId;
  final DateTime date;

  const ProfileAddExpenseEvent({
    required this.totalCount,
    required this.categoryId,
    required this.date,
  });
}

class ProfileAddIncomeEvent extends ProfileEvent {
  final double totalCount;
  final int categoryId;
  final DateTime date;

  const ProfileAddIncomeEvent({
    required this.totalCount,
    required this.categoryId,
    required this.date,
  });
}

class ProfileInitReceiptScanEvent extends ProfileEvent {
  const ProfileInitReceiptScanEvent();
}

class ProfileInitAchievementsEvent extends ProfileEvent {
  const ProfileInitAchievementsEvent();
}

class ProfileAddReceiptExpenseEvent extends ProfileEvent {
  final double totalCount;
  final int categoryId;
  final DateTime date;
  final ReceiptModel receipt;

  const ProfileAddReceiptExpenseEvent({
    required this.totalCount,
    required this.categoryId,
    required this.date,
    required this.receipt,
  });
}

class ProfileEditIncomeEvent extends ProfileEvent {
  final int incomeId;
  final int categoryId;
  final double totalCount;
  final DateTime date;

  const ProfileEditIncomeEvent({
    required this.incomeId,
    required this.categoryId,
    required this.totalCount,
    required this.date,
  });
}

class ProfileDeleteIncomeEvent extends ProfileEvent {
  final int incomeId;

  const ProfileDeleteIncomeEvent({
    required this.incomeId,
  });
}
