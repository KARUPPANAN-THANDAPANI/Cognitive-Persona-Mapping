import 'package:flutter/material.dart';
import 'package:chat_bot/oceantest/quiz_screen.dart';
import 'package:chat_bot/Pages/StressReliefScreen.dart';
import 'package:chat_bot/Pages/consent_screen.dart';

void main() {
  runApp(const OceanQuizApp());
}

class OceanQuizApp extends StatelessWidget {
  const OceanQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OCEAN Quiz',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
      home: const ConsentScreen(), // Changed to show ConsentScreen first
      routes: {
        '/stress-relief': (context) => const StressReliefScreen(),
      },
    );
  }
}