// lib/services/sentiment_service.dart
class SentimentService {
  // Keyword lists (same as Python version)
  final List<String> positiveKeywords = [
    'happy', 'joy', 'love', 'excited', 'great', 'good', 'fantastic', 'wonderful'
  ];
  
  final List<String> negativeKeywords = [
    'sad', 'angry', 'hate', 'terrible', 'bad', 'awful', 'poor', 'fear'
  ];
  
  final List<String> neutralKeywords = [
    'okay', 'fine', 'average', 'neutral'
  ];

  // Rule-based sentiment analysis
  String ruleBasedSentimentAnalysis(String text) {
    final lowerText = text.toLowerCase();

    if (positiveKeywords.any((word) => lowerText.contains(word))) {
      return 'Positive(Rule-Based)';
    } else if (negativeKeywords.any((word) => lowerText.contains(word))) {
      return 'Negative(Rule-Based)';
    } else {
      return 'Neutral(Rule-Based)';
    }
  }

  // Combined sentiment detection
  String combinedSentimentAnalysis(String text) {
    final ruleResult = ruleBasedSentimentAnalysis(text);
    return ruleResult;
  }

  // Enhanced mood detection
  String detectMood(String text) {
    text = text.toLowerCase();
    
    // Happy detection
    if (text.contains('happy') || text.contains('good') || 
        text.contains('great') || text.contains('awesome') ||
        text.contains('excited') || text.contains('joy') ||
        text.contains('love') || text.contains('fantastic')) {
      return 'happy';
    }
    
    // Sad detection  
    if (text.contains('sad') || text.contains('bad') ||
        text.contains('terrible') || text.contains('awful') ||
        text.contains('depressed') || text.contains('unhappy') ||
        text.contains('miserable')) {
      return 'sad';
    }
    
    // Stressed detection
    if (text.contains('stress') || text.contains('anxious') ||
        text.contains('worried') || text.contains('overwhelmed') ||
        text.contains('pressure') || text.contains('tension') ||
        text.contains('burnout') || text.contains('anxiety')) {
      return 'stressed';
    }
    
    // Angry detection
    if (text.contains('angry') || text.contains('mad') ||
        text.contains('frustrated') || text.contains('annoyed') ||
        text.contains('hate') || text.contains('upset') ||
        text.contains('furious')) {
      return 'angry';
    }
    
    // Default
    return 'neutral';
  }

  void testSentimentAnalysis() {
    final sampleTexts = [
      "I am very happy with the service",
      "This is a bad idea",
      "This movie is terrible",
      "I love this product",
      "she is angry about the delay",
      "It's an average day",
      "The food was awful and bad",
      "I feel fantastic today"
    ];

    for (final txt in sampleTexts) {
      print('$txt -> ${ruleBasedSentimentAnalysis(txt)}');
    }
  }

  // Simple mood tips based on sentiment
  String getMoodTips(String sentiment) {
    if (sentiment.contains('Negative')) {
      return "💙 I notice some negative sentiment. Remember to take deep breaths and practice self-care.";
    } else if (sentiment.contains('Positive')) {
      return "🌟 Great positive energy! Keep spreading those good vibes!";
    } else {
      return "💭 Neutral mood detected. Stay balanced and mindful.";
    }
  }
}