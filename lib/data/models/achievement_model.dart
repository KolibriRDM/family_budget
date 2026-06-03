class AchievementModel {
  const AchievementModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.level1Requirement,
    required this.level2Requirement,
    required this.level3Requirement,
    required this.level1Experience,
    required this.level2Experience,
    required this.level3Experience,
    required this.progress,
    required this.level,
    required this.nextRequirement,
    required this.nextExperience,
    required this.progressPercent,
    required this.completed,
  });

  final int id;
  final String name;
  final String description;
  final String type;
  final int level1Requirement;
  final int level2Requirement;
  final int level3Requirement;
  final int level1Experience;
  final int level2Experience;
  final int level3Experience;
  final int progress;
  final int level;
  final int? nextRequirement;
  final int? nextExperience;
  final double progressPercent;
  final bool completed;

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      type: json['type'] as String? ?? 'count',
      level1Requirement: json['level_1_requirement'] as int? ?? 0,
      level2Requirement: json['level_2_requirement'] as int? ?? 0,
      level3Requirement: json['level_3_requirement'] as int? ?? 0,
      level1Experience: json['level_1_experience'] as int? ?? 0,
      level2Experience: json['level_2_experience'] as int? ?? 0,
      level3Experience: json['level_3_experience'] as int? ?? 0,
      progress: json['progress'] as int? ?? 0,
      level: json['level'] as int? ?? 0,
      nextRequirement: json['next_requirement'] as int?,
      nextExperience: json['next_experience'] as int?,
      progressPercent:
          (json['progress_percent'] as num?)
                  ?.toDouble()
                  .clamp(0.0, 1.0)
                  .toDouble() ??
              0,
      completed: json['completed'] as bool? ?? false,
    );
  }

  String get levelLabel => completed ? 'Завершено' : 'Уровень $level/3';

  String get progressLabel {
    if (completed) {
      return '$progress / $level3Requirement$progressUnit';
    }
    final target = nextRequirement ?? level3Requirement;
    return '$progress / $target$progressUnit';
  }

  String get progressUnit {
    if (name == 'Порядок в категориях') {
      return ' категорий';
    }
    if (type == 'receipt') {
      return ' чеков';
    }
    if (type == 'streak') {
      return ' дней';
    }
    return '';
  }

  String get rewardLabel {
    if (completed || nextExperience == null) {
      return 'максимум';
    }
    return '+$nextExperience XP';
  }
}
