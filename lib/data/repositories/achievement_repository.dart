import 'package:family_budget/data/api_service.dart';
import 'package:family_budget/data/models/achievement_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AchievementRepository {
  AchievementRepository(this._service);

  final ApiService _service;

  Future<List<AchievementModel>> getAll() async {
    final res = await _service.getMethod(path: '/achievements/');
    final data = res.data as List? ?? [];
    return data
        .map((item) =>
            AchievementModel.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }
}
