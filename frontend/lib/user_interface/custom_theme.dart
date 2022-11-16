import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: const ColorScheme.light(),
      fontFamily: 'Montserrat',
      primaryColor: AppColors.darkBlue,
      scaffoldBackgroundColor: Colors.white,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFFefeeee),
        selectedItemColor: AppColors.darkBlue,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontSize: 14),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
      cardTheme: const CardTheme(
          elevation: 5,
          shadowColor: Colors.blueGrey,
          color: AppColors.darkBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ))),
      dialogTheme: const DialogTheme(
        elevation: 25,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        backgroundColor: AppColors.darkBlue,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: AppColors.darkBlue,
        foregroundColor: AppColors.fontWhite,
        elevation: 5,
        titleTextStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              primary: AppColors.fontBlack,
              elevation: 0,
              backgroundColor: AppColors.fontWhite,
              textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.fontBlack))),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.darkBlue,
            textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColors.fontWhite)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: const ColorScheme.dark(),
      fontFamily: 'Montserrat',
      primaryColor: AppColors.darkBlue,
      scaffoldBackgroundColor: AppColors.backgroundDarkTheme,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.fontGrey,
        selectedItemColor: AppColors.fontWhite,
        unselectedItemColor: AppColors.fontBlack,
        selectedLabelStyle: TextStyle(fontSize: 14),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              primary: AppColors.fontWhite,
              elevation: 0,
              backgroundColor: AppColors.backgroundDarkTheme,
              textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.fontWhite))),
      cardTheme: const CardTheme(
          elevation: 5,
          shadowColor: Colors.blueGrey,
          color: AppColors.fontGrey,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ))),
      dialogTheme: const DialogTheme(
        elevation: 25,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        backgroundColor: AppColors.fontGrey,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        toolbarHeight: 100,
        backgroundColor: AppColors.fontGrey,
        foregroundColor: AppColors.fontBlack,
        elevation: 5,
        titleTextStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: TextButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.fontGrey,
            textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColors.fontWhite)),
      ),
    );
  }
}

abstract class AppColors {
  static const darkBlue = Color(0xff2f4f80);
  static const fontWhite = Color(0xffffffff);
  static const fontBlack = Color(0xff000000);
  static const orangeCardBorder = Color(0xfffd7210);
  static const greenBalanceAmount = Color(0xff13E17D);
  static const redBalanceAmount = Color(0xffF44336);
  static const alertInfoTextFolder = Color(0xff5b4f4f);
  static const fontGrey = Colors.grey;
  static const backgroundDarkTheme = Color.fromARGB(255, 54, 53, 53);
}
