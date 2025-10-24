import 'package:json_annotation/json_annotation.dart';

import 'auth.dart';
import 'base.dart';

part 'account_data.g.dart';

@JsonSerializable()
class AccountData extends BaseModel<AccountData> {
  List<Auth?>? accounts;

  AccountData(
      {this.accounts});

  factory AccountData.fromJson(Map<String, dynamic> json) =>
      _$AccountDataFromJson(json);

  Map<String, dynamic> toJson() => _$AccountDataToJson(this);

  @override
  AccountData fromMap(Map<String, dynamic> map) {
    // TODO: implement fromMap
    return _$AccountDataFromJson(map);
  }

}