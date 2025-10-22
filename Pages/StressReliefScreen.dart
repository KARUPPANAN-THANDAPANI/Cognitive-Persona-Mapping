import 'package:flutter/material.dart';
import '../data/local_data_manager.dart';

class StressReliefScreen extends StatefulWidget {
  const StressReliefScreen({Key? key}) : super(key: key);

  @override
  _StressReliefScreenState createState() => _StressReliefScreenState();
}

class _StressReliefScreenState extends State<StressReliefScreen> {
  List<dynamic> _practices = [];
  bool _isLoading = true;

  // Color constants for better maintainability
  static const Color _primaryColor = Colors.green;
  static const Color _primaryTextColor = Colors.white;
  static const Color _cardBackgroundColor = Color(0xFFE8F5E8); // Light green
  static const Color _titleTextColor = Colors.green;
  static const Color _descriptionTextColor = Colors.black87;
  static const Color _durationTextColor = Colors.grey;
  static const Color _iconColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _loadPractices();
  }

  void _loadPractices() async {
    final practices = await LocalDataManager.loadStressReliefPractices();
    setState(() {
      _practices = practices;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stress Relief Practices'),
        backgroundColor: _primaryColor,
        foregroundColor: _primaryTextColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _practices.isEmpty
              ? const Center(child: Text('No practices available'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _practices.length,
                  itemBuilder: (context, index) {
                    final practice = _practices[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      color: _cardBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              practice['title'] ?? 'No title',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: _titleTextColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              practice['description'] ?? 'No description',
                              style: const TextStyle(
                                fontSize: 16,
                                color: _descriptionTextColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.timer, size: 16, color: _iconColor),
                                const SizedBox(width: 4),
                                Text(
                                  practice['duration'] ?? 'Unknown duration',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: _durationTextColor,
                                    fontWeight: FontWeight.w500,
                                  ),
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
