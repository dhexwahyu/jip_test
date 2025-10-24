// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auth _$AuthFromJson(Map<String, dynamic> json) => Auth(
  accessToken: json['access_token'] as String?,
  expiresIn: (json['expires_in'] as num?)?.toInt(),
  refreshToken: json['refresh_token'] as String?,
  tokenType: json['token_type'] as String?,
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
)..relationships = json['relationships'] as Map<String, dynamic>?;

Map<String, dynamic> _$AuthToJson(Auth instance) => <String, dynamic>{
  'relationships': ?instance.relationships,
  'access_token': ?instance.accessToken,
  'expires_in': ?instance.expiresIn,
  'refresh_token': ?instance.refreshToken,
  'token_type': ?instance.tokenType,
  'user': ?instance.user?.toJson(),
};
