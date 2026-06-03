import 'package:family_budget/data/api_service.dart';
import 'package:family_budget/data/models/expense_model.dart';
import 'package:family_budget/data/models/receipt_model.dart';
import 'package:family_budget/helpers/extensions.dart';
import 'package:family_budget/helpers/functions.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ExpenseRepository {
  ExpenseRepository(this._service);

  final ApiService _service;

  Future<List<ExpenseModel>> getAll(DateTime dateFrom, DateTime dateTo) async {
    try {
      final res = await _service.getMethod(path: "/expenses/", params: {
        "start_date": dateFrom.sendFormat,
        "end_date": dateTo.sendFormat,
      });
      return (res.data as List).map((e) => ExpenseModel.fromJson(e)).toList();
    } catch (e) {
      throw e;
    }
  }

  Future<ExpenseModel> createExpense(
      double totalCount, int categoryId, DateTime date) async {
    try {
      final res = await _service.postMethod(
        path: "/expenses/",
        body: {
          "total_count": totalCount,
          "category_id": categoryId,
          "date": getRequestFormatDate(date),
        },
      );
      return ExpenseModel.fromJson(res.data);
    } catch (e) {
      throw e;
    }
  }

  Future<ExpenseModel> createExpenseWithReceipt({
    required double totalCount,
    required int categoryId,
    required DateTime date,
    required ReceiptModel receipt,
  }) async {
    try {
      final res = await _service.createExpenseWithReceipt({
        "total_count": totalCount,
        "category_id": categoryId,
        "date": getRequestFormatDate(date),
        "receipt": receipt.toJson(),
      });
      return ExpenseModel.fromJson(res.data);
    } catch (e) {
      throw e;
    }
  }

  Future<ExpenseModel> updateExpense(
      int expenseId, int categoryId, double totalCount, DateTime date) async {
    try {
      final res = await _service.putMethod(
        path: "/expenses/$expenseId",
        params: {
          'expense_id': expenseId,
        },
        body: {
          "total_count": totalCount,
          "category_id": categoryId,
          "date": getRequestFormatDate(date),
        },
      );

      return ExpenseModel.fromJson(res.data);
    } catch (e) {
      throw e;
    }
  }

  Future<void> delete(int id) async {
    try {
      await _service.deleteMethod(path: "/expenses/$id", params: {
        'expense_id': id,
      });
    } catch (e) {
      throw e;
    }
  }

  Future<ReceiptModel> getReceipt(int expenseId) async {
    try {
      final res = await _service.getExpenseReceipt(expenseId);
      return ReceiptModel.fromJson(Map<String, dynamic>.from(res.data as Map));
    } catch (e) {
      throw e;
    }
  }

  Future<ReceiptModel> resolveReceiptByQr(String qrRawValue) async {
    try {
      final res = await _service.resolveReceiptByQr(qrRawValue);
      return ReceiptModel.fromJson(Map<String, dynamic>.from(res.data as Map));
    } catch (e) {
      throw e;
    }
  }
}
