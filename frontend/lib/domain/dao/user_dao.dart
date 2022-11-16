// dao/person_dao.dart

import 'package:firstflutterproj/domain/models/user.dart';
import 'package:floor/floor.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM User')
  Future<List<User>> findAllUsers();

  @Query('SELECT * FROM User WHERE id = :id')
  Stream<User?> findUserById(int id);

  @insert
  Future<void> insertUser(User person);

  @Query('SELECT * FROM User')
  Stream<List<User>> findAllUsersAsStream();

  @delete
  Future<void> deleteUser(User user);

  @update
  Future<void> updateUser(User user);
}
