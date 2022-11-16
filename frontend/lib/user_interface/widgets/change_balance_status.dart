// Функция для вывода окна-сообщения об ошибке при изменнии баланса
import 'package:flutter/material.dart';
import '../custom_theme.dart';

Future<dynamic> openChangeBalanceStatusWindow(
    BuildContext context, String message) {
  return showDialog(
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text(
            message,
            style: const TextStyle(
              fontSize: 20,
              color: AppColors.fontWhite,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      });
}
