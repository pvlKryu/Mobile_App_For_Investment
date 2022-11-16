// ignore_for_file: avoid_print, use_build_context_synchronously, no_leading_underscores_for_local_identifiers
import 'package:firstflutterproj/domain/models/operation.dart';
import '../domain/repository/portfolio_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/models/balance_operation_data.dart';
import '../domain/models/share.dart';
import '../domain/repository/basic_token_repository.dart';
import '../domain/services/analytics_data.dart';
import 'analytics.dart';
import 'custom_theme.dart';
import 'operations.dart';
import 'package:flutter/material.dart';
import 'favorites.dart';
import 'widgets/change_balance_status.dart';
import 'widgets/user_share_card.dart';

class PortfolioPage extends StatelessWidget {
  final List<Share> shares;
  final List<Operation> operations;
  final List<Share> favorites;
  const PortfolioPage(
      {super.key,
      required this.shares,
      required this.operations,
      required this.favorites});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PortfolioBloc(context.read()),
        child: Portfolio(
            shares: shares, operations: operations, favorites: favorites));
  }
}

class Portfolio extends StatefulWidget {
  final List<Share> shares;
  final List<Share> favorites;
  final List<Operation> operations;
  const Portfolio(
      {Key? key,
      required this.shares,
      required this.operations,
      required this.favorites})
      : super(key: key);

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  @override
  Widget build(BuildContext context) {
    final _basicTokenProvider = BasicTokenRepository();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.only(top: 5),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.fontBlack, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(1, 5, 1, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Operations(
                                        operations: widget.operations)),
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  // <-- Icon
                                  Icons.assignment,
                                  size: 21,
                                ),
                                Text('Операции'), // <-- Text
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Подключение Блок'а
                              final bloc = context.read<PortfolioBloc>();
                              // Вызов функции открытия окна изменения баланса
                              final operation =
                                  await openChangeBalanceWindow(context);
                              // Получение токена из безопасного локального хранилища
                              dynamic token =
                                  await _basicTokenProvider.getBasicToken();
                              // Если пользователь нажал одну из кнопок на форме изменения баланса:
                              if (operation != null) {
                                String operationType =
                                    operation.type.toString();
                                double? operationSum =
                                    operation.amount?.toDouble();
                                // Проверка на наличие введенной суммы
                                if (operationSum != null) {
                                  // Запрос на пополнение баланса:
                                  if (operationType == "ADD") {
                                    bool status = await bloc.addMoney(
                                        operationType, operationSum, token);
                                    // Проверка статуса выполнения запроса и показ соответствующего уведомления пользователю:
                                    status
                                        ? openChangeBalanceStatusWindow(
                                            context, "Баланс успешно пополнен")
                                        : openChangeBalanceStatusWindow(context,
                                            "Введенная сумма слишком большая");
                                  } else
                                  // Запрос на вывод средств:
                                  {
                                    bool status = await bloc.withdrawMoney(
                                        operationType, operationSum, token);
                                    // Проверка статуса выполнения запроса и показ соответствующего уведомления пользователю:
                                    status
                                        ? openChangeBalanceStatusWindow(context,
                                            "Средства успешно выведены")
                                        : openChangeBalanceStatusWindow(context,
                                            "Недостаточно средств на счете");
                                  }
                                } else {
                                  openChangeBalanceStatusWindow(
                                      context, "Введите сумму");
                                }
                              }
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  // <-- Icon
                                  Icons.add_card,
                                  size: 21,
                                ),
                                Text('Пополнить\n  Вывести'),
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FavoritesPage(
                                        favorites: widget.favorites)),
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  // <-- Icon
                                  Icons.star,
                                  size: 21,
                                ),
                                Text('Избранное'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final _basicTokenProvider = BasicTokenRepository();
                    dynamic token = await _basicTokenProvider.getBasicToken();
                    double? sumOfAdd = await AnalyticsData()
                        .getAnalyticsBalanceData('ADD', token);
                    double? sumOfSubtract = await AnalyticsData()
                        .getAnalyticsBalanceData('SUBTRACT', token);
                    double? incomeCurrency =
                        await AnalyticsData().getCurrencyIncomeData(token);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AnalyticsPage(
                                shares: widget.shares,
                                sumOfAdd: sumOfAdd,
                                sumOfSubtract: sumOfSubtract,
                                incomeCurrency: incomeCurrency,
                                token: token.toString(),
                              )),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: Card(
                      color: AppColors.fontWhite,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.fontBlack, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: ListTile(
                        title: Text(
                          'Аналитика портфеля',
                          style: TextStyle(color: AppColors.fontBlack),
                        ),
                        trailing: Icon(
                          size: 40,
                          Icons.pie_chart_rounded,
                          color: AppColors.fontBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: widget.shares.length,
            ((context, index) {
              return UserShareCard(share: widget.shares[index]);
            }),
          ),
        ),
      ],
    );
  }

// Функция вызова окна пополнения брокерского счета в рублях
  Future<OperationData?> openChangeBalanceWindow(BuildContext context) {
    return showDialog<OperationData>(
      context: context,
      builder: (BuildContext _) => const ChangeBalanceDialog(),
    );
  }
}

class ChangeBalanceDialog extends StatefulWidget {
  const ChangeBalanceDialog({Key? key}) : super(key: key);

  @override
  State<ChangeBalanceDialog> createState() => _ChangeBalanceDialogState();
}

class _ChangeBalanceDialogState extends State<ChangeBalanceDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(10),
      title: const Card(
        color: AppColors.fontWhite,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.fontBlack, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: ListTile(
            title: Text(
              'Изменение баланса в рублях',
              style: TextStyle(color: AppColors.fontBlack),
            ),
            leading: Icon(
              size: 40,
              Icons.account_balance_wallet,
              color: AppColors.fontBlack,
            ),
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.fromLTRB(5, 2, 2, 5),
        child: TextField(
          controller: _controller,
          style: const TextStyle(color: AppColors.alertInfoTextFolder),
          decoration: InputDecoration(
            fillColor: AppColors.fontWhite,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                  color: AppColors.alertInfoTextFolder, width: 1),
            ),
            labelText: 'Введите сумму',
          ),
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                double? sum = double.tryParse(_controller.text);
                OperationData operationDataAdd = OperationData("ADD", sum);
                Navigator.pop(context, operationDataAdd);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.fontWhite),
              ),
              child: const Text(
                'Пополнить',
                style: (TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: AppColors.fontBlack,
                )),
              ),
            ),
            TextButton(
              onPressed: () {
                double? sum = double.tryParse(_controller.text);
                OperationData operationDataWithdraw =
                    OperationData("SUBTRACT", sum);
                Navigator.pop(context, operationDataWithdraw);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(AppColors.fontWhite),
              ),
              child: const Text(
                'Вывести',
                style: (TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: AppColors.fontBlack,
                )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
