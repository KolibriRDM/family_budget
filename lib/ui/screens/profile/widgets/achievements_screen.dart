import 'package:family_budget/data/models/achievement_model.dart';
import 'package:family_budget/data/models/user_model.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:family_budget/ui/screens/profile/bloc/profile_bloc.dart';
import 'package:family_budget/ui/screens/profile/widgets/user_level_card.dart';
import 'package:family_budget/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({
    super.key,
    required this.user,
    required this.achievements,
  });

  final UserModel user;
  final List<AchievementModel> achievements;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          onPressed: () =>
              context.read<ProfileBloc>().add(const ProfileInitialEvent()),
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Text('Ачивки', style: theme.textTheme.headlineLarge),
        centerTitle: true,
      ),
      statusBarPadding: false,
      willPop: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserLevelCard(user: user),
            const SizedBox(height: 16),
            Text('Поведенческие достижения',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 10),
            ...achievements.map(
              (achievement) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _AchievementCard(achievement: achievement),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});

  final AchievementModel achievement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent =
        achievement.completed ? AppColors.success : AppColors.lightPrimary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  achievement.completed
                      ? Icons.check_circle_outline
                      : Icons.auto_graph,
                  color: accent,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(achievement.name, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      achievement.levelLabel,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.white.withOpacity(0.68),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                achievement.rewardLabel,
                style: theme.textTheme.bodySmall?.copyWith(color: accent),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            achievement.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.white.withOpacity(0.72),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(achievement.progressLabel, style: theme.textTheme.bodySmall),
              Text(
                '${(achievement.progressPercent * 100).round()}%',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: achievement.progressPercent,
              backgroundColor: AppColors.background,
              valueColor: AlwaysStoppedAnimation(accent),
            ),
          ),
        ],
      ),
    );
  }
}
