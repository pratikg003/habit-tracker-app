import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker_app/pages/about.dart';
import 'package:habit_tracker_app/pages/home.dart';
import 'package:habit_tracker_app/pages/settings.dart';
import 'package:habit_tracker_app/pages/themes.dart';
import 'package:habit_tracker_app/providers/habit_provider.dart';
import 'package:habit_tracker_app/providers/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xffce93d8),
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (_) => const Home(),
        '/themes': (_) => const Themes(),
        '/settings': (_) => const Settings(),
        '/about': (_) => const About(),
      },
    );
  }
}
