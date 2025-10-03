// lib/Pages/mood_selection_screen.dart
import 'package:flutter/material.dart';
import 'motivational_tips_screen.dart';

class MoodSelectionScreen extends StatelessWidget {
  const MoodSelectionScreen({Key? key}) : super(key: key);

  void _navigateToMoodTips(BuildContext context, String mood) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MotivationalTipsScreen(mood: mood),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('How are you feeling?'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select your current mood:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMoodCard(
                    context,
                    '😊 Happy',
                    'happy',
                    Colors.green,
                  ),
                  _buildMoodCard(
                    context,
                    '😢 Sad',
                    'sad',
                    Colors.blue,
                  ),
                  _buildMoodCard(
                    context,
                    '😰 Stressed',
                    'stressed',
                    Colors.orange,
                  ),
                  _buildMoodCard(
                    context,
                    '😠 Angry',
                    'angry',
                    Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(BuildContext context, String title, String mood, Color color) {
    return Card(
      color: color,
      elevation: 4,
      child: InkWell(
        onTap: () => _navigateToMoodTips(context, mood),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title.split(' ')[0], // Emoji
                  style: const TextStyle(fontSize: 30),
                ),
                const SizedBox(height: 8),
                Text(
                  title.split(' ')[1], // Mood text
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}