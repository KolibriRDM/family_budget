import 'package:auto_route/auto_route.dart';
import 'package:family_budget/app/app_router/app_router.dart';
import 'package:family_budget/gen/strings.g.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hugeicons/hugeicons.dart';

import 'cubit/navigator_cubit.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final t = context.t;
      return Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: AppColors.onBackground.withOpacity(0.94),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          elevation: 0,
          currentIndex: context.watch<NavigationCubit>().state,
          type: BottomNavigationBarType.fixed,
          onTap: (i) async {
            final routesPerNavBarButton = [
              const DiagramRoute(),
              const CalculatorRoute(),
              const CreditSimulatorRoute(),
              const ProfileRoute(),
            ];
            context.router.replaceAll([
              routesPerNavBarButton[i].copyWith(queryParams: {
                'fromTab': context.read<NavigationCubit>().state.toString(),
                'toTab': i.toString(),
              })
            ]);
            context.read<NavigationCubit>().updateIndex(i);
          },
          backgroundColor: Colors.transparent,
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            color: AppColors.colorScheme.primary.withOpacity(0.7),
          ),
          unselectedItemColor: AppColors.colorScheme.primary.withOpacity(0.7),
          fixedColor: AppColors.colorScheme.secondary,
          items: [
            BottomNavigationBarItem(
              label: t.diagram.diagram,
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedBitcoinGraph,
                color: context.watch<NavigationCubit>().state == 0
                    ? AppColors.colorScheme.secondary
                    : AppColors.colorScheme.primary.withOpacity(0.7),
                size: 24.0,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/diagram.svg',
                height: 24,
                color: context.watch<NavigationCubit>().state == 0
                    ? AppColors.colorScheme.secondary
                    : AppColors.colorScheme.primary.withOpacity(0.7),
              ),
            ),
            BottomNavigationBarItem(
              label: t.calculator.calculator,
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedCalculate,
                color: context.watch<NavigationCubit>().state == 1
                    ? AppColors.colorScheme.secondary
                    : AppColors.colorScheme.primary.withOpacity(0.7),
                size: 24.0,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/calculator.svg',
                height: 24,
                color: context.watch<NavigationCubit>().state == 1
                    ? AppColors.colorScheme.secondary
                    : AppColors.colorScheme.primary.withOpacity(0.7),
              ),
            ),
            BottomNavigationBarItem(
              label: 'Нагрузка',
              icon: Icon(
                Icons.account_balance_wallet_outlined,
                color: context.watch<NavigationCubit>().state == 2
                    ? AppColors.colorScheme.secondary
                    : AppColors.colorScheme.primary.withOpacity(0.7),
                size: 24.0,
              ),
              activeIcon: Icon(
                Icons.account_balance_wallet,
                color: context.watch<NavigationCubit>().state == 2
                    ? AppColors.colorScheme.secondary
                    : AppColors.colorScheme.primary.withOpacity(0.7),
                size: 24.0,
              ),
            ),
            BottomNavigationBarItem(
              label: t.profile.profile,
              icon: HugeIcon(
                icon: HugeIcons.strokeRoundedUser,
                color: context.watch<NavigationCubit>().state == 3
                    ? AppColors.colorScheme.secondary
                    : AppColors.colorScheme.primary.withOpacity(0.7),
                size: 24.0,
              ),
              activeIcon: SvgPicture.asset(
                'assets/icons/profile.svg',
                height: 24,
                color: context.watch<NavigationCubit>().state == 3
                    ? AppColors.colorScheme.secondary
                    : AppColors.colorScheme.primary.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    });
  }
}
