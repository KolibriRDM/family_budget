class UserModel {
  const UserModel({
    this.id,
    this.balance,
    this.currency,
    this.login,
    this.password,
    this.experience = 0,
    this.userLevel = 1,
    this.levelTitle = 'Новичок учета',
    this.levelTrophy = 'Бронзовый старт',
    this.currentLevelExperience = 0,
    this.nextLevelExperience = 100,
    this.experienceToNextLevel = 100,
    this.levelProgressPercent = 0,
    this.totalAvailableExperience = 4400,
  });

  final int? id;
  final double? balance;
  final String? currency;
  final String? login;
  final String? password;
  final int experience;
  final int userLevel;
  final String levelTitle;
  final String levelTrophy;
  final int currentLevelExperience;
  final int? nextLevelExperience;
  final int experienceToNextLevel;
  final double levelProgressPercent;
  final int totalAvailableExperience;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num?)?.toInt(),
      balance: (json['balance'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      login: json['login'] as String?,
      password: json['password'] as String?,
      experience: (json['experience'] as num?)?.toInt() ?? 0,
      userLevel: (json['user_level'] as num?)?.toInt() ?? 1, 
      levelTitle: json['level_title'] as String? ?? 'Новичок учета',
      levelTrophy: json['level_trophy'] as String? ?? 'Бронзовый старт',
      currentLevelExperience:  
          (json['current_level_experience'] as num?)?.toInt() ?? 0,
      nextLevelExperience: (json['next_level_experience'] as num?)?.toInt(),
      experienceToNextLevel:
          (json['experience_to_next_level'] as num?)?.toInt() ?? 0,
      levelProgressPercent:
          (json['level_progress_percent'] as num?)?.toDouble() ?? 0,
      totalAvailableExperience:
          (json['total_available_experience'] as num?)?.toInt() ?? 4400,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
      'currency': currency,
      'login': login,
      'password': password,
      'experience': experience,
      'user_level': userLevel,
      'level_title': levelTitle,
      'level_trophy': levelTrophy,
      'current_level_experience': currentLevelExperience,
      'next_level_experience': nextLevelExperience,
      'experience_to_next_level': experienceToNextLevel,
      'level_progress_percent': levelProgressPercent,
      'total_available_experience': totalAvailableExperience,
    };
  }

  UserModel copyWith({
    int? id,
    double? balance,
    String? currency,
    String? login,
    String? password,
    int? experience,
    int? userLevel,
    String? levelTitle,
    String? levelTrophy,
    int? currentLevelExperience,
    int? nextLevelExperience,
    int? experienceToNextLevel,
    double? levelProgressPercent,
    int? totalAvailableExperience,
  }) {
    return UserModel(
      id: id ?? this.id,
      balance: balance ?? this.balance,
      currency: currency ?? this.currency,
      login: login ?? this.login,
      password: password ?? this.password,
      experience: experience ?? this.experience,
      userLevel: userLevel ?? this.userLevel,
      levelTitle: levelTitle ?? this.levelTitle,
      levelTrophy: levelTrophy ?? this.levelTrophy,
      currentLevelExperience:
          currentLevelExperience ?? this.currentLevelExperience,
      nextLevelExperience: nextLevelExperience ?? this.nextLevelExperience,
      experienceToNextLevel:
          experienceToNextLevel ?? this.experienceToNextLevel,
      levelProgressPercent:
          levelProgressPercent ?? this.levelProgressPercent,
      totalAvailableExperience:
          totalAvailableExperience ?? this.totalAvailableExperience,
    );
  }
}
