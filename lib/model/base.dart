typedef S RelationshipMapper<S extends BaseModel<S>>(Map<String, dynamic>? json);

class RelationshipDataMapper<S extends BaseModel<S>> {
  RelationshipMapper<S> runner;
  String type;
  RelationshipDataMapper(this.type, this.runner);
}

abstract class BaseModel<T extends BaseModel<T>> {
  T fromMap(Map<String, dynamic> map);
  Map<String, dynamic> toJson();
  Map<String, dynamic>? relationships = {};
  Map<String, RelationshipMapper>? relationshipMapper() {
    return {};
  }
}