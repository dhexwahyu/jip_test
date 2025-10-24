class Coupon {
  int? id;
  String serialNumber;
  int boxId;
  int prizeId;

  Coupon({
    this.id,
    required this.serialNumber,
    required this.boxId,
    required this.prizeId,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'serial_number': serialNumber,
    'box_id': boxId,
    'prize_id': prizeId,
  };

  factory Coupon.fromMap(Map<String, dynamic> map) => Coupon(
    id: map['id'],
    serialNumber: map['serial_number'],
    boxId: map['box_id'],
    prizeId: map['prize_id'],
  );
}
