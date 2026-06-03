part of 'profile_bloc.dart';

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitialState extends ProfileState {
  final UserModel user;
  final FinancialProfileModel? financialProfile;
  final List<AchievementModel> achievements;
  final List<IncomeModel> incomesList;

  const ProfileInitialState({
    required this.user,
    required this.financialProfile,
    required this.achievements,
    required this.incomesList,
  });
}

class ProfileAddIncomeState extends ProfileState {
  final IncomeModel? income;

  const ProfileAddIncomeState({
    this.income,
  });
}

class ProfileAddExpenseState extends ProfileState {
  final ExpenseModel? expense;

  const ProfileAddExpenseState({
    this.expense,
  });
}

class ProfileReceiptScanState extends ProfileState {
  const ProfileReceiptScanState();
}

class ProfileAchievementsState extends ProfileState {
  final UserModel user;
  final List<AchievementModel> achievements;

  const ProfileAchievementsState({
    required this.user,
    required this.achievements,
  });
}

class ProfileLoadingState extends ProfileState implements LoadingState {}

class ProfileInfoState extends ProfileState implements InfoState {
  @override
  final String message;
  @override
  final PageState pageState;

  const ProfileInfoState({
    required this.message,
    required this.pageState,
  });
}
