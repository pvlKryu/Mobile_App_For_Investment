import '../models/share.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/user_bloc.dart';

// Функция подсчета стоимости всего брокерского счета
double brokerageAccountCount(List<Share> data, context) {
  final user = BlocProvider.of<UserBloc>(context).state.user!;
  double brokerageAccountCounter = 0;
  for (int i = 0; i < data.length; i++) {
    if (data[i].price != null) {
      brokerageAccountCounter += data[i].price! * data[i].amount;
    }
  }
  return brokerageAccountCounter + user.balance;
}
