// ignore_for_file: avoid_print
import '../models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'db_repository.dart';

class UserBloc extends Cubit<UserState> {
  DatabaseRepository databaseRepository;
  UserBloc({required this.databaseRepository}) : super(UserState());

  Future<User?> load() async {
    // Передаем состояние загрузки
    emit(state.copyWith(userStatus: UserStatus.loading));
    // Обработчик исключений
    final User? res = await databaseRepository.getUserFromDB();

    if (res != null) {
      // print("Пользователь авторизован");
      emit(state.copyWith(user: res, userStatus: UserStatus.success));
      // print("изменено состояние");
    } else {
      // print("Пользователь не авторизован");
      emit(state.copyWith(user: null, userStatus: UserStatus.unauthorized));
      // print("не изменено состояние");
    }
    return null;
  }

  void insert(user) async {
    // print("вызвано добавление юзера");
    emit(state.copyWith(userStatus: UserStatus.loading));
    // print("отправлен запрос в бд");
    await databaseRepository.insertUserToDB(user);
    emit(state.copyWith(user: user, userStatus: UserStatus.success));
    // print("изменено состояние");
  }

  void udpate(user) async {
    // print("вызвано изменение данных юзера");
    emit(state.copyWith(userStatus: UserStatus.loading));
    // print("отправлен запрос в бд");
    await databaseRepository.insertUserToDB(user);
    emit(state.copyWith(user: user, userStatus: UserStatus.success));
    // print("изменено состояние");
  }

  Future<void> logout(User user) async {
    emit(state.copyWith(userStatus: UserStatus.loading));
    // print("вызван выход");
    await databaseRepository.deleteUserFromDB(user);
    // print("отправлен запрос в бд");
    emit(state.copyWith(user: null, userStatus: UserStatus.unauthorized));
    // print("изменено состояние");
  }

  void addUserMoney(double money) async {
    if (state.user == null) {
      return;
    }
    final newUser =
        state.user!.copyWith(balance: ((state.user!.balance) + money));
    emit(state.copyWith(user: newUser, userStatus: UserStatus.success));
  }

  void withdrowUserMoney(double money) async {
    if (state.user == null) {
      return;
    }
    final newUser =
        state.user!.copyWith(balance: (state.user!.balance) - money);
    emit(state.copyWith(user: newUser, userStatus: UserStatus.success));
  }
}

class UserState {
  final User? user;
  final UserStatus userStatus;

  UserState({this.user, this.userStatus = UserStatus.initial});

  UserState copyWith({User? user, required UserStatus userStatus}) =>
      UserState(user: user ?? this.user, userStatus: userStatus);
}

enum UserStatus { loading, success, failure, unauthorized, initial }
