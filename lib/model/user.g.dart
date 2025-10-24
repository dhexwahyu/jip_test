// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  username: json['username'] as String?,
)..relationships = json['relationships'] as Map<String, dynamic>?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'relationships': ?instance.relationships,
  'id': ?instance.id,
  'name': ?instance.name,
  'email': ?instance.email,
  'username': ?instance.username,
};
