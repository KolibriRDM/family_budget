import 'package:family_budget/app/app_router/app_router.dart';
import 'package:family_budget/data/models/financial_profile_model.dart';
import 'package:family_budget/data/models/income_model.dart';
import 'package:family_budget/data/models/user_model.dart';
import 'package:family_budget/gen/strings.g.dart';
import 'package:family_budget/helpers/extensions.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:family_budget/ui/screens/profile/bloc/profile_bloc.dart';
import 'package:family_budget/ui/screens/profile/widgets/financial_profile_card.dart';
import 'package:family_budget/ui/screens/profile/widgets/user_level_card.dart';
import 'package:family_budget/widgets/app_scaffold.dart';
import 'package:family_budget/widgets/confirm_dialog.dart';
import 'package:family_budget/widgets/custom_slider_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart' hide SlidableAction;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_route/auto_route.dart';
import 'package:hugeicons/hugeicons.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    super.key,
    required this.user,
    required this.financialProfile,
    required this.incomes,
  });

  final UserModel user;
  final FinancialProfileModel? financialProfile;
  final List<IncomeModel> incomes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppScaffold(
      appBar: AppBar(
        title: Text(t.profile.profile, style: theme.textTheme.headlineLarge),
        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<ProfileBloc>()
                  .add(const ProfileInitAchievementsEvent());
            },
            icon: const Icon(
              Icons.emoji_events_outlined,
              color: AppColors.onSecondary,
            ),
          ),
          IconButton(
            onPressed: () {
              context.router.push(const SettingsRoute());
            },
            icon: HugeIcon(
                icon: HugeIcons.strokeRoundedSettings01,
                color: AppColors.onSecondary),
          ),
        ],
        centerTitle: true,
        backgroundColor: AppColors.background,
      ),
      statusBarPadding: false,
      willPop: false, 
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProfileSummaryCard(user: user),
              if (financialProfile != null) ...[
                const SizedBox(height: 12),
                FinancialProfileCard(
                  profile: financialProfile!,
                  currency: user.currency ?? '',
                ),
              ],
              const SizedBox(height: 12),
              _QuickActionsPanel(
                onExpense: () => context
                    .read<ProfileBloc>()
                    .add(ProfileInitExpenseEvent()),
                onReceipt: () => context
                    .read<ProfileBloc>()
                    .add(const ProfileInitReceiptScanEvent()),
                onIncome: () => context
                    .read<ProfileBloc>()
                    .add(ProfileInitIncomeEvent()),
              ),
              const SizedBox(height: 16),
              _SectionHeader(
                title: 'Последние доходы',
                value: '${incomes.length}',
              ),
              const SizedBox(height: 10),
              _buildIncomesList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIncomesList(BuildContext context) {
    final theme = Theme.of(context);
    return incomes.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
              children: incomes
                  .map((income) => _buildIncomeRow(context, income))
                  .toList()
                  .separateBy(const SizedBox(height: 10)),
            ),
          )
        : Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withOpacity(0.18)),
            ),
            child: Text(
              t.profile.noIncomes,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.white.withOpacity(0.68),
              ),
            ),
          );
  }

  Widget _buildIncomeRow(BuildContext context, IncomeModel income) {
    final theme = Theme.of(context);
    final color = hexToColor(income.category?.color ?? '');
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 56,
              width: double.infinity,
              color: AppColors.complementaryBlue,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Slidable(
              closeOnScroll: false,
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                extentRatio: 0.40,
                children: [
                  SlidableAction(
                    onPressed: (_) => context.read<ProfileBloc>().add(
                          ProfileInitIncomeEvent(income: income),
                        ),
                    backgroundColor: AppColors.complementaryBlue, 
                    foregroundColor: Colors.white, 
                    icon: SvgPicture.asset( 
                      'assets/icons/edit_icon.svg',
                      height: 26, 
                      width: 26,
                      color: getIconColor(color),
                    ),
                    label: t.profile.changeBtn,
                    padding: EdgeInsets.zero,
                  ), 
                  SlidableAction(
                    onPressed: (ctx) => showConfirmDialog(  
                      context: ctx,
                      title: t.profile.deletingIncome,
                      message:
                          '${t.profile.youSureDeleteExpense}"${income.date?.formatNumberDate}"?',    
                      item: income,
                      onConfirm: () => ctx.read<ProfileBloc>().add( 
                            ProfileDeleteIncomeEvent(incomeId: income.id!),
                          ),
                    ),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    icon: SvgPicture.asset(
                      'assets/icons/delete_icon.svg',
                      height: 26,
                      width: 26,
                      color: getIconColor(color),
                    ),
                    label: t.profile.deleteBtn,
                    padding: EdgeInsets.zero,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                ],
              ),
              child: Material(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.surface,
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.16),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: color.withOpacity(0.18),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                income.category?.icon ?? '',
                                height: 24,
                                width: 24,
                                color: color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                income.category?.name ?? '',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${income.totalCount} ${user.currency}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.white.withOpacity(0.62),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          income.date!.formatColumnDate,
                          textAlign: TextAlign.right,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: AppColors.white.withOpacity(0.72)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.14),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                t.profile.balance,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.white.withOpacity(0.72),
                ),
              ),
              const Spacer(),
              Text(
                user.login ?? '',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.white.withOpacity(0.72),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user.balance}',
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 7),
              Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  user.currency ?? '',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.white.withOpacity(0.86),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          UserLevelCard(user: user, compact: true),
        ],
      ),
    );
  }
}

class _QuickActionsPanel extends StatelessWidget {
  const _QuickActionsPanel({
    required this.onExpense,
    required this.onReceipt,
    required this.onIncome,
  });

  final VoidCallback onExpense;
  final VoidCallback onReceipt;
  final VoidCallback onIncome;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.18)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _QuickActionButton(
              label: 'Расход',
              icon: Icons.remove_circle_outline,
              onTap: onExpense,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuickActionButton(
              label: 'Чек',
              icon: Icons.document_scanner_outlined,
              onTap: onReceipt,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _QuickActionButton(
              label: 'Доход',
              icon: Icons.add_circle_outline,
              onTap: onIncome,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 66,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.lightPrimary, size: 22),
            const SizedBox(height: 5),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.white.withOpacity(0.82),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(title, style: theme.textTheme.titleMedium),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.white.withOpacity(0.62),
          ),
        ),
      ],
    );
  }
}
