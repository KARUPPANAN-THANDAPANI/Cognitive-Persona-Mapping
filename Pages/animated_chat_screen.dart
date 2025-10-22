import 'package:flutter/material.dart';
import 'package:chat_bot/Pages/chatbot.dart';
import 'package:http/http.dart' as http; // 🆕 ADD THIS IMPORT

class AnimatedChatScreen extends StatefulWidget {
  const AnimatedChatScreen({super.key});

  @override
  State<AnimatedChatScreen> createState() => _AnimatedChatScreenState();
}

class _AnimatedChatScreenState extends State<AnimatedChatScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  // 🆕 BACKEND STATUS
  bool _backendConnected = false;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    // 🆕 CHECK BACKEND CONNECTION
    _checkBackendConnection();

    // Start animation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  // 🆕 FIXED: CORRECT HTTP IMPORT AND SYNTAX
  void _checkBackendConnection() async {
    try {
      final response = await http.get(Uri.parse("http://localhost:5000/api/health")); // 🆕 FIX: Uri.parse not Uni.parse
      setState(() {
        _backendConnected = response.statusCode == 200;
      });
    } catch (e) {
      setState(() {
        _backendConnected = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 170, 192, 202),
      // 🆕 SHOW BACKEND STATUS IN APP BAR
      appBar: AppBar(
        title: const Text('Mental Health Chat'),
        backgroundColor: const Color.fromARGB(255, 76, 139, 175),
        actions: [
          Icon(
            _backendConnected ? Icons.cloud_done : Icons.cloud_off,
            color: _backendConnected ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          // 🆕 REMOVED backendAvailable parameter if Chatbot doesn't support it
          child: const Chatbot(), // 🆕 FIX: Remove unsupported parameter
        ),
      ),
    );
  }
}