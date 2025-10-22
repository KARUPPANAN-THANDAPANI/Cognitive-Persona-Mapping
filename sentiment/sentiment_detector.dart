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

  // NEW: Color mappings for moods
  static final Map<String, int> _moodColors = {
    'happy': 0xFF4CAF50,     // Green - growth, positivity
    'sad': 0xFF2196F3,       // Blue - calm, soothing
    'angry': 0xFFF44336,     // Red - intensity, passion  
    'stressed': 0xFFFF9800,  // Orange - warmth, energy
    'neutral': 0xFF9E9E9E,   // Grey - balance
  };

  // NEW: Get color for a specific mood
  static int getColorForMood(String mood) {
    return _moodColors[mood] ?? 0xFF000000; // Default black
  }

  // NEW: Detect mood and return with color information
  static Map<String, dynamic> detectMoodWithColor(String text) {
    final mood = detectMood(text); // Uses original method
    return {
      'mood': mood,
      'color': getColorForMood(mood),
      'text': text,
    };
  }

  // NEW: Get all available mood colors
  static Map<String, int> getMoodColors() {
    return Map.from(_moodColors); // Return a copy
  }
}