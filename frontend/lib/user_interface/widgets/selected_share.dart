// ignore_for_file: use_build_context_synchronously, avoid_print
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../domain/models/share.dart';
import '../../domain/models/transaction_data.dart';
import '../../domain/repository/basic_token_repository.dart';
import '../../domain/repository/portfolio_bloc.dart';
import '../../domain/services/move_favorites.dart';
import '../../domain/services/transaction.dart';
import '../custom_theme.dart';
import 'buy_share.dart';
import 'change_balance_status.dart';
import 'sell_share.dart';

class SelectSharePage extends StatelessWidget {
  const SelectSharePage({super.key, required this.share});
  final Share share;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PortfolioBloc(context.read()),
        child: SelectShare(share: share));
  }
}

class SelectShare extends StatefulWidget {
  final Share share;
  const SelectShare({super.key, required this.share});
  @override
  State<SelectShare> createState() => _SelectShareState();
}

class _SelectShareState extends State<SelectShare> {
  final _basicTokenProvider = BasicTokenRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        elevation: 5,
        flexibleSpace: SafeArea(
          child: Center(
            child: Text(
              widget.share.shortname,
              style: const TextStyle(
                fontSize: 32,
                color: AppColors.fontWhite,
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Добавить в избранное",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                    Padding(
                        padding: const EdgeInsets.only(left: 90),
                        child: IconButton(
                          icon: const Icon(Icons.bookmark_add_outlined),
                          onPressed: () async {
                            // Получение токена из безопасного локального хранилища:
                            dynamic token =
                                await _basicTokenProvider.getBasicToken();
                            bool status = await MoveFavorites()
                                .addFavorites(widget.share.figi, token);
                            if (status) {
                              openChangeBalanceStatusWindow(
                                  context, "Акция добавлена в Избранное");
                            } else {
                              openChangeBalanceStatusWindow(
                                  context, "Ошибка добавления");
                            }
                          },
                        )),
                    IconButton(
                      icon: const Icon(Icons.bookmark_remove),
                      onPressed: () async {
                        // Получение токена из безопасного локального хранилища:
                        dynamic token =
                            await _basicTokenProvider.getBasicToken();
                        bool status = await MoveFavorites()
                            .deleteFavorites(widget.share.figi, token);
                        if (status) {
                          openChangeBalanceStatusWindow(
                              context, "Удалено из Избранного");
                        } else {
                          openChangeBalanceStatusWindow(
                              context, "Ошибка удаления");
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Text(
                  'Цена',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
                child: Text(
                  '${widget.share.price} ${widget.share.currency}',
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w400,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("В портфеле",
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.fontWhite,
                              fontWeight: FontWeight.w200,
                            )),
                        Text("${widget.share.amount} шт.",
                            style: const TextStyle(
                              fontSize: 17,
                              color: AppColors.fontWhite,
                              fontWeight: FontWeight.w200,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Средняя стоимость",
                            style: TextStyle(
                              fontSize: 17,
                              color: AppColors.fontWhite,
                              fontWeight: FontWeight.w200,
                            )),
                        Text('${widget.share.price} ${widget.share.currency}',
                            style: const TextStyle(
                              fontSize: 17,
                              color: AppColors.fontWhite,
                              fontWeight: FontWeight.w200,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
                child: Row(
                  children: [
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Получение токена из безопасного локального хранилища:
                          dynamic token =
                              await _basicTokenProvider.getBasicToken();
                          // Получение инфы об операции:
                          TransactionData transaction =
                              await buyShare(context, widget);
                          // Если кол-во не пустое:
                          if (transaction.amount != null) {
                            bool status = await Transaction().buyShare(
                                transaction.figi, transaction.amount!, token);
                            if (status) {
                              openChangeBalanceStatusWindow(
                                  context, "Акции успешно куплены");

                              dynamic cost = transaction.amount!.toInt() *
                                  widget.share.price!.toDouble();
                              BlocProvider.of<PortfolioBloc>(context)
                                  .buyShare(cost);
                            } else {
                              openChangeBalanceStatusWindow(
                                  context, "Недостаточно средств");
                            }
                          } else {
                            openChangeBalanceStatusWindow(
                                context, "Введите количество акций");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 35),
                            elevation: 0,
                            primary: AppColors.greenBalanceAmount,
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal)),
                        child: const Text('Купить'),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () async {
                          // Получение токена из безопасного локального хранилища:
                          dynamic token =
                              await _basicTokenProvider.getBasicToken();
                          // Получение инфы об операции:
                          TransactionData transaction =
                              await sellShare(context, widget);
                          // Если кол-во не пустое:
                          if (transaction.amount != null) {
                            bool status = await Transaction().sellShare(
                                transaction.figi, transaction.amount!, token);
                            if (status) {
                              openChangeBalanceStatusWindow(
                                  context, "Акции успешно проданы");
                              dynamic cost = transaction.amount!.toInt() *
                                  widget.share.price!.toDouble();
                              BlocProvider.of<PortfolioBloc>(context)
                                  .sellShare(cost);
                            } else {
                              openChangeBalanceStatusWindow(
                                  context, "Вы не владеете данной акцией");
                            }
                          } else {
                            openChangeBalanceStatusWindow(
                                context, "Введите количество акций");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 35),
                            elevation: 0,
                            primary: AppColors.redBalanceAmount,
                            textStyle: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal)),
                        child: const Text('Продать'),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
