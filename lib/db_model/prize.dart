class Prize {
  int? id;
  String description;
  int amount;
  int quantity;

  Prize({
    this.id,
    required this.description,
    required this.amount,
    required this.quantity,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'description': description,
    'amount': amount,
    'quantity': quantity,
  };

  factory Prize.fromMap(Map<String, dynamic> map) => Prize(
    id: map['id'],
    description: map['description'],
    amount: map['amount'],
    quantity: map['quantity'],
  );
}
