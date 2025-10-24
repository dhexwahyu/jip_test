class Batch {
  int? id;
  int batchNumber;
  int operatorId;
  String location;
  String? notes;
  String? startedAt;
  String? finishedAt;

  Batch({
    this.id,
    required this.batchNumber,
    required this.operatorId,
    required this.location,
    this.notes,
    this.startedAt,
    this.finishedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'batch_number': batchNumber,
    'operator_id': operatorId,
    'location': location,
    'notes': notes,
    'started_at': startedAt,
    'finished_at': finishedAt,
  };

  factory Batch.fromMap(Map<String, dynamic> map) => Batch(
    id: map['id'],
    batchNumber: map['batch_number'],
    operatorId: map['operator_id'],
    location: map['location'],
    notes: map['notes'],
    startedAt: map['started_at'],
    finishedAt: map['finished_at'],
  );
}
