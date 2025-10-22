import 'package:flutter/material.dart';
import '../data/local_data_manager.dart';
import '../sentiment/sentiment_detector.dart';
import 'motivational_tips_screen.dart';

class SentimentDemoScreen extends StatefulWidget {
  const SentimentDemoScreen({Key? key}) : super(key: key);

  @override
  _SentimentDemoScreenState createState() => _SentimentDemoScreenState();
}

class _SentimentDemoScreenState extends State<SentimentDemoScreen> {
  final TextEditingController _textController = TextEditingController();
  String _detectedMood = '';
  List<dynamic> _filteredTips = [];

  // Color constants for better maintainability
  static const Color _primaryTextColor = Colors.black87;
  static const Color _moodTextColor = Colors.blue; // Color for mood display
  static const Color _tipTextColor = Colors.black54;
  static const Color _emptyStateTextColor = Colors.grey;

  void _analyzeAndGetTips() {
    final text = _textController.text;
    if (text.isEmpty) return;

    final mood = SentimentDetector.detectMood(text);
    setState(() {
      _detectedMood = mood;
    });

    // Get tips based on detected mood
    _loadMoodTips(mood);
  }

  void _loadMoodTips(String mood) async {
    final tips = await LocalDataManager.getTipsByMood(mood);
    setState(() {
      _filteredTips = tips;
    });
  }

  // Get dynamic color based on mood
  Color _getMoodColor(String mood) {
    final moodColors = {
      'happy': Colors.green,
      'sad': Colors.blue,
      'angry': Colors.red,
      'stressed': Colors.orange,
      'neutral': Colors.grey,
    };
    return moodColors[mood] ?? Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sentiment + Tips Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Type how you feel...',
                hintText: 'e.g., "I feel stressed about work"',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _analyzeAndGetTips,
              child: const Text('Analyze & Get Tips'),
            ),
            const SizedBox(height: 16),
            if (_detectedMood.isNotEmpty)
              Text('Detected Mood: $_detectedMood', 
                   style: TextStyle(
                     fontSize: 18, 
                     fontWeight: FontWeight.bold,
                     color: _getMoodColor(_detectedMood), // Dynamic color based on mood
                   )),
            const SizedBox(height: 16),
            if (_detectedMood.isNotEmpty)
              Column(
                children: [
                  Text('Detected Mood: $_detectedMood', 
                       style: TextStyle(
                         fontSize: 18, 
                         fontWeight: FontWeight.bold,
                         color: _getMoodColor(_detectedMood), // Dynamic color based on mood
                       )),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MotivationalTipsScreen(mood: _detectedMood),
                        ),
                      );
                    },
                    child: Text('See More Tips for $_detectedMood'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            Expanded(
              child: _filteredTips.isEmpty
                  ? Center(
                      child: Text(
                        'No tips to display',
                        style: TextStyle(color: _emptyStateTextColor),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredTips.length,
                      itemBuilder: (context, index) {
                        final tip = _filteredTips[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              tip['text'] ?? 'No text',
                              style: TextStyle(color: _tipTextColor),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}