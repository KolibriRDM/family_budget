// import 'package:auto_route/auto_route.dart';
// import 'package:family_budget/ui/screens/auth/screen.dart';
// import 'package:family_budget/ui/screens/calculator/screen.dart';
// import 'package:family_budget/ui/screens/diagram/screen.dart';
// import 'package:family_budget/ui/screens/profile/screen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:injectable/injectable.dart';
//
// import 'auth_guard.dart';
//
// part 'app_router.gr.dart';
//
// BuildContext get globalContext => _navKey.currentContext!;
// final _navKey = GlobalKey<NavigatorState>();
//
// @injectable
// @AutoRouterConfig()
// class AppRouter extends RootStackRouter {
//   AppRouter(this._authGuard) : super(navigatorKey: _navKey);
//   final AuthGuard _authGuard;
//
//   @override
//   List<AutoRoute> get routes => [
//         AutoRoute(
//           page: AuthRoute.page,
//         ),
//         AutoRoute(
//           page: DiagramRoute.page,
//           guards: [_authGuard],
//           initial: true,
//         ),
//         AutoRoute(
//           page: CalculatorRoute.page,
//         ),
//         AutoRoute(page: ProfileRoute.page, guards: [_authGuard]),
//       ];
// }

import 'package:auto_route/auto_route.dart';
import 'package:family_budget/ui/navigator/cubit/navigator_cubit.dart';
import 'package:family_budget/ui/screens/auth/screen.dart';
import 'package:family_budget/ui/screens/calculator/screen.dart';
import 'package:family_budget/ui/screens/credit_simulator/screen.dart';
import 'package:family_budget/ui/screens/diagram/screen.dart';
import 'package:family_budget/ui/screens/profile/screen.dart';
import 'package:family_budget/ui/screens/root_screen.dart';
import 'package:family_budget/ui/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'auth_guard.dart';

part 'app_router.gr.dart';

BuildContext get globalContext => _navKey.currentContext!;
final _navKey = GlobalKey<NavigatorState>();

@injectable
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter(this._authGuard) : super(navigatorKey: _navKey);
  final AuthGuard _authGuard;

  @override
  RouteType get defaultRouteType => const CustomRouteType(
        customRouteBuilder: _tabRouteBuilder,
        durationInMilliseconds: 200,
      );

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: RootRoute.page,
          initial: true,
          children: [
            AutoRoute(page: AuthRoute.page),
            AutoRoute(
              page: CalculatorRoute.page,
            ),
            AutoRoute(page: CreditSimulatorRoute.page, guards: [_authGuard]),
            AutoRoute(
                page: DiagramRoute.page, guards: [_authGuard], initial: true),
            AutoRoute(page: ProfileRoute.page, guards: [_authGuard]),
          ],
        ),
        AutoRoute(page: SettingsRoute.page),
      ];
}

Route<T> _tabRouteBuilder<T>(
  BuildContext context,
  Widget child,
  AutoRoutePage<T> page,
) {
  final navigationCubit = context.read<NavigationCubit>();
  final currentTabIndex = navigationCubit.previousIndex;

  int toTabIndex = navigationCubit.state;

  // направление анимации
  final isForward = toTabIndex > currentTabIndex;

  return PageRouteBuilder<T>(
    settings: page,
    pageBuilder: (context, animation, secondaryAnimation) {
      return child;
    },
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // сдвиг
      final begin = isForward ? Offset(1.0, 0.0) : Offset(-1.0, 0.0);
      final end = Offset.zero;
      final slideCurve = Curves.easeInOut;
      var slideTween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: slideCurve));
      var slideAnimation = animation.drive(slideTween);

      // затухание
      final fadeCurve = Curves.linear;
      var fadeAnimation = CurvedAnimation(parent: animation, curve: fadeCurve);
      var fadeOutAnimation =
          CurvedAnimation(parent: secondaryAnimation, curve: fadeCurve);

      return SlideTransition(
        position: slideAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: FadeTransition(
            opacity:
                Tween<double>(begin: 1.0, end: 0.0).animate(fadeOutAnimation),
            child: child,
          ),
        ),
      );
    },
  );
}
