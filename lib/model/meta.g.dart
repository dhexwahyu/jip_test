// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
  availableRelations: (json['available_relations'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  links: json['links'] == null
      ? null
      : Link.fromJson(json['links'] as Map<String, dynamic>),
  relations: json['relations'],
  pagination: json['pagination'] == null
      ? null
      : Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'available_relations': ?instance.availableRelations,
  'links': ?instance.links?.toJson(),
  'relations': ?instance.relations,
  'pagination': ?instance.pagination?.toJson(),
};
