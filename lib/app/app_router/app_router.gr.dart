// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AuthScreen]
class AuthRoute extends PageRouteInfo<AuthRouteArgs> {
  AuthRoute({
    Key? key,
    required dynamic Function() onAuthCompleted,
    List<PageRouteInfo>? children,
  }) : super(
         AuthRoute.name,
         args: AuthRouteArgs(key: key, onAuthCompleted: onAuthCompleted),
         initialChildren: children,
       );

  static const String name = 'AuthRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AuthRouteArgs>();
      return AuthScreen(key: args.key, onAuthCompleted: args.onAuthCompleted);
    },
  );
}

class AuthRouteArgs {
  const AuthRouteArgs({this.key, required this.onAuthCompleted});

  final Key? key;

  final dynamic Function() onAuthCompleted;

  @override
  String toString() {
    return 'AuthRouteArgs{key: $key, onAuthCompleted: $onAuthCompleted}';
  }
}

/// generated route for
/// [CalculatorScreen]
class CalculatorRoute extends PageRouteInfo<void> {
  const CalculatorRoute({List<PageRouteInfo>? children})
    : super(CalculatorRoute.name, initialChildren: children);

  static const String name = 'CalculatorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CalculatorScreen();
    },
  );
}

/// generated route for
/// [CreditSimulatorScreen]
class CreditSimulatorRoute extends PageRouteInfo<void> {
  const CreditSimulatorRoute({List<PageRouteInfo>? children})
    : super(CreditSimulatorRoute.name, initialChildren: children);

  static const String name = 'CreditSimulatorRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreditSimulatorScreen();
    },
  );
}

/// generated route for
/// [DiagramScreen]
class DiagramRoute extends PageRouteInfo<void> {
  const DiagramRoute({List<PageRouteInfo>? children})
    : super(DiagramRoute.name, initialChildren: children);

  static const String name = 'DiagramRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DiagramScreen();
    },
  );
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [RootScreen]
class RootRoute extends PageRouteInfo<void> {
  const RootRoute({List<PageRouteInfo>? children})
    : super(RootRoute.name, initialChildren: children);

  static const String name = 'RootRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RootScreen();
    },
  );
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}
