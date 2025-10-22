import 'context_awareness.dart';
import 'conversation_memory.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ConversationNode {
  final String id;
  final String message;
  final List<String> responses;
  final Map<String, String> nextNodeMap;
  final String? fallback;

  ConversationNode({
    required this.id,
    required this.message,
    required this.responses,
    required this.nextNodeMap,
    this.fallback,
  });
}

class ConversationManager {
  final Map<String, ConversationNode> _dialogTree = {};
  String _currentNode = "intro";
  final List<Map<String, String>> _history = [];
  final ContextAwareness _ca = ContextAwareness();
  final ConversationMemory _mem = ConversationMemory();
  
  // 🆕 BACKEND INTEGRATION
  static const String _backendUrl = 'http://localhost:5000/api/chat'; // Your Python API

  ConversationManager() {
    _buildDialogTree();
  }

  void _buildDialogTree() {
    // ✅ EXISTING CODE UNCHANGED
    _dialogTree['intro'] = ConversationNode(
      id: 'intro',
      message: 'Hey there 👋 How are you feeling today?',
      responses: ['Good', 'Okay', 'Not great', 'Prefer not to say'],
      nextNodeMap: {
        'Good': 'good',
        'Okay': 'reflective',
        'Not great': 'not_great',
        'Prefer not to say': 'neutral_followup'
      },
      fallback: 'clarify_feeling'
    );
    // ... rest of your existing _buildDialogTree() unchanged
  }

  String get currentMessage => _dialogTree[_currentNode]?.message ?? "";

  List<String> get currentResponses =>
      _dialogTree[_currentNode]?.responses ?? [];

  // 🆕 ENHANCED METHOD WITH BACKEND OPTION
  Future<void> updateConversation({String? chosenLabel, String? freeText, bool useBackend = false}) async {
    final node = _dialogTree[_currentNode];
    if (node == null) return;

    if (chosenLabel != null) {
      _history.add({'role':'user','text':chosenLabel,'node':_currentNode});
      _currentNode = node.nextNodeMap[chosenLabel] ?? node.fallback ?? _currentNode;
    } else if (freeText != null) {
      _history.add({'role':'user','text':freeText,'node':_currentNode});

      // 🆕 BACKEND INTEGRATION FOR ADVANCED ANALYSIS
      if (useBackend) {
        final backendAnalysis = await _analyzeWithBackend(freeText);
        _mem.remember('backend_analysis', 
          'emotion:${backendAnalysis['emotion']},stage:${backendAnalysis['stage']},crisis:${backendAnalysis['is_crisis']}', 
          tag:'backend'
        );
        
        // Use backend emotion for smarter routing
        if (backendAnalysis['is_crisis'] == true) {
          _currentNode = 'crisis_protocol'; // You can add this node
        } else if (backendAnalysis['emotion'] == 'sad' || backendAnalysis['emotion'] == 'anxious') {
          _currentNode = 'not_great';
        } else {
          _currentNode = node.fallback ?? _currentNode;
        }
      } else {
        // ✅ EXISTING LOCAL ANALYSIS (UNCHANGED)
        final moodInfo = _ca.detectMoodWithConfidence(freeText);
        final intent = _ca.detectIntent(freeText);
        _mem.remember('analysis', 'mood:${moodInfo['mood']},intent:$intent', tag:'analysis');

        if (moodInfo['mood']=='negative' && moodInfo['conf'] > 0.2) {
          _currentNode = 'not_great';
        } else {
          _currentNode = node.fallback ?? _currentNode;
        }
      }
    }

    _history.add({'role':'bot','text':currentMessage,'node':_currentNode});
  }

  // 🆕 BACKEND ANALYSIS METHOD
  Future<Map<String, dynamic>> _analyzeWithBackend(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': text}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Backend error: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback to local analysis if backend fails
      print('Backend unavailable, using local analysis: $e');
      final moodInfo = _ca.detectMoodWithConfidence(text);
      return {
        'emotion': moodInfo['mood'],
        'stage': 'companion',
        'is_crisis': false,
        'response': currentMessage // Use existing dialog tree response
      };
    }
  }

  // 🆕 GET BACKEND SESSION REPORT
  Future<Map<String, dynamic>> getBackendSessionReport() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/api/session_report'));
      return json.decode(response.body);
    } catch (e) {
      return {'error': 'Backend unavailable', 'local_data': _history};
    }
  }

  List<Map<String,String>> get history => List.unmodifiable(_history);
}