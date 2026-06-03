import 'package:family_budget/data/api_service.dart';
import 'package:family_budget/data/models/financial_profile_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FinancialProfileRepository {
  FinancialProfileRepository(this._service);

  final ApiService _service;

  Future<FinancialProfileModel> getCurrentProfile() async {
    final res = await _service.getMethod(path: '/financial-profile/me');
    return FinancialProfileModel.fromJson(
      Map<String, dynamic>.from(res.data as Map),
    );
  }
}
