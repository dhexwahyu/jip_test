import 'package:base_project/model/account_data.dart';
import 'package:base_project/model/auth.dart';
import 'package:base_project/model/user.dart';

typedef S ItemCreator<S>();

class ModelGenerator {
  static ModelGenerator instance = ModelGenerator();
  get classes {
    return {
      Auth: (json) => Auth.fromJson(json),
      User: (json) => User.fromJson(json),
      AccountData: (json) => AccountData.fromJson(json),
    };
  }

  static T? resolve<T>(Map<String, dynamic>? json) {
    if (instance.classes[T] == null)
      throw "Type $T not found. Make sure it's registered on model generators";
    return instance.classes[T](json);
  }
}
