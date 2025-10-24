import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

@JsonSerializable()
class Pagination {
  final int? count;
  final int? limit;
  final int? page;
  final int? total;
  Pagination({
    this.count,
    this.limit,
    this.page,
    this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);

  Map<String, dynamic> toJson() {
    return _$PaginationToJson(this);
  }
}
