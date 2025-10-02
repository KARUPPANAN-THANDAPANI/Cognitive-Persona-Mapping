import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sentiment_demo_screen.dart'; // ADD THIS IMPORT

class ConsentScreen extends StatefulWidget {
  const ConsentScreen({super.key});

  @override
  _ConsentScreenState createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  void _agreeToConsent() async {
    // Save to local storage that user agreed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('userAgreed', true);
    
    // FIXED: Add proper navigation to demo screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SentimentDemoScreen(),
      ),
    );
  }

  void _disagreeToConsent() {
    // Close the app if user doesn't agree
    print('User did not agree');
    // Optionally show a message or close app
    // For now, just print and stay on screen
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
                    onPressed: _agreeToConsent, // NOW NAVIGATES TO DEMO SCREEN
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