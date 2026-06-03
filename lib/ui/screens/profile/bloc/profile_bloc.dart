import 'package:bloc/bloc.dart';
import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/data/bloc_categories/categories_cubit.dart';
import 'package:family_budget/data/domain/common_state.dart';
import 'package:family_budget/data/models/achievement_model.dart';
import 'package:family_budget/data/models/expense_model.dart';
import 'package:family_budget/data/models/financial_profile_model.dart';
import 'package:family_budget/data/models/income_model.dart';
import 'package:family_budget/data/models/receipt_model.dart';
import 'package:family_budget/data/models/user_model.dart';
import 'package:family_budget/data/repositories/achievement_repository.dart';
import 'package:family_budget/data/repositories/expense_repository.dart';
import 'package:family_budget/data/repositories/financial_profile_repository.dart';
import 'package:family_budget/data/repositories/income_repository.dart';
import 'package:family_budget/data/repositories/user_repository.dart';
import 'package:family_budget/gen/strings.g.dart';
import 'package:family_budget/helpers/enums.dart';
import 'package:family_budget/helpers/mixins/error_handler_mixin.dart';
import 'package:family_budget/helpers/preferences.dart';
import 'package:family_budget/helpers/mixins/state_saver_mixin.dart';
import 'package:injectable/injectable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState>
    with
        ErrorHandlerMixin<ProfileEvent, ProfileState>,
        StateSaverMixin<ProfileEvent, ProfileState> {
  ProfileBloc(
    this.prefs,
    this.userRepository,
    this.expenseRepository,
    this.incomeRepository,
    this.financialProfileRepository,
    this.achievementRepository,
  ) : super(ProfileLoadingState()) {
    on<ProfileInitialEvent>(_onInitialEvent);
    on<ProfileInitExpenseEvent>(_onInitExpenseEvent);
    on<ProfileInitIncomeEvent>(_onInitIncomeEvent);
    on<ProfileInitReceiptScanEvent>(_onInitReceiptScanEvent);
    on<ProfileInitAchievementsEvent>(_onInitAchievementsEvent);
    on<ProfileAddExpenseEvent>(_onAddExpenseEvent);
    on<ProfileAddReceiptExpenseEvent>(_onAddReceiptExpenseEvent);
    on<ProfileAddIncomeEvent>(_onAddIncomeEvent);
    on<ProfileEditIncomeEvent>(_onEditIncomeEvent);
    on<ProfileDeleteIncomeEvent>(_onDeleteIncomeEvent);
  }

  final UserRepository userRepository;
  final ExpenseRepository expenseRepository;
  final IncomeRepository incomeRepository;
  final FinancialProfileRepository financialProfileRepository;
  final AchievementRepository achievementRepository;
  final Preferences prefs;

  UserModel? _currentUser;
  FinancialProfileModel? _financialProfile;
  List<AchievementModel> _achievements = List.empty(growable: true);
  List<IncomeModel> _incomesList = List.empty(growable: true);

  Future<void> _emitInitialState(Emitter<ProfileState> emit) async {
    emit(ProfileInitialState(
      user: _currentUser!,
      financialProfile: _financialProfile,
      achievements: _achievements,
      incomesList: _incomesList,
    ));
  }

  Future<void> _onInitialEvent(
      ProfileInitialEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      _currentUser = await userRepository.getCurrentUser();
      _incomesList = await incomeRepository.getAll();
      _financialProfile = await financialProfileRepository.getCurrentProfile();
      _achievements = await achievementRepository.getAll();
      await getIt<CategoriesCubit>().loadCategories();
      await _emitInitialState(emit);
    } catch (ex) {
      emitError(emit, t.profile.whatsWrong);
    }
  }

  Future<void> _onInitExpenseEvent(
      ProfileInitExpenseEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileAddExpenseState(expense: event.expense));
  }

  Future<void> _onInitIncomeEvent(
      ProfileInitIncomeEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileAddIncomeState(income: event.income));
  }

  Future<void> _onInitReceiptScanEvent(
      ProfileInitReceiptScanEvent event, Emitter<ProfileState> emit) async {
    emit(const ProfileReceiptScanState());
  }

  Future<void> _onInitAchievementsEvent(ProfileInitAchievementsEvent event,
      Emitter<ProfileState> emit) async {
    emit(ProfileAchievementsState(
      user: _currentUser!,
      achievements: _achievements,
    ));
  }

  Future<void> _onAddExpenseEvent(
      ProfileAddExpenseEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      await expenseRepository.createExpense(
          event.totalCount, event.categoryId, event.date);
      _currentUser = _currentUser!
          .copyWith(balance: _currentUser!.balance! - event.totalCount);
      _financialProfile = await financialProfileRepository.getCurrentProfile();
      _achievements = await achievementRepository.getAll();
      await _emitInitialState(emit);
    } catch (ex) {
      emitError(emit, t.profile.addExpenseErr);
      emit(oldState);
      rethrow;
    }
  }

  Future<void> _onAddIncomeEvent(
      ProfileAddIncomeEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      await incomeRepository.createIncome(
          event.totalCount, event.categoryId, event.date);
      _currentUser = _currentUser!
          .copyWith(balance: _currentUser!.balance! + event.totalCount);
      _incomesList = await incomeRepository.getAll();
      _financialProfile = await financialProfileRepository.getCurrentProfile();
      _achievements = await achievementRepository.getAll();
      await _emitInitialState(emit);
    } catch (ex) {
      emitError(emit, t.profile.addIncomeErr);
      emit(oldState);
      rethrow;
    }
  }

  Future<void> _onAddReceiptExpenseEvent(
      ProfileAddReceiptExpenseEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      await expenseRepository.createExpenseWithReceipt(
        totalCount: event.totalCount,
        categoryId: event.categoryId,
        date: event.date,
        receipt: event.receipt,
      );
      _currentUser = await userRepository.getCurrentUser();
      _financialProfile = await financialProfileRepository.getCurrentProfile();
      _achievements = await achievementRepository.getAll();
      await _emitInitialState(emit);
    } catch (ex) {
      emitError(emit, t.profile.addExpenseErr);
      emit(oldState);
      rethrow;
    }
  }

  Future<void> _onEditIncomeEvent(
      ProfileEditIncomeEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      await incomeRepository.updateIncome(
        event.incomeId,
        event.categoryId,
        event.totalCount,
        event.date,
      );
      _currentUser = await userRepository.getCurrentUser();
      _incomesList = await incomeRepository.getAll();
      _financialProfile = await financialProfileRepository.getCurrentProfile();
      _achievements = await achievementRepository.getAll();
      await _emitInitialState(emit);
    } catch (ex) {
      emitError(emit, t.profile.updateErr);
      emit(oldState);
      rethrow;
    }
  }

  Future<void> _onDeleteIncomeEvent(
      ProfileDeleteIncomeEvent event, Emitter<ProfileState> emit) async {
    emit(ProfileLoadingState());
    try {
      await incomeRepository.delete(event.incomeId);
      _currentUser = await userRepository.getCurrentUser();
      _incomesList.removeWhere((e) => e.id == event.incomeId);
      _financialProfile = await financialProfileRepository.getCurrentProfile();
      _achievements = await achievementRepository.getAll();
      await _emitInitialState(emit);
    } catch (ex) {
      emitError(emit, t.profile.deleteErr);
      emit(oldState);
      rethrow;
    }
  }

  @override
  ProfileState createErrorState(
      {required String message, required PageState pageState}) {
    return ProfileInfoState(message: message, pageState: pageState);
  }
}
