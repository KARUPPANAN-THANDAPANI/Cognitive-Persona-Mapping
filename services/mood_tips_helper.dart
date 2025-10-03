import '../data/local_data_manager.dart';
import '../sentiment/sentiment_detector.dart'; // Fixed import - same directory

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
}