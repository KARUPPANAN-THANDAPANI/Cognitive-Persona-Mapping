// lib/data/local_data_manager.dart
class LocalDataManager {
  static Future<List<Map<String, dynamic>>> loadStressReliefPractices() async {
    // Mock data - replace with your actual data source
    return [
      {
        'title': 'Deep Breathing',
        'description': 'Practice 4-7-8 breathing technique to calm your nervous system.',
        'duration': '5 minutes',
        'color': 0xFF4CAF50, // Green - calm
      },
      {
        'title': 'Mindful Walking', 
        'description': 'Take a slow walk while focusing on your surroundings and breath.',
        'duration': '10 minutes',
        'color': 0xFF2196F3, // Blue - peace
      },
      {
        'title': 'Body Scan Meditation',
        'description': 'Systematically relax each part of your body from head to toe.',
        'duration': '15 minutes',
        'color': 0xFF9C27B0, // Purple - relaxation
      },
      {
        'title': 'Gratitude Journaling',
        'description': 'Write down three things you are grateful for today.',
        'duration': '5 minutes',
        'color': 0xFFFF9800, // Orange - warmth
      },
      {
        'title': 'Progressive Muscle Relaxation',
        'description': 'Tense and relax different muscle groups to release physical tension.',
        'duration': '10 minutes',
        'color': 0xFF795548, // Brown - grounding
      },
    ];
  }

  static Future<List<dynamic>> getTipsByMood(String mood) async {
    // Color mappings for moods
    final Map<String, int> moodColors = {
      'stressed': 0xFFFF9800, // Orange
      'sad': 0xFF2196F3,      // Blue
      'angry': 0xFFF44336,    // Red
      'happy': 0xFF4CAF50,    // Green
      'neutral': 0xFF9E9E9E,  // Grey
    };

    // Mock data for different moods - with proper IDs
    final Map<String, List<Map<String, dynamic>>> moodTips = {
      'stressed': [
        {
          'id': 101,
          'text': '💆 Try the 4-7-8 breathing technique: Inhale 4s, Hold 7s, Exhale 8s',
          'category': 'relaxation',
          'color': moodColors['stressed']!,
        },
        {
          'id': 102,
          'text': '🚶‍♂️ Take a 5-minute walk and focus on your surroundings',
          'category': 'exercise',
          'color': moodColors['stressed']!,
        },
        // ... rest of stressed tips with colors
      ],
      'sad': [
        {
          'id': 201,
          'text': '🌟 Remember three good things that happened today',
          'category': 'gratitude',
          'color': moodColors['sad']!,
        },
        {
          'id': 202,
          'text': '📞 Call a friend or family member for support',
          'category': 'social',
          'color': moodColors['sad']!,
        },
        // ... rest of sad tips with colors
      ],
      'angry': [
        {
          'id': 301,
          'text': '🔥 Count to 10 slowly before responding',
          'category': 'mindfulness',
          'color': moodColors['angry']!,
        },
        {
          'id': 302,
          'text': '💨 Take deep breaths - inhale calm, exhale anger',
          'category': 'breathing',
          'color': moodColors['angry']!,
        },
        // ... rest of angry tips with colors
      ],
      'happy': [
        {
          'id': 401,
          'text': '🎉 Share your happiness with someone else!',
          'category': 'social',
          'color': moodColors['happy']!,
        },
        {
          'id': 402,
          'text': '📸 Capture this moment with a photo or journal entry',
          'category': 'memory',
          'color': moodColors['happy']!,
        },
        // ... rest of happy tips with colors
      ],
      'neutral': [
        {
          'id': 501,
          'text': '🧘‍♀️ Practice mindfulness to stay present',
          'category': 'mindfulness',
          'color': moodColors['neutral']!,
        },
        {
          'id': 502,
          'text': '📚 Read a book or learn something new',
          'category': 'learning',
          'color': moodColors['neutral']!,
        },
        // ... rest of neutral tips with colors
      ],
    };

    // Return tips for the detected mood, or neutral tips if mood not found
    return moodTips[mood] ?? moodTips['neutral']!;
  }

