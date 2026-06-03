import 'package:auto_route/auto_route.dart';
import 'package:family_budget/app/app_router/app_router.dart';
import 'package:family_budget/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:family_budget/gen/strings.g.dart';

@RoutePage()
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  // Используем TranslationBuilder для динамического обновления при смене языка
  static List<PageRouteInfo> _getRoutes(BuildContext context) {
    return [
      const DiagramRoute(),
      const CalculatorRoute(),
      const CreditSimulatorRoute(),
      const ProfileRoute(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      context.router.replace(_getRoutes(context)[index]); // Переключаем экран
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final t = context.t;
      return AutoRouter(
        builder: (context, child) {
          return RootScaffold(
            child: child,
          );
        },
      );
    });
  }
}
