import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/gen/strings.g.dart';
import 'package:family_budget/helpers/enums.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:family_budget/ui/screens/auth/bloc/auth_bloc.dart';
import 'package:family_budget/ui/screens/auth/widgets/auth_login_screen.dart';
import 'package:family_budget/widgets/app_scaffold.dart';
import 'package:family_budget/widgets/gif_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_detail_screen.dart';

class AuthBodyScreen extends StatelessWidget {
  const AuthBodyScreen(
      {super.key, required this.authType, required this.onAuthCompleted});

  final AuthType authType;
  final Function() onAuthCompleted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocProvider<AuthBloc>(
        create: (context) => getIt<AuthBloc>()
          ..add(
            AuthInitEvent(authType: authType),
          ),
        child: BlocConsumer<AuthBloc, AuthState>(
          buildWhen: (previous, current) => current is! AuthInfoState,
          listener: (context, state) {
            if (state is AuthInfoState) {
              showMessage(
                message: state.message,
                type: state.pageState,
              );
            }
          },
          builder: (context, state) {
            return switch (state) {
              AuthLoadingState _ => AppScaffold(
                  child: LoadingGif(),
                ),
              AuthInitState s => AuthLoginScreen(
                  title: authType == AuthType.login
                      ? t.auth.signInTitle
                      : t.auth.registerTitle,
                  login: s.login,
                  pass: s.pass,
                  isError: s.isError,
                  onAuthCompleted: onAuthCompleted,
                ),
              AuthDetailState s => AuthDetailScreen(
                  login: s.login,
                  pass: s.pass,
                  onAuthCompleted: onAuthCompleted,
                ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
