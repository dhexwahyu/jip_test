import 'package:base_project/env.dart';
import 'package:base_project/model/auth.dart';

import 'base_service.dart';

class AuthService extends BaseService {
  static AuthService instance = AuthService();
  Future<Auth?> login(String username, String password) async {
    return post('login', body: {
      "client_id":  environment['client_id'],
      "client_secret": environment['client_secret'],
      "grant_type": "password",
      "username": username,
      "password":  password
    });
  }
}