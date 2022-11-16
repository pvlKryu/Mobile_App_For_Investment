import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Switch.adaptive(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  final provider =
                      Provider.of<ThemeProvider>(context, listen: false);
                  provider.toggleTheme(value);
                },
              ),
              const Text('Изменить тему'),
            ],
          ),
          Row(
            children: [
              Switch(
                value: _value,
                onChanged: (bool value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
              const Text('Отключить push-уведомления'),
            ],
          ),
        ],
      ),
    );
  }
}
