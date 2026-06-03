import 'package:family_budget/data/api_service.dart';
import 'package:family_budget/data/models/income_model.dart';
import 'package:family_budget/helpers/extensions.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class IncomeRepository {
  IncomeRepository(this._service);

  final ApiService _service;

  Future<List<IncomeModel>> getAll() async {
    try {
      final res = await _service.getMethod(path: "/incomes/my");
      return (res.data as List).map((e) => IncomeModel.fromJson(e)).toList();
    } catch (e) {
      throw e;
    }
  }

  Future<IncomeModel> createIncome(
      double totalCount, int categoryId, DateTime date) async {
    try {
      final res = await _service.postMethod(
        path: "/incomes/",
        body: {
          "total_count": totalCount,
          "category_id": categoryId,
          "date": getRequestFormatDate(date),
        },
      );
      return IncomeModel.fromJson(res.data);
    } catch (e) {
      throw e;
    }
  }

  Future<IncomeModel> updateIncome(
      int incomeId, int categoryId, double totalCount, DateTime date) async {
    try {
      final res = await _service.putMethod(
        path: "/incomes/$incomeId",
        params: {
          "income_id": incomeId,
        },
        body: {
          "total_count": totalCount,
          "category_id": categoryId,
          "date": getRequestFormatDate(date),
        },
      );

      return IncomeModel.fromJson(res.data);
    } catch (e) {
      throw e;
    }
  }

  Future<void> delete(int id) async {
    try {
      await _service.deleteMethod(path: "/incomes/$id", params: {
        "income_id": id,
      });
    } catch (e) {
      throw e;
    }
  }
}
