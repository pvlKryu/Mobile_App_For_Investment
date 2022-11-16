class Operation {
  String shortname;
  double price;
  int amount;
  String date;
  String type;

  Operation({
    required this.shortname,
    required this.price,
    required this.type,
    required this.amount,
    required this.date,
  });

  factory Operation.fromJson(Map<String, dynamic> json) {
    double price = json['transactionPrice'];

    if (price.runtimeType == int) {
      price = price.toDouble();
    }

    if (price == 0.0) {
      price = 1.0;
    }
    String operation;
    bool boolType = json['operationType'];
    boolType ? operation = "Покупка" : operation = "Продажа";

    return Operation(
      shortname: json['name'],
      price: price,
      amount: json['numberOfStock'],
      type: operation,
      date: json['localDate'],
    );
  }
}
