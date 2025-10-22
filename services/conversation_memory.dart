import 'dart:convert';
import 'package:http/http.dart' as http;

class ConversationMemory {
  final List<Map<String, String>> _memory = [];

  // 🆕 BACKEND SYNC CAPABILITY
  static const String _backendUrl = 'http://localhost:5000/api/save_conversation';

  void remember(String role, String text, {String? tag}) {
    final memoryEntry = {
      "role": role,
      "text": text,
      "tag": tag ?? "",
      "time": DateTime.now().toIso8601String()
    };
    
    _memory.add(memoryEntry);
    
    // 🆕 OPTIONAL: SYNC TO BACKEND IN REAL-TIME
    _syncToBackend(memoryEntry);
  }

  List<Map<String, String>> get memory => List.unmodifiable(_memory);

  String recallLastUserMessage() {
    for (final msg in _memory.reversed) {
      if (msg["role"] == "user") return msg["text"] ?? "";
    }
    return "";
  }

  Map<String, String>? recallLastByTag(String tag) {
    for (final msg in _memory.reversed) {
      if ((msg["tag"] ?? "") == tag) return msg;
    }
    return null;
  }

  // 🆕 BACKEND SYNC METHOD
  Future<void> _syncToBackend(Map<String, String> memoryEntry) async {
    try {
      await http.post(
        Uri.parse(_backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'conversation_entry': memoryEntry,
          'sync_time': DateTime.now().toIso8601String()
        }),
      );
    } catch (e) {
      // Silent fail - backend sync is optional
      print('Backend sync failed: $e');
    }
  }

  // 🆕 GET BACKEND MEMORY SUMMARY
  Future<Map<String, dynamic>> getBackendMemorySummary() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/api/session_report'));
      final backendData = json.decode(response.body);
      
      return {
        'local_memory_count': _memory.length,
        'backend_session_data': backendData,
        'combined_insights': _combineInsights(backendData)
      };
    } catch (e) {
      return {
        'local_memory_count': _memory.length,
        'backend_available': false,
        'local_data': _memory
      };
    }
  }

  Map<String, dynamic> _combineInsights(Map<String, dynamic> backendData) {
    // Combine local and backend insights
    final localEmotions = _memory.where((entry) => entry['tag'] == 'analysis').toList();
    
    return {
      'total_conversations': _memory.length,
      'backend_emotions': backendData['user_insights'] ?? {},
      'local_analysis_count': localEmotions.length,
    };
  }
}