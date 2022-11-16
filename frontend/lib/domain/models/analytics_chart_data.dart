class ProfitData {
  ProfitData(this.date, this.profit);
  final String date;
  final double profit;

  factory ProfitData.fromJson(Map<String, dynamic> parsedJson) {
    return ProfitData(
      parsedJson['time'].toString(),
      parsedJson['portfolioPrice'],
    );
  }
}
