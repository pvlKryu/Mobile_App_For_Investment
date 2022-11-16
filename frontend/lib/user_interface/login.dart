// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:firstflutterproj/domain/repository/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../domain/repository/basic_token_repository.dart';
import '../domain/services/auth_client.dart';
import 'custom_theme.dart';
import 'pin_code.dart';
import 'widgets/email_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Создадим контроллеры для считывания и обработки текста, введенного в текст. поля:
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _basicTokenProvider = BasicTokenRepository();

  bool _isObscure = true;
// bool для отображения\не отображения вводимого пароля
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Авторизация'),
      ),
      body: _buildBody(context),
    );
  }

// Прерываем текстовые контроллеры:
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 35, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Заполните поля:',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  EmailForm(emailController: emailController),
                  const SizedBox(
                    height: 10,
                  ),
                  // Password form:
                  passwordFormField(),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //Вспомогательные переменные:
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();
                      final nav = Navigator.of(context);

                      // При успешной валидации вводимой почты
                      // Вызывается асинхронная функция отправки запроса на регистрацию:
                      if (_formKey.currentState!.validate()) {
                        String basicAuth =
                            'Basic ${base64.encode(utf8.encode('$email:$password'))}';

                        // В получаем экземпляр Юзера или null
                        final user = await AuthClient().userLogin(basicAuth);

                        // Если получили юзера:
                        if (user != null) {
                          // Запись токена пользователя в безопасный репозиторий:
                          await _basicTokenProvider.setBasicToken(basicAuth);

                          // ignore: use_build_context_synchronously
                          BlocProvider.of<UserBloc>(context).insert(user);
                          nav.pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const PasswordView(
                                    message: "Создайте пин-код")),
                            (Route<dynamic> route) => false,
                          );
                        } else {
                          // Если нет - видит сообщение об ошибке:
                          // ignore: use_build_context_synchronously
                          loginMistakeAlertWindow(context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal)),
                    child: const Text('Войти'),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: const [
                      Expanded(
                        child: Divider(
                          color: AppColors.fontGrey,
                          height: 1.5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "ИЛИ",
                          style: TextStyle(
                            color: AppColors.fontGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          height: 1.5,
                          color: AppColors.fontGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Логика кнопки пока не реализована
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: AppColors.fontWhite,
                        minimumSize: const Size(double.infinity, 30),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(color: AppColors.darkBlue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        )),
                    child: const Text(
                      'Войти через Facebook',
                      style: TextStyle(color: AppColors.darkBlue),
                    ),
                  ),
                  // Логика кнопки пока не реализована
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        primary: AppColors.fontWhite,
                        minimumSize: const Size(double.infinity, 30),
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(color: AppColors.darkBlue, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        )),
                    child: const Text(
                      'Войти через Google',
                      style: TextStyle(color: AppColors.darkBlue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextFormField passwordFormField() {
    return TextFormField(
      obscureText: _isObscure,
      // Валидация вводимых данных:
      validator: (value) {
        // На пустоту:
        if (value == null || value.isEmpty) {
          return 'Пожалуйста, введите Ваш пароль';
        }
        return null;
      },
      controller: passwordController,
      decoration: InputDecoration(
        labelText: 'Пароль',
        // Иконка для показать/спрятать пароль:
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
          // Изменение состояния:
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
    );
  }

  // На данном этапе реализована общая обработка всех ошибок:
  Future<dynamic> loginMistakeAlertWindow(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop(true);
          });
          return const AlertDialog(
            title: Text(
              'Неверный email или пароль',
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
}
