import 'dart:convert';
import 'package:chat_bot/apikey.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

final ChatUser currentUser =
    ChatUser(id: "1", firstName: "Customers", lastName: "MindOwners");

final ChatUser gptChatUser =
    ChatUser(id: "2", firstName: "InnoQuad", lastName: "Mindbusters");

class _ChatbotState extends State<Chatbot> {
  List<ChatMessage> chat1 = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 170, 192, 202),
        title: const Text(
          "InnoQuad",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
            fontFamily: 'DancingScript',
            color: Color.fromARGB(255, 54, 106, 136),
          ),
        ),
      ),
      body: DashChat(
        currentUser: currentUser,
        messages: chat1,
        onSend: (ChatMessage message) {
          getChatResponse(message);
        },
        messageOptions: const MessageOptions(
          showTime: true,
          currentUserContainerColor: Colors.blueAccent,
          currentUserTextColor: Color.fromARGB(255, 213, 251, 232),
          containerColor: Color.fromARGB(255, 39, 42, 57),
          textColor: Color.fromARGB(255, 14, 190, 210),
        ),
      ),
    );
  }

  Future<void> getChatResponse(ChatMessage userMessage) async {
    setState(() {
      chat1.insert(0, userMessage);
    });

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
}


