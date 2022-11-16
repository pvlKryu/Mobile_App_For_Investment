import 'package:flutter/material.dart';
import 'app/app.dart';
import 'domain/database/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database: database));
}
