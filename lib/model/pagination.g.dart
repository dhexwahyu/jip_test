// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
  count: (json['count'] as num?)?.toInt(),
  limit: (json['limit'] as num?)?.toInt(),
  page: (json['page'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'count': ?instance.count,
      'limit': ?instance.limit,
      'page': ?instance.page,
      'total': ?instance.total,
    };
