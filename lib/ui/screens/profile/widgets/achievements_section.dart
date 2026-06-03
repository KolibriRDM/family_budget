import 'package:family_budget/data/models/achievement_model.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:flutter/material.dart';

class AchievementsSection extends StatelessWidget {
  const AchievementsSection({
    super.key,
    required this.achievements,
  });

  final List<AchievementModel> achievements;

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final visibleAchievements = achievements.take(5).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Ачивки', style: theme.textTheme.titleMedium),
              Text(
                '${achievements.where((item) => item.completed).length}/${achievements.length}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.white.withOpacity(0.72),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...visibleAchievements.map(
            (achievement) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AchievementTile(achievement: achievement),
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementTile extends StatelessWidget {
  const _AchievementTile({
    required this.achievement,
  });

  final AchievementModel achievement;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progressColor =
        achievement.completed ? AppColors.lightPrimary : AppColors.primary;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  achievement.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                achievement.rewardLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.white.withOpacity(0.72),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            achievement.description,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.white.withOpacity(0.68),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                achievement.levelLabel,
                style: theme.textTheme.bodySmall,
              ),
              Text(
                achievement.progressLabel,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: achievement.progressPercent,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
          ),
        ],
      ),
    );
  }
}
