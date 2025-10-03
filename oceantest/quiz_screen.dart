import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chat_bot/oceantest/result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool showWelcome = true;
  int questionIndex = 0;

  List<Map<String, dynamic>> questions = [];
  Map<String, int> traitScores = {
    "O": 0,
    "C": 0,
    "E": 0,
    "A": 0,
    "N": 0,
  };

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    final String response =
        await rootBundle.loadString('assets/images/questions.json');
    final List data = json.decode(response);
    setState(() {
      questions = data.map((q) => Map<String, dynamic>.from(q)).toList();
    });
  }

  void startQuiz() {
    setState(() {
      showWelcome = false;
    });
  }

  void answerQuestion(int score, String traitAbbr) {
    traitScores[traitAbbr] = (traitScores[traitAbbr] ?? 0) + score;

    setState(() {
      questionIndex++;
    });

    if (questionIndex >= questions.length) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(traitScores: traitScores),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'OCEAN Personality Quiz',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.black.withOpacity(0.4),
          elevation: 0,
        ),
        body: showWelcome
            ? _buildWelcomeScreen()
            : questions.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : _buildQuizScreen(),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "OCEAN Personality Test",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              "Discover your personality traits based on the OCEAN model (Openness, Conscientiousness, Extraversion, Agreeableness, Neuroticism)",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.teal.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            onPressed: startQuiz, // Fixed: Use startQuiz instead of recreating the screen
            child: const Text(
              "Start Quiz",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizScreen() {
    final currentQuestion = questions[questionIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress indicator
        Container(
          padding: const EdgeInsets.all(16),
          child: LinearProgressIndicator(
            value: (questionIndex + 1) / questions.length,
            backgroundColor: Colors.white.withOpacity(0.3),
            color: Colors.teal.shade300,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        // Question counter
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Question ${questionIndex + 1} of ${questions.length}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),
        // Question text
        Container(
          padding: const EdgeInsets.all(20),
          child: Text(
            currentQuestion['questionText'] ?? '',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        // Options
        ...(currentQuestion['options'] as List<dynamic>).map(
          (option) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.9),
                foregroundColor: Colors.black87,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () => answerQuestion(
                  option['score'] as int, currentQuestion['trait']),
              child: Text(
                option['text'] ?? '',
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}                    

