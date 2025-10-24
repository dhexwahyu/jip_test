import 'package:base_project/model/base.dart';
import 'package:base_project/model/meta.dart';
import 'package:base_project/model/resource.dart';

class Response<T extends BaseModel<T>> extends BaseModel<Response<T>> {
  bool? success;
  Map<String, dynamic>? included;
  T? resource;
  List<T?>? resources;
  Meta? meta;
  String? message;
  Response({
    this.included,
    this.message,
    this.success,
    this.resource,
    this.resources,
    this.meta,
  });
  @override
  Response<T> fromMap(Map<String, dynamic> map) {
    return Response.fromJson(map);
  }

  factory Response.fromJson(Map<String, dynamic> json) {
    final included = json['included'] is List ? null : json['included'];
    return Response<T>(
      success: json['success'],
      included: included,
      resource: json['data'] is! List
          ? Resource<T>.fromJson(json['data'],
                  json['included'] is List ? {} : json['included'])
              .attributes
          : null,
      resources: json['data'] is List
          ? (json['data'] as List<dynamic>)
              .map((item) => Resource<T>.fromJson(item, included).attributes)
              .toList()
          : null,
      meta: Meta.fromJson(json['meta']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'success': this.success,
      'included': this.included,
      'data': this.resource != null
          ? this.resource!.toJson()
          : this.resources!.map((item) => item?.toJson()),
      'meta': this.meta,
    };
  }

  @override
  Map<String, RelationshipMapper>? relationshipMapper() {
    // TODO: implement relationshipMapper
    return null;
  }
}
