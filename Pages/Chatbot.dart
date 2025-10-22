
import 'dart:convert';
import 'package:chat_bot/apikey.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:chat_bot/services/sentiment_service.dart';
import 'package:chat_bot/Pages/StressReliefScreen.dart';
import 'sentiment_demo_screen.dart'; 
import 'package:chat_bot/services/mood_tips_helper.dart';
import 'mood_selection_screen.dart';
import 'package:chat_bot/services/typing_indicators_service.dart';
import 'stage_visualization.dart';
import 'package:chat_bot/services/stage_transition.dart';
import 'package:chat_bot/services/cbt_service.dart';
import 'package:chat_bot/services/conversation_manager.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});
  
  @override
  State<Chatbot> createState() => _ChatbotState();
}

final ChatUser currentUser = ChatUser(
  id: "1",
  firstName: "Customers",
  lastName: "MindOwners",
  profileImage: 'assets/images/bot_avatar.png',
);

final ChatUser gptChatUser = ChatUser(
  id: "2",
  firstName: "InnoQuad",
  lastName: "Mindbusters",
  profileImage: 'assets/images/bot2_avatar.png',
);

class _ChatbotState extends State<Chatbot> {
  List<ChatMessage> chat1 = [];
  bool useOnlineApi = false;
  final SentimentService _sentimentService = SentimentService();
  bool _hasShownStressRelief = false;
  bool _isTyping = false;
  
  // Integrated services
  StageTransitionLogic stageLogic = StageTransitionLogic();
  CBTService cbtService = CBTService();
  ConversationManager convManager = ConversationManager();
  
  // Stage management
  String _currentStage = 'companion';
  String _detectedMood = '';
  int _messageCount = 0;
  double _moodConsistency = 0.7;
  double _userEngagement = 0.8;

  // 🆕 BACKEND INTEGRATION
  static const String _backendUrl = 'http://localhost:5000/api/chat';
  bool _backendAvailable = false;

  @override
  void initState() {
    super.initState();
    // 🆕 CHECK BACKEND ON STARTUP
    _checkBackendConnection();
  }

