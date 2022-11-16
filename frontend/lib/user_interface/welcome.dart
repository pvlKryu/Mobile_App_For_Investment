import 'package:flutter/material.dart';

import 'custom_theme.dart';
import 'login.dart';
import 'signup.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/welcomeBackgroundImage.jpg'),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 0, 48, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Добро пожаловать в АТБ-Invest',
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: AppColors.fontWhite,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 60),
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: AppColors.fontWhite, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      textStyle: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  child: const Text('Войти'),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    elevation: 0,
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.fontWhite, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                child: const Text('Создать аккаунт'),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 5),
                child: Text(
                  'Нажимая на кнопку "Войти", Вы соглашаетесь с пользовательским соглашением',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColors.fontWhite, fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
