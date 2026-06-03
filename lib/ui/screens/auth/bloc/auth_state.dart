part of 'auth_bloc.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitState extends AuthState {
  final String? login;
  final String? pass;
  final bool? isError;

  AuthInitState({
    this.login,
    this.pass,
    this.isError,
  });
}

class AuthDetailState extends AuthState {
  final String login;
  final String pass;

  AuthDetailState({
    required this.login,
    required this.pass,
  });
}

class AuthLoadingState extends AuthState implements LoadingState {}

class AuthInfoState extends AuthState implements InfoState {
  @override
  final String message;
  @override
  final PageState pageState;

  AuthInfoState({
    required this.message,
    required this.pageState,
  });
}
