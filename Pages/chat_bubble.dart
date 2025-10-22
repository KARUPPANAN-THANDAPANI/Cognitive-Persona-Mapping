import 'package:flutter/material.dart';
import '../sentiment/sentiment_detector.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final String mood;
  final DateTime timestamp;

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isUser,
    required this.mood,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int moodColor = SentimentDetector.getColorForMood(mood);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) _buildBotAvatar(moodColor),
          if (!isUser) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? Color(moodColor) : Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(isUser ? 20 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 20),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(timestamp),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBotAvatar(int moodColor) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Color(moodColor),
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.psychology, color: Colors.white, size: 16),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}