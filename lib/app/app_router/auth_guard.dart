import 'package:auto_route/auto_route.dart';
import 'package:family_budget/helpers/preferences.dart';
import 'package:injectable/injectable.dart';

import 'app_router.dart';

@injectable
class AuthGuard extends AutoRouteGuard {
  const AuthGuard(this._prefs);

  final Preferences _prefs;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final isAuth = _prefs.checkToken();
    if (isAuth) {
      resolver.next();
    } else {
      resolver.redirect(
        AuthRoute(
          onAuthCompleted: resolver.next,
        ),
      );
    }
  }
}
