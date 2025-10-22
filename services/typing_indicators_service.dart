import 'package:flutter/material.dart';

class TypingIndicatorsService {
  static Widget getIndicator({String? mood}) {
    if (mood != null && mood.isNotEmpty) {
      return MoodBasedTypingIndicator(mood: mood);
    } else {
      return PulsingDotIndicator();
    }
  }

  static Color getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy': return Color(0xFF4CAF50);
      case 'sad': return Color(0xFF2196F3);
      case 'angry': return Color(0xFFF44336);
      case 'stressed': return Color(0xFFFF9800);
      case 'anxious': return Color(0xFF9C27B0);
      case 'neutral': return Color(0xFF9E9E9E);
      default: return Color(0xFF2196F3);
    }
  }
}

class PulsingDotIndicator extends StatefulWidget {
  final Color color;
  
  const PulsingDotIndicator({this.color = const Color(0xFF2196F3)});
  
  @override
  _PulsingDotIndicatorState createState() => _PulsingDotIndicatorState();
}

class _PulsingDotIndicatorState extends State<PulsingDotIndicator> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [0, 1, 2].map((index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delay = index * 0.2;
              final value = (_controller.value + delay) % 1.0;
              return Opacity(
                opacity: 0.3 + (value * 0.7),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: widget.color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}

class MoodBasedTypingIndicator extends StatefulWidget {
  final String mood;
  
  const MoodBasedTypingIndicator({required this.mood});
  
  @override
  _MoodBasedTypingIndicatorState createState() => _MoodBasedTypingIndicatorState();
}

class _MoodBasedTypingIndicatorState extends State<MoodBasedTypingIndicator> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = TypingIndicatorsService.getMoodColor(widget.mood);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [0, 1, 2].map((index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delay = index * 0.2;
              final value = (_controller.value + delay) % 1.0;
              return Opacity(
                opacity: 0.3 + (value * 0.7),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}