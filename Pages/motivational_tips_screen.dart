import 'package:flutter/material.dart';
import '../data/local_data_manager.dart';
import '../services/mood_tips_helper.dart';

class MotivationalTipsScreen extends StatefulWidget {
  final String? mood;
  
  const MotivationalTipsScreen({Key? key, this.mood}) : super(key: key);

  @override
  _MotivationalTipsScreenState createState() => _MotivationalTipsScreenState();
}

class _MotivationalTipsScreenState extends State<MotivationalTipsScreen> {
  List<dynamic> _tips = [];
  bool _isLoading = true;
  String? _currentMood;
  List<int> _favoriteTipIds = [];

  // Color constants for better maintainability
  static const Color _appBarTextColor = Colors.white;
  static const Color _tipTextColor = Colors.black87;
  static const Color _emptyStateIconColor = Colors.grey;
  static const Color _emptyStateTextColor = Colors.grey;
  static const Color _chipTextColor = Colors.white;
  static const Color _randomTipBadgeTextColor = Colors.white;
  static const Color _favoriteIconColor = Colors.red;
  static const Color _unfavoriteIconColor = Colors.grey;
  static const Color _floatingActionButtonColor = Colors.amber;

  @override
  void initState() {
    super.initState();
    _currentMood = widget.mood;
    _loadTips();
    _loadFavorites();
  }

