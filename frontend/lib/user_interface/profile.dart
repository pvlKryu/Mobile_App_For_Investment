// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repository/basic_token_repository.dart';
import '../domain/repository/user_bloc.dart';
import 'change_personal_data.dart';
import 'custom_theme.dart';
import 'faq.dart';

class Profile extends StatefulWidget {
  const Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  double targetValue = 130.0;
  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<UserBloc>(context).state.user!;
    final _basicTokenProvider = BasicTokenRepository();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: targetValue),
              duration: const Duration(seconds: 1),
              builder: (BuildContext context, double size, Widget? child) {
                return IconButton(
                  iconSize: size,
                  icon: child!,
                  onPressed: () {
                    setState(() {
                      targetValue = targetValue == 130.0 ? 180.0 : 130.0;
                    });
                  },
                );
              },
              child: const CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/images/user_icon.jpg'),
                backgroundColor: AppColors.fontBlack,
              )),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          ),
          SizedBox(
            width: 270,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePersonalData()),
                );
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 3,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              child: const Text(
                "Изменить данные",
                style: TextStyle(color: AppColors.fontWhite),
              ),
            ),
          ),
          SizedBox(
            width: 270,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FaqPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 3,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              child: const Text(
                "FAQ",
                style: TextStyle(color: AppColors.fontWhite),
              ),
            ),
          ),
          SizedBox(
            width: 270,
            height: 60,
            child: ElevatedButton(
              onPressed: () async {
                // Очистка безопасного локального хранилища
                await _basicTokenProvider.clearSecureStorage();
                await context.read<UserBloc>().logout(user);
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  elevation: 3,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold)),
              child: const Text(
                "Выйти",
                style: TextStyle(color: AppColors.fontWhite),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
