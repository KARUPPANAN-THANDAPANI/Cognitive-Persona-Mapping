import 'package:flutter/material.dart';
import '../data/local_data_manager.dart';
import '../sentiment/sentiment_detector.dart';

class SentimentDemoScreen extends StatefulWidget {
  const SentimentDemoScreen({Key? key}) : super(key: key);

  @override
  _SentimentDemoScreenState createState() => _SentimentDemoScreenState();
}

class _SentimentDemoScreenState extends State<SentimentDemoScreen> {
  final TextEditingController _textController = TextEditingController();
  String _detectedMood = '';
  List<dynamic> _filteredTips = [];

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
                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredTips.isEmpty
                  ? const Center(child: Text('No tips to display'))
                  : ListView.builder(
                      itemCount: _filteredTips.length,
                      itemBuilder: (context, index) {
                        final tip = _filteredTips[index];
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(tip['text'] ?? 'No text'),
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