class Box {
  int? id;
  int boxNumber;
  int batchId;
  int totalCoupons;

  Box({
    this.id,
    required this.boxNumber,
    required this.batchId,
    this.totalCoupons = 1000,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'box_number': boxNumber,
    'batch_id': batchId,
    'total_coupons': totalCoupons,
  };

  factory Box.fromMap(Map<String, dynamic> map) => Box(
    id: map['id'],
    boxNumber: map['box_number'],
    batchId: map['batch_id'],
    totalCoupons: map['total_coupons'],
  );
}
