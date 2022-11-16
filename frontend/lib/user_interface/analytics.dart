import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/business_rules/brokerage_account_count.dart';
import '../domain/models/analytics_chart_data.dart';
import '../domain/models/share.dart';
import '../domain/repository/portfolio_bloc.dart';
import '../domain/repository/share_repository.dart';
import 'custom_theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class AnalyticsPage extends StatelessWidget {
  final List<Share> shares;
  final double sumOfAdd;
  final double sumOfSubtract;
  final double incomeCurrency;
  final String token;

  const AnalyticsPage({
    super.key,
    required this.shares,
    required this.sumOfAdd,
    required this.sumOfSubtract,
    required this.incomeCurrency,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PortfolioBloc(context.read()),
        child: Analytics(
          context,
          shares: shares,
          sumOfAdd: sumOfAdd,
          sumOfSubtract: sumOfSubtract,
          incomeCurrency: incomeCurrency,
          token: token,
        ));
  }
}

class Analytics extends StatefulWidget {
  final List<Share> shares;
  final double sumOfAdd;
  final double sumOfSubtract;
  final double incomeCurrency;
  final String token;

  const Analytics(
    BuildContext context, {
    Key? key,
    required this.shares,
    required this.sumOfAdd,
    required this.sumOfSubtract,
    required this.incomeCurrency,
    required this.token,
  }) : super(key: key);
  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    loadSalesData();
    super.initState();
  }

  List<ProfitData> chartData = [];

  Future loadSalesData() async {
    final String jsonString = await getProfitData();
    final dynamic jsonResponse = json.decode(jsonString);
    for (Map<String, dynamic> i in jsonResponse) {
      chartData.add(ProfitData.fromJson(i));
    }
  }

  Future<String> getProfitData() async {
    String url = "http://18.219.109.109:8080/client/income/graph";

    http.Response response =
        await http.get(Uri.parse(url), headers: <String, String>{
      // Передаем полученный токен в заголовке:
      'Authorization': widget.token.toString(),
      'Content-Type': 'application/json',
    });
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Column(
        children: const [
          Text(
            "Аналитика",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
          ),
          Text(
            "Брокерский счет",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          )
        ],
      )),
      body: StreamBuilder<List<Share>>(
          stream: SharesRepository().stream,
          builder: (context, snapshot1) {
            if (!snapshot1.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return _buildBody(context, snapshot1);
          }),
    );
  }

  Widget _buildBody(BuildContext context, shares) {
    double realCost = brokerageAccountCount(widget.shares, context);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: SfCartesianChart(
                        title: ChartTitle(
                          text: 'Изменение стоимости брокерского счета',
                        ),
                        tooltipBehavior: _tooltipBehavior,
                        primaryXAxis: CategoryAxis(),
                        series: <ChartSeries<ProfitData, String>>[
                          LineSeries<ProfitData, String>(
                              enableTooltip: true,
                              dataSource: chartData,
                              xValueMapper: (ProfitData profit, _) =>
                                  profit.date,
                              yValueMapper: (ProfitData profit, _) =>
                                  profit.profit.roundToDouble(),
                              // Enable data label
                              dataLabelSettings:
                                  const DataLabelSettings(isVisible: true))
                        ])),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Стоимость портфеля",
                              style: TextStyle(
                                fontSize: 17,
                                color: AppColors.fontWhite,
                                fontWeight: FontWeight.w300,
                              )),
                          Text('${realCost.toStringAsFixed(2)} ₽',
                              style: const TextStyle(
                                fontSize: 17,
                                color: AppColors.fontWhite,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Текущий доход (₽)",
                              style: TextStyle(
                                fontSize: 17,
                                color: AppColors.fontWhite,
                                fontWeight: FontWeight.w300,
                              )),
                          Text('${widget.incomeCurrency.toStringAsFixed(2)} ₽',
                              style: const TextStyle(
                                fontSize: 17,
                                color: AppColors.fontWhite,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Текущий доход (%)",
                              style: TextStyle(
                                fontSize: 17,
                                color: AppColors.fontWhite,
                                fontWeight: FontWeight.w300,
                              )),
                          Text(
                              '${(((realCost / (realCost - widget.incomeCurrency)) - 1) * 100).toStringAsFixed(2)} %',
                              style: const TextStyle(
                                fontSize: 17,
                                color: AppColors.fontWhite,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Пополнения",
                              style: TextStyle(
                                fontSize: 17,
                                color: AppColors.fontWhite,
                                fontWeight: FontWeight.w300,
                              )),
                          Text("${widget.sumOfAdd.toStringAsFixed(2)} ₽",
                              style: const TextStyle(
                                fontSize: 17,
                                color: AppColors.fontWhite,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Выводы",
                              style: TextStyle(
                                fontSize: 17,
                                color: AppColors.fontWhite,
                                fontWeight: FontWeight.w300,
                              )),
                          Text("${widget.sumOfSubtract.toStringAsFixed(2)} ₽",
                              style: const TextStyle(
                                fontSize: 17,
                                color: AppColors.fontWhite,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
