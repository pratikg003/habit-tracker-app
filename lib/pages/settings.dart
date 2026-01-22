import 'package:flutter/material.dart';
import 'package:habit_tracker_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListTile(
        title: const Text('Dark Mode'),
        trailing: Switch(
          value: context.watch<ThemeProvider>().isDark,
          onChanged: (_) {
            context.read<ThemeProvider>().toggleTheme();
          },
        ),
      ),
    );
  }
}
