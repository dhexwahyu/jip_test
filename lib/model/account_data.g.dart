// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountData _$AccountDataFromJson(Map<String, dynamic> json) => AccountData(
  accounts: (json['accounts'] as List<dynamic>?)
      ?.map((e) => e == null ? null : Auth.fromJson(e as Map<String, dynamic>))
      .toList(),
)..relationships = json['relationships'] as Map<String, dynamic>?;

Map<String, dynamic> _$AccountDataToJson(AccountData instance) =>
    <String, dynamic>{
      'relationships': ?instance.relationships,
      'accounts': ?instance.accounts?.map((e) => e?.toJson()).toList(),
    };
