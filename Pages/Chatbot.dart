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

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});
  final String title = "InnoQuad";

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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 170, 192, 202),
        title: Row(children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/bot2_avatar.png'),
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
                icon: Icon(Icons.psychology),
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
      body: DashChat(
        key: ValueKey(chat1.length),
        currentUser: currentUser,
        messages: chat1,
        onSend: (ChatMessage message) {
          if (message.text.trim().isNotEmpty) {
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
      // ADDED FLOATING ACTION BUTTON FOR MOOD SELECTION
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

  Future<void> getChatResponse(ChatMessage userMessage) async {
    setState(() {
      chat1.insert(0, userMessage);
    });
    
    // SENTIMENT ANALYSIS
    final sentiment = _sentimentService.combinedSentimentAnalysis(userMessage.text);
    final mood = _sentimentService.detectMood(userMessage.text);
    final allTips = await MoodTipsHelper.getTipsForUserMessage(userMessage.text);
    final randomTip = await MoodTipsHelper.getRandomTipForMood(mood);

    print('🎯 Sentiment: $sentiment');
    print('🎯 Mood: $mood');
    print('📝 Available tips: ${allTips.length}');
    print('🎲 Random tip: $randomTip');

    // ONLY SHOW STRESS RELIEF FOR NEGATIVE/STRESSED MOODS
    final negativeMoods = ['stressed', 'sad', 'angry', 'anxious'];
    final isNegativeMood = negativeMoods.contains(mood.toLowerCase());
    
    if (isNegativeMood && !_hasShownStressRelief && allTips.isNotEmpty) {
      print('⚠️ Negative mood detected: $mood - Showing stress relief');
      
      // Send mood-appropriate message first
      _addBotMessage("I sense you're feeling $mood. Here's something that might help: $randomTip");

      // Then show stress relief after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StressReliefScreen()),
          ).then((_) {
            _hasShownStressRelief = false; // Reset flag when returning
          });
        }
      });
      
      _hasShownStressRelief = true;
      return;
    }

    // For positive/neutral moods or if already shown stress relief, continue normally
    if (allTips.isNotEmpty && isNegativeMood) {
      _addBotMessage("I sense you're feeling $mood. Here's something that might help: $randomTip");
    }
    
    // Continue with normal chat response
    if (useOnlineApi) {
      await _getOnlineResponse(userMessage);
    } else {
      await _getOfflineResponse(userMessage);
    }
  }

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
  }

  String _getElevatedResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    final random = Random();
    
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