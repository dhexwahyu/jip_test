
import 'package:base_project/model/link.dart';
import 'package:base_project/model/pagination.dart';
import 'package:json_annotation/json_annotation.dart';

part 'meta.g.dart';

@JsonSerializable()
class Meta {
  final List<String>? availableRelations;
  final Link? links;
  final dynamic relations;
  final Pagination? pagination;

  Meta({this.availableRelations, this.links, this.relations, this.pagination});
  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
