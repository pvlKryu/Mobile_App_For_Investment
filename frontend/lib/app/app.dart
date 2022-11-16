import 'dart:async';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../domain/business_rules/brokerage_account_count.dart';
import '../domain/business_rules/search_shares.dart';
import '../domain/models/share.dart';
import '../domain/models/operation.dart';
import '../domain/repository/db_repository.dart';
import '../domain/repository/favorite_share_repository.dart';
import '../domain/repository/share_repository.dart';
import '../domain/repository/user_operations_repository.dart';
import '../domain/repository/user_share_repository.dart';
import '../user_interface/custom_theme.dart';
import '../user_interface/pin_code.dart';
import '../user_interface/portfolio.dart';
import '../user_interface/profile.dart';
import '../user_interface/settings.dart';
import '../user_interface/shares.dart';
import '../user_interface/welcome.dart';
import '../domain/database/database.dart';
import '../domain/repository/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.database}) : super(key: key);
  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => DatabaseRepository(db: database),
      child: BlocProvider(
        create: (context) =>
            UserBloc(databaseRepository: context.read())..load(),
        child: Builder(builder: (database) {
          return BlocBuilder<UserBloc, UserState>(builder: (context, state) {
            if (state.userStatus == UserStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ChangeNotifierProvider(
              create: (context) => ThemeProvider(),
              builder: (context, _) {
                final themeProvider = Provider.of<ThemeProvider>(context);
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  themeMode: themeProvider.themeMode,
                  theme: CustomTheme.lightTheme,
                  darkTheme: CustomTheme.darkTheme,
                  home: state.userStatus == UserStatus.success
                      ? const PasswordView(message: "Введите пин-код")
                      : const WelcomePage(),
                );
              },
            );
          });
        }),
      ),
    );
  }
}

class MyClass extends StatefulWidget {
  const MyClass({Key? key}) : super(key: key);

  @override
  State<MyClass> createState() => _MyClassState();
}

class _MyClassState extends State<MyClass> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  bool hasInternet = false;
  late StreamSubscription internetSubscription;
  String internetNotification = '';

  @override
  void initState() {
    super.initState();

    internetSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;

      setState(() => this.hasInternet = hasInternet);

      if (this.hasInternet == false) {
        internetNotification = 'Нет интернета';
      } else {
        internetNotification = 'Интернет есть';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            internetNotification,
            style: const TextStyle(fontSize: 30),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    internetSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserBloc>().state.user;
    final balance = user!.balance;
    return StreamBuilder<List<Share>>(
        stream: FavoriteSharesRepository().stream,
        builder: (context, snapshot4) {
          return StreamBuilder<List<Operation>>(
              stream: UserOperationsRepository().stream,
              builder: (context, snapshot3) {
                return StreamBuilder<List<Share>>(
                    stream: UserSharesRepository().stream,
                    builder: (context, snapshot1) {
                      return StreamBuilder<List<Share>>(
                          stream: SharesRepository().stream,
                          builder: (context, snapshot2) {
                            if (!snapshot2.hasData ||
                                !snapshot1.hasData ||
                                !snapshot3.hasData ||
                                !snapshot4.hasData) {
                              return const Scaffold(
                                  body: Center(
                                      child: CircularProgressIndicator()));
                            }

                            final appBarTitles = <Widget>[
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Брокерский счет: ',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: AppColors.fontWhite,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      ),
                                      Text(
                                        '${brokerageAccountCount(snapshot1.data!, context).toStringAsFixed(2)} ₽',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: AppColors.fontWhite,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Баланс: ",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: AppColors.fontWhite,
                                          fontWeight: FontWeight.w200,
                                          // fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      Text("${balance.toStringAsFixed(2)} ₽",
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: AppColors.fontWhite,
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                              const Text(
                                'Акции',
                                style: TextStyle(
                                  fontSize: 32,
                                  color: AppColors.fontWhite,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                              const Text(
                                'Профиль',
                                style: TextStyle(
                                  fontSize: 32,
                                  color: AppColors.fontWhite,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ];

                            return Scaffold(
                              appBar: AppBar(
                                flexibleSpace: SafeArea(
                                  child: Center(
                                      child: appBarTitles[_selectedIndex]),
                                ),
                                actions: [
                                  if (_selectedIndex == 1)
                                    IconButton(
                                      onPressed: () {
                                        showSearch(
                                          context: context,
                                          delegate: MySearchDelegate(),
                                        );
                                      },
                                      icon: const Icon(Icons.search),
                                    ),
                                  if (_selectedIndex == 2)
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SettingsPage()),
                                        );
                                      },
                                      icon: const Icon(Icons.settings),
                                    ),
                                ],
                              ),
                              body: IndexedStack(
                                index: _selectedIndex,
                                children: [
                                  PortfolioPage(
                                      shares: snapshot1.data!,
                                      operations: snapshot3.data!,
                                      favorites: snapshot4.data!),
                                  Shares(shares: snapshot2.data!),
                                  const Profile(),
                                ],
                              ),
                              bottomNavigationBar: BottomNavigationBar(
                                items: const <BottomNavigationBarItem>[
                                  BottomNavigationBarItem(
                                    icon: Icon(
                                      Icons.shopping_bag,
                                    ),
                                    label: 'Портфель',
                                  ),
                                  BottomNavigationBarItem(
                                    icon: Icon(
                                      Icons.leaderboard,
                                    ),
                                    label: 'Акции',
                                  ),
                                  BottomNavigationBarItem(
                                    icon: Icon(
                                      Icons.badge,
                                    ),
                                    label: 'Профиль',
                                  ),
                                ],
                                currentIndex: _selectedIndex,
                                onTap: _onItemTapped,
                              ),
                            );
                          });
                    });
              });
        });
  }
}
