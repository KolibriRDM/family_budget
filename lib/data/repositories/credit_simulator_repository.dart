import 'package:family_budget/data/api_service.dart';
import 'package:family_budget/data/models/debt_obligation_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CreditSimulatorRepository {
  CreditSimulatorRepository(this._service);

  final ApiService _service;

  Future<List<DebtObligationModel>> getObligations() async {
    final res = await _service.getMethod(
      path: '/credit-simulator/obligations',
    );
    return (res.data as List)
        .map((item) => DebtObligationModel.fromJson(
              Map<String, dynamic>.from(item as Map),
            ))
        .toList();
  }

  Future<DebtObligationModel> createObligation(
    DebtObligationModel obligation,
  ) async {
    final res = await _service.postMethod(
      path: '/credit-simulator/obligations',
      body: obligation.toJson(),
    );
    return DebtObligationModel.fromJson(
      Map<String, dynamic>.from(res.data as Map),
    );
  }

  Future<void> deleteObligation(int id) async {
    await _service.deleteMethod(path: '/credit-simulator/obligations/$id');
  }
}
