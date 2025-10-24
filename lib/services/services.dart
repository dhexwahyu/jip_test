// export all services related here in one file

import 'package:base_project/services/auth_service.dart';
import 'package:base_project/services/user_service.dart';
import 'package:dio/dio.dart';

import 'base_service.dart';

export 'base_service.dart';

class Service {
  Dio? client;
  static late Service instance;
  Service();
  Service.setup(this.client) {
    instance = this;
  }
  Map<Type, BaseService> get classes {
    return {
      AuthService: AuthService.instance,
      UserService: UserService.instance,
    };
  }

  static T? resolve<T extends BaseService?>() {
    if (instance.classes[T] == null)
      throw "$T is not registered. Please check the registered services";
    return instance.classes[T] as T?;
  }
}

T? getService<T extends BaseService>() {
  return Service.resolve<T>();
}