  void _loadTips() async {
    try {
      List<dynamic> tips;
      
      if (_currentMood != null) {
        // USE MOODTIPSHELPER FOR MOOD-BASED TIPS
        tips = await MoodTipsHelper.getTipsForUserMessage("I feel $_currentMood");
        print('📝 Loaded ${tips.length} tips for mood: $_currentMood');
      } else {
        // Fallback to local data manager for all tips
        tips = await LocalDataManager.loadMotivationalTips();
        print('📝 Loaded ${tips.length} general tips');
      }
      
      setState(() {
        _tips = tips;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading tips: $e');
      setState(() {
        _tips = [];
        _isLoading = false;
      });
    }
  }

  void _loadFavorites() async {
    try {
      final favoriteIds = await LocalDataManager.getFavoriteTipIds();
      setState(() {
        _favoriteTipIds = favoriteIds;
      });
      print('❤️ Loaded ${favoriteIds.length} favorite tips');
    } catch (e) {
      print('❌ Error loading favorites: $e');
    }
  }

  bool _isTipFavorite(int tipId) {
    return _favoriteTipIds.contains(tipId);
  }

  void _toggleFavorite(int tipId) async {
    try {
      print("🔄 Toggling favorite for tip: $tipId");
      
      setState(() {
        if (_favoriteTipIds.contains(tipId)) {
          _favoriteTipIds.remove(tipId);
          print("➖ Removed favorite: $tipId");
        } else {
          _favoriteTipIds.add(tipId);
          print("➕ Added favorite: $tipId");
        }
      });
      
      // Save/remove from storage
      if (_favoriteTipIds.contains(tipId)) {
        await LocalDataManager.saveFavoriteTip(tipId);
      } else {
        await LocalDataManager.removeFavoriteTip(tipId);
      }
      
    } catch (e) {
      print("❌ Error toggling favorite: $e");
    }
  }

  void _showAllTips() {
    setState(() {
      _currentMood = null;
      _isLoading = true;
    });
    _loadTips();
  }

  void _showFavorites() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final favoriteTips = await LocalDataManager.getFavoriteTips();
      setState(() {
        _tips = favoriteTips;
        _isLoading = false;
        _currentMood = null;
      });
      print('❤️ Showing ${favoriteTips.length} favorite tips');
    } catch (e) {
      print('❌ Error loading favorites: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // GET RANDOM TIP FOR THE CURRENT MOOD
  void _getRandomTip() async {
    if (_currentMood != null) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final randomTipText = await MoodTipsHelper.getRandomTipForMood(_currentMood!);
        
        // Create a temporary tip object to display
        final randomTip = {
          'id': DateTime.now().millisecondsSinceEpoch, // Unique ID
          'text': randomTipText,
          'category': 'random',
          'isRandom': true
        };
        
        setState(() {
          _tips = [randomTip]; // Show only the random tip
          _isLoading = false;
        });
        
        print('🎲 Displaying random tip for $_currentMood');
      } catch (e) {
        print('❌ Error getting random tip: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentMood != null 
            ? 'Tips for ${_currentMood!.toUpperCase()}'
            : 'Motivational Tips'
        ),
        backgroundColor: _getAppBarColor(),
        foregroundColor: _appBarTextColor,
        actions: [
          // RANDOM TIP BUTTON - ONLY SHOW WHEN VIEWING MOOD-SPECIFIC TIPS
          if (_currentMood != null)
            IconButton(
              icon: const Icon(Icons.casino),
              onPressed: _getRandomTip,
              tooltip: 'Get Random Tip',
            ),
          // FAVORITES BUTTON
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _showFavorites,
            tooltip: 'Show favorites',
          ),
          // SHOW ALL TIPS BUTTON - ONLY WHEN FILTERED
          if (_currentMood != null)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: _showAllTips,
              tooltip: 'Show all tips',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tips.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sentiment_dissatisfied,
                        size: 64,
                        color: _emptyStateIconColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tips available',
                        style: TextStyle(fontSize: 18, color: _emptyStateTextColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _currentMood != null 
                            ? 'for ${_currentMood!.toLowerCase()} mood'
                            : 'at the moment',
                        style: TextStyle(fontSize: 14, color: _emptyStateTextColor),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _showAllTips,
                        child: const Text('Show All Tips'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _tips.length,
                  itemBuilder: (context, index) {
                    final tip = _tips[index];
                    final tipId = tip['id'] as int;
                    final isFavorite = _isTipFavorite(tipId);
                    final isRandomTip = tip['isRandom'] == true;
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // RANDOM TIP BADGE
                            if (isRandomTip)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'RANDOM TIP',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: _randomTipBadgeTextColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (isRandomTip) const SizedBox(height: 8),
                            
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    tip['text'] ?? 'No text available',
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.4,
                                      color: _tipTextColor,
                                    ),
                                  ),
                                ),
                                if (!isRandomTip) // Don't allow favoriting random tips
                                  IconButton(
                                    icon: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: isFavorite ? _favoriteIconColor : _unfavoriteIconColor,
                                    ),
                                    onPressed: () => _toggleFavorite(tipId),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (tip['category'] != null && !isRandomTip)
                                  Chip(
                                    label: Text(
                                      tip['category'].toString().toUpperCase(),
                                      style: TextStyle(fontSize: 10, color: _chipTextColor),
                                    ),
                                    backgroundColor: Colors.blue,
                                  ),
                                if (_currentMood != null && !isRandomTip)
                                  const SizedBox(width: 8),
                                if (_currentMood != null && !isRandomTip)
                                  Chip(
                                    label: Text(
                                      _currentMood!.toUpperCase(),
                                      style: TextStyle(fontSize: 10, color: _chipTextColor),
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      // FLOATING ACTION BUTTON FOR RANDOM TIP
      floatingActionButton: _currentMood != null
          ? FloatingActionButton(
              onPressed: _getRandomTip,
              child: const Icon(Icons.casino),
              backgroundColor: _floatingActionButtonColor,
              tooltip: 'Get Random Tip',
            )
          : null,
    );
  }

  Color _getAppBarColor() {
    if (_currentMood != null) {
      switch (_currentMood!.toLowerCase()) {
        case 'happy': return Colors.green;
        case 'sad': return Colors.blue;
        case 'stressed': return Colors.orange;
        case 'angry': return Colors.red;
        default: return Colors.blue;
      }
    }
    return Colors.blue;
  }
}