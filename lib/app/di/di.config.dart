// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:family_budget/app/app_router/app_router.dart' as _i185;
import 'package:family_budget/app/app_router/auth_guard.dart' as _i1057;
import 'package:family_budget/app/di/di.dart' as _i837;
import 'package:family_budget/data/api_client.dart' as _i789;
import 'package:family_budget/data/api_service.dart' as _i825;
import 'package:family_budget/data/bloc_categories/categories_cubit.dart'
    as _i240;
import 'package:family_budget/data/repositories/achievement_repository.dart'
    as _i561;
import 'package:family_budget/data/repositories/auth_repository.dart' as _i380;
import 'package:family_budget/data/repositories/category_repository.dart'
    as _i1018;
import 'package:family_budget/data/repositories/credit_simulator_repository.dart'
    as _i742;
import 'package:family_budget/data/repositories/currency_repository.dart'
    as _i197;
import 'package:family_budget/data/repositories/expense_repository.dart'
    as _i114;
import 'package:family_budget/data/repositories/financial_profile_repository.dart'
    as _i118;
import 'package:family_budget/data/repositories/income_repository.dart'
    as _i607;
import 'package:family_budget/data/repositories/user_repository.dart' as _i270;
import 'package:family_budget/helpers/preferences.dart' as _i149;
import 'package:family_budget/ui/navigator/cubit/navigator_cubit.dart' as _i359;
import 'package:family_budget/ui/navigator/navbar_listener.dart' as _i617;
import 'package:family_budget/ui/screens/auth/bloc/auth_bloc.dart' as _i450;
import 'package:family_budget/ui/screens/calculator/bloc/calc_bloc.dart'
    as _i595;
import 'package:family_budget/ui/screens/diagram/bloc/diagram_bloc.dart'
    as _i239;
import 'package:family_budget/ui/screens/profile/bloc/profile_bloc.dart'
    as _i302;
import 'package:flutter_dotenv/flutter_dotenv.dart' as _i170;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

const String _dev = 'dev';

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final appModule = _$AppModule();
    gh.singleton<_i359.NavigationCubit>(() => _i359.NavigationCubit());
    gh.lazySingleton<_i617.NavBarRoutesObserver>(
        () => _i617.NavBarRoutesObserver());
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => appModule.prefs(),
      registerFor: {_dev},
      preResolve: true,
    );
    await gh.singletonAsync<_i170.DotEnv>(
      () => appModule.dotEnvTest(),
      registerFor: {_dev},
      preResolve: true,
    );
    gh.lazySingleton<_i149.Preferences>(
        () => _i149.Preferences(gh<_i460.SharedPreferences>()));
    gh.factory<_i1057.AuthGuard>(
        () => _i1057.AuthGuard(gh<_i149.Preferences>()));
    gh.lazySingleton<_i789.ApiClient>(() => _i789.ApiClient(
          gh<_i149.Preferences>(),
          gh<_i170.DotEnv>(),
        ));
    gh.factory<_i185.AppRouter>(() => _i185.AppRouter(gh<_i1057.AuthGuard>()));
    gh.lazySingleton<_i825.ApiService>(
        () => _i825.ApiService(gh<_i789.ApiClient>()));
    gh.lazySingleton<_i1018.CategoryRepository>(
        () => _i1018.CategoryRepository(gh<_i825.ApiService>()));
    gh.lazySingleton<_i607.IncomeRepository>(
        () => _i607.IncomeRepository(gh<_i825.ApiService>()));
    gh.lazySingleton<_i197.CurrencyRepository>(
        () => _i197.CurrencyRepository(gh<_i825.ApiService>()));
    gh.lazySingleton<_i380.AuthRepository>(
        () => _i380.AuthRepository(gh<_i825.ApiService>()));
    gh.lazySingleton<_i270.UserRepository>(
        () => _i270.UserRepository(gh<_i825.ApiService>()));
    gh.lazySingleton<_i114.ExpenseRepository>(
        () => _i114.ExpenseRepository(gh<_i825.ApiService>()));
    gh.lazySingleton<_i118.FinancialProfileRepository>(
        () => _i118.FinancialProfileRepository(gh<_i825.ApiService>()));
    gh.lazySingleton<_i561.AchievementRepository>(
        () => _i561.AchievementRepository(gh<_i825.ApiService>()));
    gh.lazySingleton<_i742.CreditSimulatorRepository>(
        () => _i742.CreditSimulatorRepository(gh<_i825.ApiService>()));
    gh.factory<_i239.DiagramBloc>(() => _i239.DiagramBloc(
          gh<_i149.Preferences>(),
          gh<_i270.UserRepository>(),
          gh<_i114.ExpenseRepository>(),
        ));
    gh.factory<_i302.ProfileBloc>(() => _i302.ProfileBloc(
          gh<_i149.Preferences>(),
          gh<_i270.UserRepository>(),
          gh<_i114.ExpenseRepository>(),
          gh<_i607.IncomeRepository>(),
          gh<_i118.FinancialProfileRepository>(),
          gh<_i561.AchievementRepository>(),
        ));
    gh.factory<_i595.CalculatorBloc>(
        () => _i595.CalculatorBloc(gh<_i197.CurrencyRepository>()));
    gh.factory<_i450.AuthBloc>(() => _i450.AuthBloc(
          gh<_i149.Preferences>(),
          gh<_i270.UserRepository>(),
          gh<_i380.AuthRepository>(),
        ));
    gh.singleton<_i240.CategoriesCubit>(
        () => _i240.CategoriesCubit(gh<_i1018.CategoryRepository>()));
    return this;
  }
}

class _$AppModule extends _i837.AppModule {}
