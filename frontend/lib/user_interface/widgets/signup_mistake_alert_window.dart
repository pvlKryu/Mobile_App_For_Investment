import 'package:flutter/material.dart';
import '../custom_theme.dart';

Future<dynamic> signupMistakeAlertWindow(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return const AlertDialog(
          title: Text(
            'Пользователь зарегистрирован',
            style: TextStyle(
              fontSize: 20,
              color: AppColors.fontWhite,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      });
}
