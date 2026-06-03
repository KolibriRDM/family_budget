import 'package:auto_route/annotations.dart';
import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/gen/strings.g.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:family_budget/ui/screens/profile/bloc/profile_bloc.dart';
import 'package:family_budget/ui/screens/receipt_scan/screen.dart';
import 'package:family_budget/ui/screens/profile/widgets/add_expense_body.dart';
import 'package:family_budget/ui/screens/profile/widgets/add_income_body.dart';
import 'package:family_budget/ui/screens/profile/widgets/achievements_screen.dart';
import 'package:family_budget/widgets/app_scaffold.dart';
import 'package:family_budget/widgets/gif_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/profile_body.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider<ProfileBloc>(
      create: (_) => getIt<ProfileBloc>()..add(const ProfileInitialEvent()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listenWhen: (prev, cur) => cur is ProfileInfoState,
        listener: (context, state) {
          final info = state as ProfileInfoState;
          showMessage(message: info.message, type: info.pageState);
        },
        builder: (context, state) {
          return switch (state) {
            ProfileInitialState s =>
              ProfileBody(
                user: s.user,
                financialProfile: s.financialProfile,
                incomes: s.incomesList,
              ),
            ProfileAddIncomeState s => AddIncomeBody(income: s.income),
            ProfileAddExpenseState s => AddExpenseBody(expense: s.expense),
            ProfileReceiptScanState _ => const ReceiptScanScreen(),
            ProfileAchievementsState s =>
              AchievementsScreen(
                user: s.user,
                achievements: s.achievements,
              ),
            _ => _buildLoadingScaffold(theme),
          };
        },
      ),
    );
  }

  Widget _buildLoadingScaffold(ThemeData theme) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(t.profile.profile, style: theme.textTheme.headlineLarge),
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      statusBarPadding: false,
      willPop: false,
      child: LoadingGif(),
    );
  }
}
