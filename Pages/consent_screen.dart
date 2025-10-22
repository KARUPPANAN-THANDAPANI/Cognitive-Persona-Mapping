import 'package:flutter/material.dart';
import 'package:chat_bot/oceantest/quiz_screen.dart';
import 'package:chat_bot/Pages/animated_chat_screen.dart';
import 'package:google_fonts/google_fonts.dart';

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

  // ADDED: Direct navigation to chatbot
  void _goToChatbot() {
    print('🎯 Chatbot button pressed - Navigating to Animated Chat');
    
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AnimatedChatScreen(),
        ),
      );
      print('✅ Navigation to AnimatedChatScreen completed');
    } catch (e) {
      print('❌ Error in _goToChatbot: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to MindBot',
          style: TextStyle(color: Color.fromARGB(255, 15, 14, 14)),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
children: [
  Text(
    'Disclaimer & Consent',
    style: GoogleFonts.agdasima(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFeatures: [FontFeature.enable('swsh')],
    ),
  ),
            const SizedBox(height: 10),
          Expanded(
  child: Center(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.6,
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        border: Border.all(color: const Color.fromARGB(255, 188, 185, 185), width: 2),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 1, 54, 70), 
            Color.fromARGB(139, 69, 126, 131), 
            Color.fromARGB(255, 78, 149, 84)
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(129, 86, 85, 85),
            blurRadius: 20,
            offset: Offset(5, 10),
            spreadRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Important Information',
              style: GoogleFonts.adventPro(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFeatures: [FontFeature.enable('swsh')],
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'This app is an offline mental well-being chatbot. '
              'It is not a substitute for professional medical advice.\n\n'
              'All your data, including chat history and quiz results, '
              'is stored locally on your device. No data is sent to any server.\n\n'
              'Your participation is voluntary. You can exit the app at any time.',
              style: GoogleFonts.adventPro(
                fontSize: 24,
                fontFeatures: [FontFeature.enable('swsh')],
                color: const Color.fromARGB(255, 255, 253, 253),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  ),
),
            const SizedBox(height: 20),
            
            // ADDED: Quick access to chatbot button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton.icon(
                onPressed: _goToChatbot,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                icon: const Icon(Icons.chat, size: 24),
                label: const Text(
                  'Go Directly to Chatbot',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            // UPDATED: Original buttons in a row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _agreeToConsent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Take OCEAN Quiz',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _disagreeToConsent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'I Do Not Agree',
                      style: TextStyle(fontSize: 16),
                    ),
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