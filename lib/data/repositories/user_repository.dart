import 'package:family_budget/data/api_service.dart';
import 'package:family_budget/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserRepository {
  UserRepository(this._service);

  final ApiService _service;

  late UserModel curUser;

  Future<UserModel> getCurrentUser() async {
    try {
      final res = await _service.getMethod(path: "/users/me");
      curUser = UserModel.fromJson(res.data);
      return curUser;
    } catch (e) {
      rethrow;
    }
  }
}
