import 'package:family_budget/app/di/di.dart';
import 'package:family_budget/data/api_service.dart';
import 'package:family_budget/data/models/category_model.dart';
import 'package:family_budget/data/models/expense_model.dart';
import 'package:family_budget/helpers/preferences.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CategoryRepository {
  CategoryRepository(this._service);

  final ApiService _service;

  final Preferences prefs = getIt<Preferences>();

  Future<CategoryModel> createCategory(
      String name, String color, String icon) async {
    try {
      final res = await _service.postMethod(
        path: "/categories/",
        body: {
          "name": name,
          "color": color,
          "icon": icon,
        },
      );
      return CategoryModel.fromJson(res.data);
    } catch (e) {
      throw e;
    }
  }

  Future<List<CategoryModel>> getAll() async {
    final res = await _service.getMethod(path: "/categories/my");
    return (res.data as List).map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<void> delete(
    int id,
  ) async {
    try {
      await _service.deleteMethod(
        path: "/categories/$id",
        params: {
          "category_id": id,
        },
      );
    } catch (e) {
      throw e;
    }
  }

  Future<List<double>> getCategoryStatistics(
      int categoryId, String timeSegment) async {
    try {
      final res = await _service.getMethod(
        path: "/categories/$categoryId/statistics",
        params: {
          "time_segment": timeSegment,
        },
      );
      return List<double>.from(res.data);
    } catch (e) {
      throw e;
    }
  }

  Future<List<ExpenseModel>> getRecentCategoryExpenses(int categoryId) async {
    try {
      final res = await _service.getMethod(
        path: "/categories/$categoryId/recent",
      );
      return (res.data as List).map((e) => ExpenseModel.fromJson(e)).toList();
    } catch (e) {
      throw e;
    }
  }
}
