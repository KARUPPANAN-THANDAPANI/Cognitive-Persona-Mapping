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
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
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
                      color: Colors.green[50],
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
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              practice['description'] ?? 'No description',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.timer, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(
                                  practice['duration'] ?? 'Unknown duration',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
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