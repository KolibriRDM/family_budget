import 'package:family_budget/data/models/user_model.dart';
import 'package:family_budget/styles/app_colors.dart';
import 'package:flutter/material.dart';

class UserLevelCard extends StatelessWidget {
  const UserLevelCard({
    super.key,
    required this.user,
    this.compact = false,
  });

  final UserModel user;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nextLevel = user.nextLevelExperience;
    final progress = user.levelProgressPercent.clamp(0.0, 1.0).toDouble();
    final totalAvailableExperience =
        (user.toJson()['total_available_experience'] as num?)?.toInt() ?? 4400;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: BoxDecoration(
        color: compact ? AppColors.background : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: compact
              ? AppColors.primary.withOpacity(0.20)
              : AppColors.lightPrimary.withOpacity(0.36),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: compact ? 44 : 52,
            height: compact ? 44 : 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.lightPrimary,
                  AppColors.complementaryBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: AppColors.white,
              size: 27,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.levelTrophy,
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  'Уровень ${user.userLevel} • ${user.levelTitle}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.white.withOpacity(0.68),
                  ),
                ),
                if (!compact) ...[
                  const SizedBox(height: 9),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      minHeight: 7,
                      value: progress,
                      backgroundColor: AppColors.background,
                      valueColor:
                          const AlwaysStoppedAnimation(AppColors.lightPrimary), 
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    nextLevel == null
                        ? '${user.experience} / $totalAvailableExperience XP • максимальный уровень'
                        : '${user.experience} / $nextLevel XP • всего доступно $totalAvailableExperience XP',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.white.withOpacity(0.64),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