  static Future<List<dynamic>> loadMotivationalTips() async {
    // Color mappings for general tips
    final Map<String, int> categoryColors = {
      'motivation': 0xFF4CAF50,    // Green
      'wellness': 0xFF2196F3,      // Blue
      'productivity': 0xFFFF9800,  // Orange
      'social': 0xFF9C27B0,        // Purple
      'confidence': 0xFFFFC107,    // Amber
      'growth': 0xFF795548,        // Brown
      'self-care': 0xFFE91E63,     // Pink
    };

    return [
      {
        'id': 1,
        'text': '🌟 Start your day with positive affirmations',
        'category': 'motivation',
        'mood': 'neutral',
        'color': categoryColors['motivation']!,
      },
      {
        'id': 2,
        'text': '💆 Practice mindfulness for 5 minutes daily',
        'category': 'wellness', 
        'mood': 'stressed',
        'color': categoryColors['wellness']!,
      },
      {
        'id': 3,
        'text': '🎯 Set small achievable goals each day',
        'category': 'productivity',
        'mood': 'neutral',
        'color': categoryColors['productivity']!,
      },
      {
        'id': 4, 
        'text': '🤗 Connect with a friend or loved one today',
        'category': 'social',
        'mood': 'sad',
        'color': categoryColors['social']!,
      },
      {
        'id': 5,
        'text': '💪 Remember your past successes when feeling doubtful',
        'category': 'confidence',
        'mood': 'sad',
        'color': categoryColors['confidence']!,
      },
      // ... rest of tips with colors
    ];
  }

  // NEW: Helper method to get color for a mood
  static int getColorForMood(String mood) {
    final moodColors = {
      'happy': 0xFF4CAF50,     // Green
      'sad': 0xFF2196F3,       // Blue
      'angry': 0xFFF44336,     // Red
      'stressed': 0xFFFF9800,  // Orange
      'neutral': 0xFF9E9E9E,   // Grey
    };
    return moodColors[mood] ?? 0xFF000000; // Default black
  }

  // NEW: Helper method to get color for a category
  static int getColorForCategory(String category) {
    final categoryColors = {
      'motivation': 0xFF4CAF50,
      'wellness': 0xFF2196F3,
      'productivity': 0xFFFF9800,
      'social': 0xFF9C27B0,
      'confidence': 0xFFFFC107,
      'growth': 0xFF795548,
      'self-care': 0xFFE91E63,
      'relaxation': 0xFF009688,
      'exercise': 0xFF3F51B5,
      'journaling': 0xFF607D8B,
      'music': 0xFF9C27B0,
      'creativity': 0xFFE91E63,
      'nature': 0xFF4CAF50,
      'mindfulness': 0xFF009688,
      'breathing': 0xFF00BCD4,
      'physical': 0xFFF44336,
      'space': 0xFF9E9E9E,
      'memory': 0xFFFF9800,
      'movement': 0xFF4CAF50,
      'kindness': 0xFFE91E63,
      'learning': 0xFF2196F3,
      'planning': 0xFFFFC107,
      'reflection': 0xFF795548,
    };
    return categoryColors[category] ?? 0xFF000000; // Default black
  }

  // ... rest of your existing favorite methods remain unchanged
  static List<int> _favoriteTipIds = [];

  static Future<List<int>> getFavoriteTipIds() async {
    try {
      return List<int>.from(_favoriteTipIds);
    } catch (e) {
      print("❌ Error in getFavoriteTipIds: $e");
      return [];
    }
  }

  static Future<void> saveFavoriteTip(int tipId) async {
    try {
      if (!_favoriteTipIds.contains(tipId)) {
        _favoriteTipIds.add(tipId);
        print("✅ Saved favorite: $tipId");
      }
    } catch (e) {
      print("❌ Error saving favorite $tipId: $e");
    }
  }

  static Future<void> removeFavoriteTip(int tipId) async {
    try {
      _favoriteTipIds.remove(tipId);
      print("✅ Removed favorite: $tipId");
    } catch (e) {
      print("❌ Error removing favorite $tipId: $e");
    }
  }

  static Future<List<dynamic>> getFavoriteTips() async {
    try {
      final allTips = await loadMotivationalTips();
      final favoriteIds = await getFavoriteTipIds();
      
      final favorites = allTips.where((tip) {
        final tipId = tip['id'] as int?;
        return tipId != null && favoriteIds.contains(tipId);
      }).toList();
      
      print("✅ Loaded ${favorites.length} favorite tips");
      return favorites;
    } catch (e) {
      print("❌ Error in getFavoriteTips: $e");
      return [];
    }
  }
}