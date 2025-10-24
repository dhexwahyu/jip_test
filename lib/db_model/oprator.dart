class Operator {
  int? id;
  String name;
  String location;
  String createdAt;

  Operator({
    this.id,
    required this.name,
    required this.location,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'created_at': createdAt,
    };
  }

  factory Operator.fromMap(Map<String, dynamic> map) {
    return Operator(
      id: map['id'],
      name: map['name'],
      location: map['location'],
      createdAt: map['created_at'],
    );
  }
}
