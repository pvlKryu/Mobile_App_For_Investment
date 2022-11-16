class Share {
  String shortname;
  double? price; // PREVPRICE (Цена последней сделки предыдушего дня)
  double? averagePrice;
  String currency;
  int amount;
  String figi;
  double? profit;

  Share(
      {required this.shortname,
      required this.figi,
      this.price,
      this.averagePrice,
      this.currency = '₽',
      this.amount = 1,
      this.profit});

  factory Share.fromJson(Map<String, dynamic> json) {
    double? price1 = json['lastPrice'];
    double? price2 = json['averagePrice'];
    double? price3;
    if (price1 != 0 && price1 != null) {
      price3 = price1;
    } else {
      price3 = price2;
    }

    if (price3.runtimeType == int) {
      price3 = price3!.toDouble();
    }

    if (price3 == 0.0) {
      price3 = 1.0;
    }
    String currency = '';
    if (json['currency'] == 'rub') {
      currency = '₽';
    }
    int? amount = json['amount'];
    amount ??= 0;
    double? profit = json['profit'];
    profit ??= 0;
    double? averagePrice = json['averagePrice'];
    averagePrice ??= 0;

    return Share(
        shortname: json['name'],
        figi: json['figi'],
        price: price3,
        currency: currency,
        amount: amount,
        profit: profit);
  }
}
