import 'package:bloc/bloc.dart';
import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/data/bloc_categories/categories_cubit.dart';
import 'package:family_budget/data/domain/common_state.dart';
import 'package:family_budget/data/models/user_model.dart';
import 'package:family_budget/data/repositories/auth_repository.dart';
import 'package:family_budget/data/repositories/user_repository.dart';
import 'package:family_budget/gen/strings.g.dart';
import 'package:family_budget/helpers/enums.dart';
import 'package:family_budget/helpers/mixins/error_handler_mixin.dart';
import 'package:family_budget/helpers/preferences.dart';
import 'package:family_budget/helpers/mixins/state_saver_mixin.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';

part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState>
    with
        ErrorHandlerMixin<AuthEvent, AuthState>,
        StateSaverMixin<AuthEvent, AuthState> {
  AuthBloc(this.prefs, this.userRepository, this.authRepository)
      : super(
          AuthLoadingState(),
        ) {
    oldState = AuthLoadingState();

    on<AuthInitEvent>(_onInitialEvent);
    on<AuthDetailEvent>(_onDetailEvent);
    on<OnAuthEvent>(_onAuthEvent);
  }

  final UserRepository userRepository;
  final AuthRepository authRepository;
  final Preferences prefs;
  UserModel? curUser;

  void _onInitialEvent(
    AuthInitEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    emit(AuthInitState(login: event.login ?? '', pass: event.pass ?? ''));
  }

  void _onDetailEvent(
    AuthDetailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());

    if (event.authType == AuthType.register) {
      try {
        final isExist = await authRepository.checkLogin(event.login);
        if (isExist) {
          emit(AuthInitState(
            login: event.login,
            pass: event.pass,
            isError: true,
          ));
        } else {
          emit(AuthDetailState(login: event.login, pass: event.pass));
        }
      } catch (ex) {
        emitError(emit, t.auth.loginBusy);
        emit(AuthInitState(
          login: event.login,
          pass: event.pass,
        ));
      }
    } else {
      try {
        await authRepository.login(event.login, event.pass);
        await getIt<CategoriesCubit>().loadCategories();
        event.onAuthCompleted();
      } catch (ex) {
        emitError(emit, t.auth.loginOrPassNotValidErr);
        emit(AuthInitState(
          login: event.login,
          pass: event.pass,
        ));
      }
    }
  }

  void _onAuthEvent(
    OnAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      await authRepository.register(
          event.login, event.pass, event.balance, event.currency);
      await getIt<CategoriesCubit>().loadCategories();
      event.onAuthCompleted();
    } catch (ex) {
      emit(oldState);
      rethrow;
    }
  }

  @override
  AuthState createErrorState(
      {required String message, required PageState pageState}) {
    return AuthInfoState(message: message, pageState: pageState);
  }
}
