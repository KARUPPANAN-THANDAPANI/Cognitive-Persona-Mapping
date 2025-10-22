
import 'package:flutter/material.dart';
import 'package:chat_bot/Pages/consent_screen.dart';
import 'package:chat_bot/Pages/animated_chat_screen.dart';
import 'package:chat_bot/Pages/StressReliefScreen.dart';
import 'package:chat_bot/oceantest/quiz_screen.dart';
import 'package:chat_bot/Pages/animated_chat_screen.dart'; 

void main() {
  runApp(const MindBotApp());
}

class MindBotApp extends StatelessWidget {
  const MindBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindBot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const ConsentScreen(),
      routes: {
        '/consent': (context) => const ConsentScreen(),
        '/chatbot': (context) => const AnimatedChatScreen(),
        '/stress-relief': (context) => const StressReliefScreen(),
        '/quiz': (context) => const QuizScreen(),
      },
    );
  }
}
