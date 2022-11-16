// ignore_for_file: avoid_print

import '../database/database.dart';
import '../models/user.dart';

class DatabaseRepository {
  DatabaseRepository({required this.db});
  final AppDatabase db;

  // Добавление экземпляр класса Юзер в БД
  Future insertUserToDB(User user) async {
    await db.userDao.insertUser(user);
    // print("Пользователь добавлен");
  }

  // Очистка БД путем удаления всех таблиц
  Future deleteUserFromDB(User user) async {
    await db.userDao.deleteUser(user);
    // print("Пользователь удален");
  }

  // Изменение данных юзера
  Future updateUser(User user) async {
    await db.userDao.updateUser(user);
    // print("Пользователь изменен");
  }

  // Получение экземпляра класса Юзер из БД
  Future<User?> getUserFromDB() async {
    final List<User> users = await db.userDao.findAllUsers();
    if (users.isNotEmpty) {
      // print("Получение пользователя из БД");
      // print(users[0].name);
      return users[0];
    }
    return null;
  }
}
