

import 'package:base_project/model/base.dart';
import 'package:base_project/model/generator.dart';

List<T> castToList<T>(dynamic value) {
  List<dynamic> newValue = [];
  if (value is! List) {
    newValue = List.from((value as Map<String, dynamic>).values);
  } else {
    newValue = value;
  }
  return newValue as List<T>;
}

class Resource<T extends BaseModel<T>> extends BaseModel<Resource<T>> {
  String? type;
  String? id;
  T? attributes;

  Resource({
    this.type,
    this.id,
    this.attributes,
  });
  static parseRelationships<S extends BaseModel<S>>(
      S instance, Map<String, dynamic> data, Map<String, dynamic> included) {
    final mapper = instance.relationshipMapper();
    final parsedIncludes = included.map((key, value) {
      return MapEntry(key, castToList(value));
    });

    return data.map((key, value) {
      bool returnAsMap = value is Map<String, dynamic> &&
          !(value.values.first is Map<String, dynamic>);
      List<dynamic> dataValue = castToList(returnAsMap ? [value] : value)
          .where((item) => item is Map)
          .map((item) {
        var newItem = item;
        if (parsedIncludes.containsKey(key)) {
          try {
            newItem = parsedIncludes[key]!
                    .firstWhere((element) => element['id'] == item['id']) ??
                item;
          } catch (e) {}
        }
        return mapper!.containsKey(key) && newItem.containsKey('attributes')
            ? mapper[key]!(newItem['attributes'])
            : newItem;
      }).toList();
      return MapEntry(key, returnAsMap ? dataValue.first : dataValue.toList());
    });
  }

  factory Resource.fromJson(
      Map<String, dynamic> json, Map<String, dynamic>? included) {
    final T instance = ModelGenerator.resolve<T>(json['attributes'])!;
    instance.relationships = json.containsKey('relationships')
        ? parseRelationships<T>(instance, json['relationships'], included!)
        : null;
    return Resource<T>(
        type: json['type'], id: json['id'], attributes: instance);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': (T).toString().toLowerCase(),
      'id': this.id,
      'attributes': this.attributes,
    };
  }

  @override
  Resource<T> fromMap(Map<String, dynamic> map) {
    // never call this method
    return Resource.fromJson(map, null);
  }

  @override
  Map<String, RelationshipMapper>? relationshipMapper() {
    // TODO: implement relationshipMapper
    return null;
  }
}
