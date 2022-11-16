import 'package:flutter/material.dart';
import 'custom_theme.dart';
import 'login.dart';
import '../domain/services/auth_client.dart';
import 'widgets/change_balance_status.dart';
import 'widgets/email_form_field.dart';
import 'widgets/signup_mistake_alert_window.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //Создадим контроллеры для считывания и обработки текста, введенного в текст. поля:
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
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
        title: const Text('Регистрация'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return AppColors.fontGrey;
      }
      return AppColors.darkBlue;
    }

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
                    NameForm(nameController: nameController),
                    const SizedBox(
                      height: 10,
                    ),
                    EmailForm(emailController: emailController),
                    const SizedBox(
                      height: 10,
                    ),
                    // Password form:
                    passwordFormField(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: AppColors.fontWhite,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: isChecked1,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked1 = value!;
                            });
                          },
                        ),
                        const Expanded(
                            child: Text(
                                'Согласен(-на) на обработку персональных данных')),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: AppColors.fontWhite,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: isChecked2,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked2 = value!;
                            });
                          },
                        ),
                        const Expanded(
                            child:
                                Text('Пользовательское соглашение прочитано')),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final nav = Navigator.of(context);
                        if (isChecked1 != true || isChecked2 != true) {
                          openChangeBalanceStatusWindow(context,
                              'Заполните поля и поставьте галочки в чек-боксах');
                        }
                        // При успешной валидации вводимых данных и нажатых чекбоксов
                        // Вызывается асинхронная функция отправки запроса на регистрацию:
                        if (_formKey.currentState!.validate() &&
                            isChecked1 == true &&
                            isChecked2 == true) {
                          bool signup = await AuthClient().userRegistration(
                              nameController.text.trim(),
                              emailController.text.trim(),
                              passwordController.text.trim());

                          if (signup) {
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
                      child: const Text('Создать аккаунт'),
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
                            side:
                                BorderSide(color: AppColors.darkBlue, width: 1),
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
                            side:
                                BorderSide(color: AppColors.darkBlue, width: 1),
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
              )),
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  TextFormField passwordFormField() {
    return TextFormField(
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

// На данном этапе реализована общая обработка всех ошибок:s

}

class NameForm extends StatelessWidget {
  const NameForm({
    Key? key,
    required this.nameController,
  }) : super(key: key);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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

        if (regExp1.hasMatch(value) || regExp2.hasMatch(value)) {
          return null;
        }

        return 'Это не ФИО';
      },
      controller: nameController,
      decoration: const InputDecoration(hintText: 'ФИО'),
    );
  }
}
