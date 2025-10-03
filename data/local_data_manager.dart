// lib/data/local_data_manager.dart
class LocalDataManager {
  static Future<List<Map<String, dynamic>>> loadStressReliefPractices() async {
    // Mock data - replace with your actual data source
    return [
      {
        'title': 'Deep Breathing',
        'description': 'Practice 4-7-8 breathing technique to calm your nervous system.',
        'duration': '5 minutes'
      },
      {
        'title': 'Mindful Walking', 
        'description': 'Take a slow walk while focusing on your surroundings and breath.',
        'duration': '10 minutes'
      },
      {
        'title': 'Body Scan Meditation',
        'description': 'Systematically relax each part of your body from head to toe.',
        'duration': '15 minutes'
      },
      {
        'title': 'Gratitude Journaling',
        'description': 'Write down three things you are grateful for today.',
        'duration': '5 minutes'
      },
      {
        'title': 'Progressive Muscle Relaxation',
        'description': 'Tense and relax different muscle groups to release physical tension.',
        'duration': '10 minutes'
      },
    ];
  }

static Future<List<dynamic>> getTipsByMood(String mood) async {
  // Mock data for different moods - with proper IDs
  final Map<String, List<Map<String, dynamic>>> moodTips = {
    'stressed': [
      {
        'id': 101,
        'text': '💆 Try the 4-7-8 breathing technique: Inhale 4s, Hold 7s, Exhale 8s',
        'category': 'relaxation'
      },
      {
        'id': 102,
        'text': '🚶‍♂️ Take a 5-minute walk and focus on your surroundings',
        'category': 'exercise'
      },
      {
        'id': 103,
        'text': '📝 Write down what\'s stressing you - getting it out helps',
        'category': 'journaling'
      },
      {
        'id': 104,
        'text': '🎵 Listen to calming music or nature sounds',
        'category': 'music'
      },
      {
        'id': 105,
        'text': '💧 Drink a glass of water and stretch your body',
        'category': 'self-care'
      },
    ],
    'sad': [
      {
        'id': 201,
        'text': '🌟 Remember three good things that happened today',
        'category': 'gratitude'
      },
      {
        'id': 202,
        'text': '📞 Call a friend or family member for support',
        'category': 'social'
      },
      {
        'id': 203,
        'text': '🎨 Express your feelings through drawing or writing',
        'category': 'creativity'
      },
      {
        'id': 204,
        'text': '🌞 Get some sunlight or sit by a window',
        'category': 'wellness'
      },
      {
        'id': 205,
        'text': '🍎 Eat a healthy snack and stay hydrated',
        'category': 'self-care'
      },
    ],
    'angry': [
      {
        'id': 301,
        'text': '🔥 Count to 10 slowly before responding',
        'category': 'mindfulness'
      },
      {
        'id': 302,
        'text': '💨 Take deep breaths - inhale calm, exhale anger',
        'category': 'breathing'
      },
      {
        'id': 303,
        'text': '🥊 Use a pillow to safely release physical tension',
        'category': 'physical'
      },
      {
        'id': 304,
        'text': '📓 Write a letter you\'ll never send',
        'category': 'journaling'
      },
      {
        'id': 305,
        'text': '🚶‍♀️ Remove yourself from the situation and take a walk',
        'category': 'space'
      },
    ],
    'happy': [
      {
        'id': 401,
        'text': '🎉 Share your happiness with someone else!',
        'category': 'social'
      },
      {
        'id': 402,
        'text': '📸 Capture this moment with a photo or journal entry',
        'category': 'memory'
      },
      {
        'id': 403,
        'text': '🤗 Do something kind for others - spread the joy',
        'category': 'kindness'
      },
      {
        'id': 404,
        'text': '💃 Dance to your favorite happy song',
        'category': 'movement'
      },
      {
        'id': 405,
        'text': '🌱 Use this positive energy to start a new project',
        'category': 'productivity'
      },
    ],
    'neutral': [
      {
        'id': 501,
        'text': '🧘‍♀️ Practice mindfulness to stay present',
        'category': 'mindfulness'
      },
      {
        'id': 502,
        'text': '📚 Read a book or learn something new',
        'category': 'learning'
      },
      {
        'id': 503,
        'text': '🌿 Connect with nature - notice plants and animals',
        'category': 'nature'
      },
      {
        'id': 504,
        'text': '🎯 Set a small goal for today',
        'category': 'planning'
      },
      {
        'id': 505,
        'text': '💭 Check in with your body - how are you really feeling?',
        'category': 'reflection'
      },
    ],
  };

  // Return tips for the detected mood, or neutral tips if mood not found
  return moodTips[mood] ?? moodTips['neutral']!;
}
static Future<List<dynamic>> loadMotivationalTips() async {
  return [
    {
      'id': 1,
      'text': '🌟 Start your day with positive affirmations',
      'category': 'motivation',
      'mood': 'neutral'
    },
    {
      'id': 2,
      'text': '💆 Practice mindfulness for 5 minutes daily',
      'category': 'wellness', 
      'mood': 'stressed'
    },
    {
      'id': 3,
      'text': '🎯 Set small achievable goals each day',
      'category': 'productivity',
      'mood': 'neutral'
    },
    {
      'id': 4, 
      'text': '🤗 Connect with a friend or loved one today',
      'category': 'social',
      'mood': 'sad'
    },
    {
      'id': 5,
      'text': '💪 Remember your past successes when feeling doubtful',
      'category': 'confidence',
      'mood': 'sad'
    },
    {
      'id': 6,
      'text': '🌞 Take a walk in nature to refresh your mind',
      'category': 'wellness',
      'mood': 'stressed'
    },
    {
      'id': 7,
      'text': '📚 Learn something new every day',
      'category': 'growth',
      'mood': 'neutral'
    },
    {
      'id': 8,
      'text': '🎉 Celebrate your small victories',
      'category': 'motivation',
      'mood': 'happy'
    },
    {
      'id': 9,
      'text': '🧘‍♀️ Practice deep breathing when feeling overwhelmed',
      'category': 'wellness',
      'mood': 'stressed'
    },
    {
      'id': 10,
      'text': '💖 Be kind to yourself - you are doing your best',
      'category': 'self-care',
      'mood': 'sad'
    },
  ];
}

// Replace ALL your favorite methods with these:

// Simple in-memory storage for favorites
static List<int> _favoriteTipIds = [];

static Future<List<int>> getFavoriteTipIds() async {
  try {
    // Return copy to prevent modification issues
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
    
    // Filter and ensure we have valid data
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