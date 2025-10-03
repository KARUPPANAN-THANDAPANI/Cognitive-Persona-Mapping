class SentimentDetector {
  static String detectMood(String text) {
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
}