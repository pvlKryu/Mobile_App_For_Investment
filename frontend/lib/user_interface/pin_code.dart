// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import '../app/app.dart';
import '../domain/repository/pin_code_repository.dart';
import 'custom_theme.dart';

class PasswordView extends StatefulWidget {
  const PasswordView({Key? key, required this.message}) : super(key: key);
  final String message;
  @override
  State<PasswordView> createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  var selectedindex = 0;
  String code = '';

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = const TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w500,
      color: AppColors.fontBlack,
    );
    final pinCodeProvider = PinCodeRepository();
    final nav = Navigator.of(context);
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(color: AppColors.darkBlue),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      widget.message,
                      style: const TextStyle(
                        fontSize: 23,
                        color: AppColors.fontWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DigitHolder(
                            width: width,
                            index: 0,
                            selectedIndex: selectedindex,
                            code: code,
                          ),
                          DigitHolder(
                              width: width,
                              index: 1,
                              selectedIndex: selectedindex,
                              code: code),
                          DigitHolder(
                              width: width,
                              index: 2,
                              selectedIndex: selectedindex,
                              code: code),
                          DigitHolder(
                              width: width,
                              index: 3,
                              selectedIndex: selectedindex,
                              code: code),
                        ],
                      )),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        addDigit(1);
                                      },
                                      child: Text('1', style: textStyle)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        addDigit(2);
                                      },
                                      child: Text('2', style: textStyle)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        addDigit(3);
                                      },
                                      child: Text('3', style: textStyle)),
                                ),
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        addDigit(4);
                                      },
                                      child: Text('4', style: textStyle)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        addDigit(5);
                                      },
                                      child: Text('5', style: textStyle)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        addDigit(6);
                                      },
                                      child: Text('6', style: textStyle)),
                                ),
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        addDigit(7);
                                      },
                                      child: Text('7', style: textStyle)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        addDigit(8);
                                      },
                                      child: Text('8', style: textStyle)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        addDigit(9);
                                      },
                                      child: Text('9', style: textStyle)),
                                ),
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        backspace();
                                      },
                                      child: const Icon(
                                          Icons.backspace_outlined,
                                          color: AppColors.fontBlack,
                                          size: 30)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () {
                                        addDigit(0);
                                      },
                                      child: Text('0', style: textStyle)),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextButton(
                                      onPressed: () async {
                                        String? pinFromRep =
                                            await pinCodeProvider.getPinCode();
                                        if (code.length > 3) {
                                          if (pinFromRep == null) {
                                            await pinCodeProvider
                                                .setPinCode(code);
                                            nav.pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MyClass()),
                                              (Route<dynamic> route) => false,
                                            );
                                          } else if (code == pinFromRep) {
                                            nav.pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const MyClass()),
                                              (Route<dynamic> route) => false,
                                            );
                                          } else {
                                            pinMistakeAlertWindow(
                                                context, 'Неверный пин-код');
                                          }
                                        } else {
                                          pinMistakeAlertWindow(context,
                                              'Пин-код состоит из 4 цифр');
                                        }
                                      },
                                      child: const Icon(Icons.check,
                                          color: AppColors.fontBlack,
                                          size: 30)),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  addDigit(int digit) {
    if (code.length > 3) {
      return;
    }
    setState(() {
      code = code + digit.toString();
      selectedindex = code.length;
    });
  }

  backspace() {
    if (code.isEmpty) {
      return;
    }
    setState(() {
      code = code.substring(0, code.length - 1);
      selectedindex = code.length;
    });
  }
}

Future<dynamic> pinMistakeAlertWindow(BuildContext context, String mistake) {
  return showDialog(
      context: context,
      builder: (context) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          title: Text(
            mistake,
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

class DigitHolder extends StatelessWidget {
  final int selectedIndex;
  final int index;
  final String code;
  const DigitHolder({
    required this.selectedIndex,
    Key? key,
    required this.width,
    required this.index,
    required this.code,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: width * 0.17,
      width: width * 0.17,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: index == selectedIndex ? Colors.blue : Colors.transparent,
              offset: const Offset(0, 0),
              spreadRadius: 1.5,
              blurRadius: 2,
            )
          ]),
      child: code.length > index
          ? Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                color: AppColors.fontBlack,
                shape: BoxShape.circle,
              ),
            )
          : Container(),
    );
  }
}
