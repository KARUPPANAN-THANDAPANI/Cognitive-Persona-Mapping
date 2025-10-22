import '../data/local_data_manager.dart';
import '../sentiment/sentiment_detector.dart';

class MoodTipsHelper {
  // Get tips based on user's message sentiment
  static Future<List<dynamic>> getTipsForUserMessage(String userMessage) async {
    try {
      // 1. Detect mood from user message
      String mood = SentimentDetector.detectMood(userMessage);
      print('🎯 Detected mood: $mood from message: "$userMessage"');
      
      // 2. Get tips for that mood
      List<dynamic> tips = await LocalDataManager.getTipsByMood(mood);
      print('📝 Found ${tips.length} tips for mood: $mood');
      
      return tips;
    } catch (e) {
      print('❌ Error in getTipsForUserMessage: $e');
      return [];
    }
  }
  
  // Get a random tip for a specific mood
  static Future<String> getRandomTipForMood(String mood) async {
    try {
      List<dynamic> tips = await LocalDataManager.getTipsByMood(mood);
      if (tips.isNotEmpty) {
        final randomIndex = DateTime.now().millisecondsSinceEpoch % tips.length;
        final randomTip = tips[randomIndex];
        
        // Handle different data types in tips
        if (randomTip is Map<String, dynamic> && randomTip.containsKey('text')) {
          return randomTip['text'] ?? 'No tip available';
        } else if (randomTip is String) {
          return randomTip;
        } else {
          return 'I understand how you feel. Take a deep breath.';
        }
      }
      return 'I understand how you feel. Take a deep breath.';
    } catch (e) {
      print('❌ Error in getRandomTipForMood: $e');
      return 'Remember to take care of yourself today.';
    }
  }

  // NEW: Get color for a specific mood
  static int getColorForMood(String mood) {
    final moodColors = {
      'happy': 0xFF4CAF50,     // Green - growth, positivity
      'sad': 0xFF2196F3,       // Blue - calm, soothing
      'angry': 0xFFF44336,     // Red - intensity, passion  
      'anxious': 0xFFFF9800,   // Orange - warmth, energy
      'neutral': 0xFF9E9E9E,   // Grey - balance
      'excited': 0xFFFFC107,   // Amber - energy, excitement
      'tired': 0xFF795548,     // Brown - warmth, comfort
    };
    
    return moodColors[mood] ?? 0xFF000000; // Default black
  }

  // NEW: Get tips with color information
  static Future<List<Map<String, dynamic>>> getTipsWithColors(String userMessage) async {
    try {
      String mood = SentimentDetector.detectMood(userMessage);
      List<dynamic> tips = await LocalDataManager.getTipsByMood(mood);
      
      return tips.map((tip) {
        String text = '';
        if (tip is Map<String, dynamic> && tip.containsKey('text')) {
          text = tip['text'] ?? '';
        } else if (tip is String) {
          text = tip;
        }
        
        return {
          'text': text,
          'color': getColorForMood(mood),
          'mood': mood,
        };
      }).toList();
    } catch (e) {
      print('❌ Error in getTipsWithColors: $e');
      return [];
    }
  }

  // NEW: Get random tip with color
  static Future<Map<String, dynamic>> getRandomTipWithColor(String mood) async {
    try {
      List<dynamic> tips = await LocalDataManager.getTipsByMood(mood);
      if (tips.isNotEmpty) {
        final randomIndex = DateTime.now().millisecondsSinceEpoch % tips.length;
        final randomTip = tips[randomIndex];
        
        String text = '';
        if (randomTip is Map<String, dynamic> && randomTip.containsKey('text')) {
          text = randomTip['text'] ?? 'No tip available';
        } else if (randomTip is String) {
          text = randomTip;
        } else {
          text = 'I understand how you feel. Take a deep breath.';
        }
        
        return {
          'text': text,
          'color': getColorForMood(mood),
          'mood': mood,
        };
      }
      
      return {
        'text': 'I understand how you feel. Take a deep breath.',
        'color': getColorForMood(mood),
        'mood': mood,
      };
    } catch (e) {
      print('❌ Error in getRandomTipWithColor: $e');
      return {
        'text': 'Remember to take care of yourself today.',
        'color': getColorForMood('neutral'),
        'mood': 'neutral',
      };
    }
  }
}