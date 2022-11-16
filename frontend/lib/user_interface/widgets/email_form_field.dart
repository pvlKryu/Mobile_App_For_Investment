import 'package:flutter/material.dart';

class EmailForm extends StatelessWidget {
  const EmailForm({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
      decoration: const InputDecoration(hintText: '@Email'),
    );
  }
}
