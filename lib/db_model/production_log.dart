class ProductionLog {
  int? id;
  int batchId;
  int operatorId;
  String timestamp;

  ProductionLog({
    this.id,
    required this.batchId,
    required this.operatorId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'batch_id': batchId,
    'operator_id': operatorId,
    'timestamp': timestamp,
  };

  factory ProductionLog.fromMap(Map<String, dynamic> map) =>
      ProductionLog(
        id: map['id'],
        batchId: map['batch_id'],
        operatorId: map['operator_id'],
        timestamp: map['timestamp'],
      );
}
