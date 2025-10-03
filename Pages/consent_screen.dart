import 'package:flutter/material.dart';
import 'package:chat_bot/oceantest/quiz_screen.dart';

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  _ConsentScreenState createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  void _agreeToConsent() async {
    print('🎯 Agree button pressed - Navigating to Quiz');
    
    try {
      // Navigate to Quiz Screen (first in flow)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const QuizScreen(),
        ),
      );
      print('✅ Navigation to QuizScreen completed');
    } catch (e) {
      print('❌ Error in _agreeToConsent: $e');
    }
  }

  void _disagreeToConsent() {
    print('User did not agree');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Consent Required'),
        content: const Text('You need to agree to the terms to use this app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to MindBot'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Important Information',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'This app is an offline mental well-being chatbot. '
                  'It is not a substitute for professional medical advice.\n\n'
                  'All your data, including chat history and quiz results, '
                  'is stored locally on your device. No data is sent to any server.\n\n'
                  'Your participation is voluntary. You can exit the app at any time.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _agreeToConsent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('I Agree'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _disagreeToConsent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('I Do Not Agree'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}