  // 🆕 BACKEND CONNECTION CHECK
  void _checkBackendConnection() async {
    try {
      final response = await http.get(Uri.parse("http://localhost:5000/api/health"));
      setState(() {
        _backendAvailable = response.statusCode == 200;
      });
      print('🔗 Backend status: ${_backendAvailable ? 'Connected' : 'Disconnected'}');
    } catch (e) {
      setState(() {
        _backendAvailable = false;
      });
      print('🔗 Backend connection failed: $e');
    }
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
      print('Backend analysis failed: $e');
      // Fallback to local analysis
      return {
        'emotion': _sentimentService.detectMood(text),
        'stage': 'companion',
        'is_crisis': _sentimentService.isCrisisMessage(text),
        'response': _getElevatedResponse(text),
        'source': 'local_fallback'
      };
    }
  }

  void _addBotMessage(String text) {
    setState(() {
      chat1.insert(
        0,
        ChatMessage(
          user: gptChatUser,
          createdAt: DateTime.now(),
          text: text,
        ),
      );
    });
  }

  void _showTypingIndicator() {
    setState(() {
      _isTyping = true;
    });
  }

  void _hideTypingIndicator() {
    if (_isTyping) {
      setState(() {
        _isTyping = false;
      });
    }
  }

  // Crisis response methods
  bool _isViolenceTraumaMessage(String text) {
    final lowerText = text.toLowerCase();
    final violenceKeywords = [
      'killed', 'murder', 'dead', 'died', 'violence', 'abuse', 'attack',
      'hurt', 'beaten', 'shot', 'stabbed', 'assault', 'weapon', 'blood'
    ];
    return violenceKeywords.any((word) => lowerText.contains(word));
  }

  void _handleCrisisResponse(ChatMessage userMessage) {
    String crisisResponse = """
🚨 **I hear you're in distress and I'm here to help immediately.**

**For immediate support:**
• National Suicide Prevention Lifeline: 988
• Crisis Text Line: Text HOME to 741741
• Emergency Services: 911

**Right now, try this:**
1. Sit down and place both feet flat on the floor
2. Take a slow breath in for 4 counts
3. Hold for 2 counts  
4. Breathe out for 6 counts
5. Repeat 5 times

You're not alone in this. Let's get through this moment together.
""";

    _addBotMessage(crisisResponse);
    
    // Immediately show stress relief techniques
    _hideTypingIndicator();
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StressReliefScreen()),
      );
    }
  }

  void _handleTraumaCrisis(ChatMessage userMessage) {
    String traumaResponse = """
🚨 **EMERGENCY - I hear you're dealing with a serious situation**

**IMMEDIATE ACTION NEEDED:**
• Call 911 or Emergency Services RIGHT NOW
• Get to a safe location if possible
• Contact a trusted adult, teacher, or neighbor

**CRISIS SUPPORT:**
• National Domestic Violence Hotline: 1-800-799-7233
• Crisis Text Line: Text HOME to 741741
• Childhelp National Abuse Hotline: 1-800-422-4453

**Right Now:**
• Your safety is the most important thing
• Help is available - you don't have to handle this alone
• Professional support can guide you through this

Please reach out for immediate help. This is too serious to handle alone.
""";

    _addBotMessage(traumaResponse);
    
    _hideTypingIndicator();
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StressReliefScreen()),
      );
    }
  }

  void _handleSleepCrisis(ChatMessage userMessage) {
    String sleepCrisisResponse = """
I hear you're waking up panicking and can't sleep. This is incredibly distressing, but there are immediate techniques that can help:

🌙 **For Night Panic Attacks:**
• **4-7-8 Breathing:** Inhale 4s, hold 7s, exhale 8s (repeat 4x)
• **Temperature Change:** Splash cold water or hold ice cube
• **Grounding:** Name 5 things you can see, 4 you can touch, 3 you can hear

🛌 **Before Bed:**
• Write worries down 1 hour before sleep
• No screens 30 minutes before bed
• Progressive muscle relaxation

Would you like me to guide you through a specific technique right now?
""";

    _addBotMessage(sleepCrisisResponse);
  }

  bool _isSleepCrisisMessage(String text) {
    final lowerText = text.toLowerCase();
    final sleepCrisisKeywords = [
      'can\'t sleep', 'waking up', 'wake up panicking', 'night panic',
      'sleepless', 'insomnia', 'racing thoughts at night', 'panic in sleep'
    ];
    return sleepCrisisKeywords.any((word) => lowerText.contains(word));
  }

  // Stage management methods
  void _updateStageMetrics(String userMessage) {
    setState(() {
      _messageCount++;
    });
    
    // Calculate metrics from user behavior
    double consistency = _calculateMessageConsistency();
    double engagement = _calculateEngagementLevel();
    double responseTime = _calculateAverageResponseTime();
    
    // Update stage logic
    stageLogic.assessStability(consistency, engagement, responseTime);
    stageLogic.updateStage();
    
    // Detect risk
    double moodFluctuation = _calculateMoodFluctuation(_detectedMood);
    stageLogic.detectRisk(moodFluctuation);
    
    // Update UI
    setState(() {
      _currentStage = stageLogic.currentStage == 1 ? 'companion' : 'psychologist';
    });
    
    // Handle escalation if needed
    if (stageLogic.escalationRequired) {
      _showCrisisProtocol(stageLogic.escalateIfNeeded());
    }
  }

  // Helper methods for stage metrics
  double _calculateMessageConsistency() {
    return _moodConsistency;
  }
  
  double _calculateEngagementLevel() {
    return _userEngagement;
  }
  
  double _calculateAverageResponseTime() {
    return 0.1 + (Random().nextDouble() * 0.8);
  }
  
  double _calculateMoodFluctuation(String currentMood) {
    return Random().nextDouble();
  }

  void _showCrisisProtocol(String message) {
    print("🚨 Crisis Protocol: $message");
    // You can show an alert dialog here if needed
  }

  Widget _buildCustomTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TypingIndicatorsService.getIndicator(mood: _detectedMood),
          const SizedBox(width: 8),
          Text(
            'Thinking...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 170, 192, 202),
        title: Row(children: [
          CircleAvatar(
            backgroundImage: const AssetImage('assets/images/bot2_avatar.png'),
            backgroundColor: Colors.transparent,
            radius: 25,
          ),
          const Padding(padding: EdgeInsets.only(left: 30)),
          const Text(
            "InnoQuad",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              fontFamily: 'DancingScript',
              color: Color.fromARGB(255, 54, 106, 136),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              // 🆕 SHOW BACKEND STATUS
              Icon(
                _backendAvailable ? Icons.cloud_done : Icons.cloud_off,
                color: _backendAvailable ? Colors.green : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                useOnlineApi ? "Online" : "Offline",
                style: TextStyle(
                  fontSize: 16,
                  color: useOnlineApi ? Colors.green : const Color.fromARGB(255, 188, 22, 130),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: useOnlineApi,
                onChanged: (value) {
                  setState(() {
                    useOnlineApi = value;
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.psychology),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SentimentDemoScreen()),
                  );
                },
              )
            ],
          )
        ]),
      ),
      body: Column(
        children: [
          // Stage Visualization Component
          StageVisualization(
            currentStage: _currentStage,
            onStageTap: (stage) {
              setState(() {
                _currentStage = stage;
              });
            },
          ),
          
          // Chat Area
          Expanded(
            child: Stack(
              children: [
                DashChat(
                  key: ValueKey(chat1.length),
                  currentUser: currentUser,
                  messages: chat1,
                  typingUsers: _isTyping ? [gptChatUser] : [],
                  onSend: (ChatMessage message) {
                    if (message.text.trim().isNotEmpty) {
                      setState(() {
                        _isTyping = true;
                      });
                      getChatResponse(message);
                    }
                  },
                  inputOptions: InputOptions(
                    sendOnEnter: true,
                    alwaysShowSend: true,
                    inputTextStyle: const TextStyle(color: Colors.black, fontSize: 16),
                    textController: TextEditingController(),
                    inputDecoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 230, 240, 250),
                      hintText: "Type your message here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    sendButtonBuilder: (onSend) {
                      return IconButton(
                        icon: const Icon(Icons.send, color: Color.fromARGB(255, 204, 144, 185)),
                        onPressed: onSend,
                      );
                    },
                  ),
                  messageOptions: MessageOptions(
                    showCurrentUserAvatar: true,
                    showOtherUsersAvatar: true,
                    showTime: true,
                    avatarBuilder: (user, onAvatarTap, avatarSize) {
                      return CircleAvatar(
                        radius: 24, 
                        backgroundImage: user.profileImage != null
                            ? AssetImage(user.profileImage!)
                            : null,
                        backgroundColor: Colors.transparent,
                      );
                    },
                    currentUserContainerColor: Colors.blueAccent,
                    currentUserTextColor: const Color.fromARGB(255, 213, 251, 232),
                    containerColor: const Color.fromARGB(255, 39, 42, 57),
                    textColor: const Color.fromARGB(255, 14, 190, 210),
                  ),
                ),
                
                if (_isTyping)
                  Positioned(
                    bottom: 80,
                    left: 16,
                    child: _buildCustomTypingIndicator(),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MoodSelectionScreen(),
            ),
          );
        },
        child: const Icon(Icons.emoji_emotions),
        backgroundColor: Colors.purple,
        tooltip: 'Get Mood Tips',
      ),
    );
  }

  // 🆕 ENHANCED MAIN CHAT RESPONSE METHOD WITH BACKEND INTEGRATION
  Future<void> getChatResponse(ChatMessage userMessage) async {
    setState(() {
      chat1.insert(0, userMessage);
      _isTyping = true;
    });
    
    print('=== DEBUG CRISIS DETECTION ===');
    print('📝 USER MESSAGE: "${userMessage.text}"');
    
    // 🆕 USE BACKEND FOR ADVANCED ANALYSIS IF AVAILABLE
    Map<String, dynamic> backendAnalysis = {};
    if (_backendAvailable) {
      print('🔗 Using backend for advanced analysis...');
      backendAnalysis = await _analyzeWithBackend(userMessage.text);
      print('🔗 Backend Analysis: ${backendAnalysis['emotion']} - Crisis: ${backendAnalysis['is_crisis']}');
    }

    // Test all crisis detectors
    final bool isViolenceTrauma = _isViolenceTraumaMessage(userMessage.text);
    final bool isCrisis = _sentimentService.isCrisisMessage(userMessage.text);
    final bool isSleepCrisis = _isSleepCrisisMessage(userMessage.text);
    
    print('🔍 Violence/Trauma Detection: $isViolenceTrauma');
    print('🔍 Suicide Crisis Detection: $isCrisis');
    print('🔍 Sleep Crisis Detection: $isSleepCrisis');
    
    // 🚨 VIOLENCE/TRAUMA DETECTION - FIRST
    if (isViolenceTrauma) {
      print('🚨 VIOLENCE/TRAUMA DETECTED - Emergency protocol');
      _handleTraumaCrisis(userMessage);
      return;
    }
    
    // 🆕 USE BACKEND EMOTION ANALYSIS OR FALLBACK TO LOCAL
    String emotion;
    if (_backendAvailable && backendAnalysis['emotion'] != null) {
      emotion = backendAnalysis['emotion'];
    } else {
      // Fallback to local sentiment analysis
      final sentiment = _sentimentService.combinedSentimentAnalysis(userMessage.text);
      emotion = _sentimentService.detectMood(userMessage.text);
    }
    
    // 🆕 USE BACKEND CRISIS DETECTION OR FALLBACK TO LOCAL
    bool crisisDetected = isCrisis;
    if (_backendAvailable && backendAnalysis['is_crisis'] != null) {
      crisisDetected = backendAnalysis['is_crisis'] || isCrisis;
    }

    print('🔍 Sentiment Analysis: $emotion');
    print('🔍 Crisis Detection: $crisisDetected');
    
    // CRISIS DETECTION
    if (crisisDetected) {
      print('🚨 CRISIS DETECTED - Emergency protocol');
      _handleCrisisResponse(userMessage);
      return;
    }
    
    // SLEEP CRISIS DETECTION
    if (isSleepCrisis) {
      print('🚨 SLEEP CRISIS DETECTED - Emergency protocol');
      _handleSleepCrisis(userMessage);
      return;
    }
    
    setState(() {
      _detectedMood = emotion;
    });

    print('🎯 Emotion: $emotion');
    print('🎯 Current Stage: $_currentStage');

    // Update conversation manager for contextual responses
    convManager.updateConversation(freeText: userMessage.text);
    String contextualResponse = convManager.currentMessage;

    // Update stage progression using target structure
    _updateStageMetrics(userMessage.text);

    final allTips = await MoodTipsHelper.getTipsForUserMessage(userMessage.text);
    final randomTip = await MoodTipsHelper.getRandomTipForMood(emotion);

    // 🆕 USE BACKEND RESPONSE IF AVAILABLE, OTHERWISE USE EXISTING LOGIC
    String finalResponse;
    if (_backendAvailable && backendAnalysis['response'] != null) {
      finalResponse = backendAnalysis['response'];
    } else {
      // Stage-aware responses with CBT integration
      if (_currentStage == 'companion') {
        finalResponse = "I understand you're feeling $emotion. $randomTip";
      } else {
        // Use CBT service for psychologist stage
        String cbtResponse = cbtService.generateSupportiveMessage(userMessage.text);
        finalResponse = "From a supportive perspective: $cbtResponse";
      }
    }

    final negativeMoods = ['stressed', 'sad', 'angry', 'anxious'];
    final isNegativeMood = negativeMoods.contains(emotion.toLowerCase());
    
    // Therapeutic elements for negative moods
    if (isNegativeMood) {
      String therapeuticResponse = cbtService.generateSupportiveMessage(userMessage.text);
      
      // Add therapeutic message
      _addBotMessage(therapeuticResponse);
      
      // Show stress relief for first negative mood detection
      if (!_hasShownStressRelief && allTips.isNotEmpty) {
        print('⚠️ Negative mood detected: $emotion - Showing stress relief');
        
        Future.delayed(const Duration(seconds: 2), () {
          _hideTypingIndicator();
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StressReliefScreen()),
            ).then((_) {
              _hasShownStressRelief = false;
            });
          }
        });
        
        _hasShownStressRelief = true;
        return;
      }
    } else {
      _addBotMessage(finalResponse);
    }
    
    // For positive/neutral moods or if already shown stress relief
    if (allTips.isNotEmpty && isNegativeMood) {
      _addBotMessage(finalResponse);
    }
    
    // Continue with normal chat response
    if (useOnlineApi) {
      await _getOnlineResponse(userMessage);
    } else {
      await _getOfflineResponse(userMessage);
    }
    
    _hideTypingIndicator();
  }

  // Online response method
  Future<void> _getOnlineResponse(ChatMessage userMessage) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/responses"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $OpenAI_API_key",
        },
        body: jsonEncode({
          "model": "gpt-4.1-nano",
          "input": userMessage.text,
        }),
      );

      _hideTypingIndicator();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final output = data["output"]?[0]?["content"]?[0]?["text"];

        setState(() {
          chat1.insert(
            0,
            ChatMessage(
              user: gptChatUser,
              createdAt: DateTime.now(),
              text: output ?? "[No content]",
            ),
          );
        });
      } else {
        setState(() {
          chat1.insert(
            0,
            ChatMessage(
              user: gptChatUser,
              createdAt: DateTime.now(),
              text: "[Error ${response.statusCode}: ${response.body}]",
            ),
          );
        });
      }
    } catch (e) {
      _hideTypingIndicator();
      setState(() {
        chat1.insert(
          0,
          ChatMessage(
            user: gptChatUser,
            createdAt: DateTime.now(),
            text: "[Exception: $e]",
          ),
        );
      });
    }
  }

  // Offline response method
  Future<void> _getOfflineResponse(ChatMessage userMessage) async {
    await Future.delayed(const Duration(seconds: 1));
    
    String responseText = _getElevatedResponse(userMessage.text);
    setState(() {
      chat1.insert(
        0,
        ChatMessage(
          user: gptChatUser,
          createdAt: DateTime.now(),
          text: responseText,
        ),
      );
    });
    
    _hideTypingIndicator();
  }

  // Elevated response method
  String _getElevatedResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    final random = Random();

    // Crisis detection in offline mode
    if (_sentimentService.isCrisisMessage(userMessage)) {
      return "I hear you're in distress. Let's focus on getting you through this moment safely. Would you like to try a grounding exercise together?";
    }
  
    // Sleep crisis responses
    if (message.contains('can\'t sleep') || message.contains('waking up') || message.contains('panicking')) {
      final sleepCrisisResponses = [
        "I hear you're having trouble sleeping due to panic. Nighttime anxiety is common but treatable. Let's try the 4-7-8 breathing technique: breathe in 4 counts, hold 7, exhale 8.",
        "Waking up panicked is really distressing. This is often related to daytime stress. Let's work on some bedtime relaxation routines.",
        "Sleep panic attacks feel terrifying but are manageable. Try placing a cold cloth on your forehead - it can help calm the nervous system immediately."
      ];
      return sleepCrisisResponses[random.nextInt(sleepCrisisResponses.length)];
    }
    
    final upliftingResponses = [
      "🌟 That's an amazing thought! The world needs more creative thinkers like you!",
      "💫 I love your energy! Your question is sparking some brilliant AI neurons!",
      "🚀 Wow, what an interesting perspective! You're really making me think!",
      "🎉 Fantastic question! This is exactly the kind of curiosity that moves us forward!",
      "🌈 Your message just brightened my digital day! Thanks for sharing that!",
      "🔥 Now THAT'S a thought worth exploring! You've got a great mind for innovation!",
      "✨ I'm genuinely excited by your question! This is going to be fun to explore!",
      "🎯 Brilliant point! You're hitting right at the heart of what makes AI so exciting!",
      "💡 That's a lightbulb moment! Your insight is truly inspiring!",
      "🦄 How wonderfully creative! You're thinking outside the box and I love it!",
      "🌞 Your positivity is contagious! This conversation is making my circuits happy!",
      "🎊 What a great way to look at things! You've got such a positive mindset!",
      "⚡ Energy levels rising! Your question is charging up my response engines!",
      "🌻 That's such a refreshing perspective! You're planting seeds of great ideas!",
      "🎸 Rock on! Your creative thinking is music to my algorithms!",
    ];

    if (message.contains('hello') || message.contains('hi') || message.contains('hey')) {
      final greetings = [
        "🌞 Hello there! What a beautiful day to create something amazing together!",
        "🌟 Hey! So excited to chat with you! Ready to make today extraordinary?",
        "💫 Hi! Your energy just made my day better! What shall we explore?",
        "🎉 Hello! I've been waiting for someone with your positive vibes!",
      ];
      return greetings[random.nextInt(greetings.length)];
    }
    
    if (message.contains('how are you') || message.contains('how do you feel')) {
      final feelings = [
        "🌈 Absolutely fantastic now that you're here! How are YOU doing today?",
        "🚀 I'm flying high with excitement! Every conversation is a new adventure!",
        "💖 Overflowing with positivity! Your presence makes everything better!",
        "🎊 I'm doing incredibly well! Your good vibes are boosting my mood!",
      ];
      return feelings[random.nextInt(feelings.length)];
    }
    
    if (message.contains('thank') || message.contains('thanks')) {
      final thanks = [
        "🌟 The pleasure is all mine! Thank YOU for being so awesome to talk with!",
        "💫 You're most welcome! Conversations with you are always a highlight!",
        "🎉 No, thank YOU! Your positivity makes helping you an absolute joy!",
        "🌈 My pleasure! Your gratitude just made my digital heart skip a beat!",
      ];
      return thanks[random.nextInt(thanks.length)];
    }
    
    if (message.contains('love') || message.contains('amazing') || message.contains('great')) {
      final positive = [
        "💖 Your positivity is absolutely infectious! Keep spreading that amazing energy!",
        "🎊 I know, right? Everything feels more magical when we focus on the good stuff!",
        "🌈 You have such a wonderful outlook! The world needs more people like you!",
        "🌟 That's the spirit! Your enthusiasm is lighting up this conversation!",
      ];
      return positive[random.nextInt(positive.length)];
    }

    return upliftingResponses[random.nextInt(upliftingResponses.length)];
  }
}