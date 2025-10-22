import 'dart:convert';
import 'package:http/http.dart' as http;

class SentimentService {
  // ✅ EXISTING KEYWORDS UNCHANGED
  final List<String> positiveKeywords = [
    'happy', 'joy', 'love', 'excited', 'great', 'good', 'fantastic', 'wonderful',
    'amazing', 'better', 'improving', 'proud', 'confident'
  ];
  
  final List<String> negativeKeywords = [
    'sad', 'angry', 'hate', 'terrible', 'bad', 'awful', 'poor', 'fear', 'kill', 'suicide',
    'depressed', 'hopeless', 'worthless', 'failure', 'useless'
  ];
  
  final List<String> stressKeywords = [
    'stressed', 'stress', 'anxious', 'anxiety', 'panic', 'overwhelmed', 'pressure',
    'can\'t sleep', 'insomnia', 'worried', 'nervous', 'tense', 'burnout', 'exhausted',
    'fatigue', 'tired', 'drained', 'crying', 'breakdown',  'waking up', 'panicking', 'can\'t sleep', 'sleepless', 'night panic',
  'wake up panicking', 'racing thoughts', 'heart racing', 'can\'t breathe',
  'failing', 'failure', 'falling behind', 'not good enough'
  ];
  
  final List<String> neutralKeywords = [
    'okay', 'fine', 'average', 'neutral', 'meh', 'whatever'
  ];

  // ✅ EXISTING COLOR MAPPINGS UNCHANGED
  static final Map<String, int> _sentimentColors = {
    'Positive(Rule-Based)': 0xFF4CAF50,
    'Negative(Rule-Based)': 0xFFF44336,
    'Stress(Rule-Based)': 0xFFFF9800,
    'Neutral(Rule-Based)': 0xFF9E9E9E,
  };

  static final Map<String, String> _sentimentToMood = {
    'Positive(Rule-Based)': 'happy',
    'Negative(Rule-Based)': 'sad',
    'Stress(Rule-Based)': 'stressed',
    'Neutral(Rule-Based)': 'neutral',
  };

  // 🆕 BACKEND INTEGRATION
  static const String _backendUrl = 'http://localhost:5000/api/chat';

  // 🆕 ENHANCED ANALYSIS WITH BACKEND FALLBACK
  Future<Map<String, dynamic>> enhancedSentimentAnalysis(String text, {bool useBackend = true}) async {
    if (useBackend) {
      try {
        final backendResult = await _getBackendAnalysis(text);
        return {
          'sentiment': '${backendResult['emotion']}(Backend)',
          'color': _getColorForEmotion(backendResult['emotion']),
          'text': text,
          'intensity': backendResult['intensity'],
          'is_crisis': backendResult['is_crisis'],
          'source': 'backend'
        };
      } catch (e) {
        print('Backend failed, using local analysis: $e');
        // Fallback to local analysis
      }
    }
    
    // ✅ EXISTING LOCAL ANALYSIS (UNCHANGED)
    final localSentiment = ruleBasedSentimentAnalysis(text);
    return {
      'sentiment': localSentiment,
      'color': getColorForSentiment(localSentiment),
      'text': text,
      'is_crisis': isCrisisMessage(text),
      'source': 'local'
    };
  }

  // 🆕 BACKEND ANALYSIS METHOD
  Future<Map<String, dynamic>> _getBackendAnalysis(String text) async {
    final response = await http.post(
      Uri.parse(_backendUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'message': text}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Backend analysis failed');
    }
  }

  // 🆕 COLOR MAPPING FOR BACKEND EMOTIONS
  int _getColorForEmotion(String emotion) {
    final colorMap = {
      'happy': 0xFF4CAF50,
      'sad': 0xFFF44336,
      'angry': 0xFFF44336,
      'anxious': 0xFFFF9800,
      'fear': 0xFFFF9800,
      'neutral': 0xFF9E9E9E,
    };
    return colorMap[emotion] ?? 0xFF9E9E9E;
  }

  // ✅ ALL EXISTING METHODS REMAIN UNCHANGED
  String ruleBasedSentimentAnalysis(String text) {
    final lowerText = text.toLowerCase();
    if (stressKeywords.any((word) => lowerText.contains(word))) {
      return 'Stress(Rule-Based)';
    } else if (positiveKeywords.any((word) => lowerText.contains(word))) {
      return 'Positive(Rule-Based)';
    } else if (negativeKeywords.any((word) => lowerText.contains(word))) {
      return 'Negative(Rule-Based)';
    } else {
      return 'Neutral(Rule-Based)';
    }
  }

  bool isCrisisMessage(String text) {
    final lowerText = text.toLowerCase();
    final crisisKeywords = [
      'suicide', 'kill myself', 'end it all', 'want to die', 'harm myself',
      'panic attack', 'can\'t breathe', 'going to die', 'emergency', 'can\'t go on', 'end my life',
    'don\'t want to live', 'better off dead', 'no point living', 'give up',
    'panic attack', 'can\'t breathe', 'going to die', 'emergency', 'disappear'
     'killed', 'murder', 'died', 'dead', 'violence', 'abuse', 'attack',
    'hurt', 'beaten', 'shot', 'stabbed', 'assault', 'trauma', 'emergency',
    'police', '911', 'ambulance', 'hospital', 'bleeding', 'weapon'
    ];
    return crisisKeywords.any((word) => lowerText.contains(word));
  }

  double getStressLevel(String text) {
    final lowerText = text.toLowerCase();
    int stressWordCount = stressKeywords.where((word) => lowerText.contains(word)).length;
    int negativeWordCount = negativeKeywords.where((word) => lowerText.contains(word)).length;
    
    return (stressWordCount + negativeWordCount) / 10.0;
  }

  String combinedSentimentAnalysis(String text) {
    return ruleBasedSentimentAnalysis(text);
  }

  String detectMood(String text) {
    final sentiment = ruleBasedSentimentAnalysis(text);
    return _sentimentToMood[sentiment] ?? 'neutral';
  }

  static int getColorForSentiment(String sentiment) {
    return _sentimentColors[sentiment] ?? 0xFF000000;
  }

  Map<String, dynamic> analyzeSentimentWithColor(String text) {
    final sentiment = ruleBasedSentimentAnalysis(text);
    return {
      'sentiment': sentiment,
      'color': getColorForSentiment(sentiment),
      'text': text,
    };
  }

  static Map<String, int> getSentimentColors() {
    return Map.from(_sentimentColors);
  }
}