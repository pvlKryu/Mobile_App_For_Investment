import 'package:firstflutterproj/domain/repository/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/balance_client.dart';

class PortfolioBloc extends Cubit<PortfolioState> {
  final UserBloc _userBloc;
// context.read()
  PortfolioBloc(this._userBloc) : super(const PortfolioState());

  // Добавление денег на счет
  Future<bool> addMoney(String type, double amount, String token) async {
    bool answer = true;
    // Вызываем функцию изменения баланса
    bool status = await BalanceClient().changeUserBalance(type, amount, token);
    // Проверяем статус выполнения
    status ? _userBloc.addUserMoney(amount) : answer = false;
    // print("ошибка пополнения: сумма слишком большая")
    return answer;
  }

  // Снятие денег со счета
  Future<bool> withdrawMoney(String type, double amount, String token) async {
    bool answer = true;
    // Вызываем функцию изменения баланса
    bool status = await BalanceClient().changeUserBalance(type, amount, token);
    // Проверяем статус выполнения
    status ? _userBloc.withdrowUserMoney(amount) : answer = false;
    //  print("ошибка вывода: сумма вывода больше баланса");
    return answer;
  }

  // Покупка акции
  buyShare(double money) async {
    _userBloc.withdrowUserMoney(money);
  }

  // Продажа акции
  sellShare(double money) async {
    _userBloc.addUserMoney(money);
  }
}

class PortfolioState {
  const PortfolioState();
}
