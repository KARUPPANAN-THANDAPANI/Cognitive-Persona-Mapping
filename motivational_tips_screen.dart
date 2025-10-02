import 'package:flutter/material.dart';
import '../data/local_data_manager.dart';

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

  @override
  void initState() {
    super.initState();
    _currentMood = widget.mood;
    _loadTips();
    _loadFavorites();
  }

  void _loadTips() async {
    List<dynamic> tips;
    
    if (_currentMood != null) {
      tips = await LocalDataManager.getTipsByMood(_currentMood!);
    } else {
      tips = await LocalDataManager.loadMotivationalTips();
    }
    
    setState(() {
      _tips = tips;
      _isLoading = false;
    });
  }

  void _loadFavorites() async {
    final favoriteIds = await LocalDataManager.getFavoriteTipIds();
    setState(() {
      _favoriteTipIds = favoriteIds;
    });
  }

  bool _isTipFavorite(int tipId) {
    return _favoriteTipIds.contains(tipId);
  }

  void _toggleFavorite(int tipId) async {
    setState(() {
      if (_favoriteTipIds.contains(tipId)) {
        _favoriteTipIds.remove(tipId);
        LocalDataManager.removeFavoriteTip(tipId);
      } else {
        _favoriteTipIds.add(tipId);
        LocalDataManager.saveFavoriteTip(tipId);
      }
    });
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
    final favoriteTips = await LocalDataManager.getFavoriteTips();
    setState(() {
      _tips = favoriteTips;
      _isLoading = false;
      _currentMood = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentMood != null 
            ? 'Tips for ${_currentMood!.toUpperCase()}'
            : 'Motivational Tips'
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: _showFavorites,
            tooltip: 'Show favorites',
          ),
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
                      const Text('No tips available for this mood'),
                      const SizedBox(height: 16),
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
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    tip['text'] ?? 'No text',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isFavorite ? Icons.favorite : Icons.favorite_border,
                                    color: isFavorite ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () => _toggleFavorite(tipId),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Chip(
                                  label: Text(
                                    tip['category']?.toString().toUpperCase() ?? 'GENERAL',
                                    style: const TextStyle(fontSize: 12, color: Colors.white),
                                  ),
                                  backgroundColor: Colors.blue,
                                ),
                                if (_currentMood != null)
                                  Chip(
                                    label: Text(
                                      _currentMood!.toUpperCase(),
                                      style: const TextStyle(fontSize: 12, color: Colors.white),
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
    );
  }
}