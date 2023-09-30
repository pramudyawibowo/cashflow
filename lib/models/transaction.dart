class Transactions {
  final int user_id;
  final int amount;
  final String description;
  final int status;
  final DateTime date;

  Transactions({
    required this.user_id,
    required this.amount,
    required this.description,
    required this.status,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'amount': amount,
      'description': description,
      'status': status,
      'date': date.toIso8601String(),
    };
  }

  factory Transactions.fromMap(Map<String, dynamic> map) {
    return Transactions(
      user_id: map['user_id'],
      amount: map['amount'],
      description: map['description'],
      status: map['status'],
      date: DateTime.parse(map['date']),
    );
  }
}
