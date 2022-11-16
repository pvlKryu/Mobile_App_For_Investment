import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/models/user.dart';
import '../domain/repository/basic_token_repository.dart';
import '../domain/repository/user_bloc.dart';
import '../domain/services/auth_client.dart';
import 'custom_theme.dart';
import 'login.dart';
import 'widgets/signup_mistake_alert_window.dart';

class ChangePersonalData extends StatefulWidget {
  const ChangePersonalData({Key? key}) : super(key: key);
  @override
  State<ChangePersonalData> createState() => _ChangePersonalDataState();
}

class _ChangePersonalDataState extends State<ChangePersonalData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Создадим контроллеры для считывания и обработки текста, введенного в текст. поля:
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _basicTokenProvider = BasicTokenRepository();
  // Bool для чекбоксов и проверки на их вкл.
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool _isObscure =
      true; // bool для отображения\не отображения вводимого пароля

// Прерываем текстовые контроллеры:
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Изменение данных',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 29,
            )),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final user = BlocProvider.of<UserBloc>(context).state.user!;
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
                    TextFormField(
                      // Валидация вводимых данных:
                      validator: (value) {
                        // На пустоту:
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите Ваше ФИО';
                        }
                        // На образец имени (русс + англ):
                        String p1 = r'^[а-яё А-ЯЁ,.\-]+$';
                        String p2 = r'^[a-z A-Z,.\-]+$';
                        RegExp regExp1 = RegExp(p1);
                        RegExp regExp2 = RegExp(p2);

                        if (regExp1.hasMatch(value) ||
                            regExp2.hasMatch(value)) {
                          return null;
                        }

                        return 'Это не ФИО';
                      },
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: user.name,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      // Валидация вводимых данных:
                      validator: (value) {
                        // На пустоту:
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите Ваш E-mail';
                        }
                        // На образец имейла:
                        String p =
                            // ignore: unnecessary_string_escapes
                            '[a-zA-Z0-9+.\_\%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+';
                        RegExp regExp = RegExp(p);

                        if (regExp.hasMatch(value)) return null;

                        return 'Это не E-mail';
                      },
                      controller: emailController,
                      decoration: InputDecoration(hintText: user.email),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: _isObscure,
                      // Валидация вводимых данных:
                      validator: (value) {
                        // На пустоту:
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите Ваш пароль';
                        }
                        // На удовлетворение сложности пароля:
                        RegExp regex = RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                        if (!regex.hasMatch(value)) {
                          return 'Исп. спец. символ, загл. букву, цифру, минимум 8 символов в длину';
                        }
                        return null;
                      },
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                        // Иконка для показать/спрятать пароль:
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final nav = Navigator.of(context);

                        // При успешной валидации вводимых данных и нажатых чекбоксов
                        // Вызывается асинхронная функция отправки запроса на регистрацию:
                        if (_formKey.currentState!.validate()) {
                          final token =
                              await _basicTokenProvider.getBasicToken();

                          User? updatedUser = await AuthClient().changeUserData(
                              token!,
                              nameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text.trim());

                          if (updatedUser != null) {
                            // Очистка безопасного локального хранилища
                            await _basicTokenProvider.clearSecureStorage();
                            // ignore: use_build_context_synchronously
                            await context.read<UserBloc>().logout(user);
                            // Если пользователь успешно зарегистрирован, то он попадает на стр. входа
                            nav.pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                              (Route<dynamic> route) => false,
                            );
                          } else {
                            // Если нет - видит сообщение об ошибке
                            // ignore: use_build_context_synchronously
                            signupMistakeAlertWindow(context);
                          }
                          // Очистка текстфилдов
                          nameController.clear();
                          emailController.clear();
                          passwordController.clear();
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
                      child: const Text('Перезайти в аккаунт'),
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }
}
