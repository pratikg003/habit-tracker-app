import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_tracker_app/pages/home.dart';
import 'package:habit_tracker_app/providers/habit_provider.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xffce93d8),
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    ChangeNotifierProvider(create: (_) => HabitProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      debugShowCheckedModeBanner: false,
      home: const Home(),
    );
  }
}
