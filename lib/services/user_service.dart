import 'package:base_project/model/user.dart';

import 'base_service.dart';

class UserService extends BaseService {
  static UserService instance = UserService();
  Future<User?> me() async {
    final response =
    await getResource<User>("me",);
    if (response.success!) {
      return response.resource;
    }
    throw new Exception(response.message);
  }

  Future<dynamic?> register(Map<String, dynamic> params) async {
    return await postRaw('', body: params);
  }
}