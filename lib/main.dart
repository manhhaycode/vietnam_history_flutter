import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:vietnam_history/screens/home_page.dart';
import 'package:vietnam_history/screens/login_page.dart';
import 'package:vietnam_history/screens/quiz_page.dart';
import 'package:vietnam_history/utils/dio_client.dart';
import 'models/auth_model.dart';
import 'models/selection_state.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthModel()),
        ChangeNotifierProvider(create: (context) => SelectionState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16),
        ),
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            iconSize: 24,
          ),
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/quiz': (context) => const QuizPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
