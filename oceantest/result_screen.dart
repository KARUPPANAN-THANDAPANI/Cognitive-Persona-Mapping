// lib/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:chat_bot/oceantest/personality.dart';
import 'package:chat_bot/Pages/Chatbot.dart';

class ResultScreen extends StatelessWidget {
  final Map<String, int> traitScores; // keys expected: O, C, E, A, N
  const ResultScreen({super.key, required this.traitScores});

  static const traitNames = {
    "O": "Openness to Experience",
    "C": "Conscientiousness",
    "E": "Extraversion",
    "A": "Agreeableness",
    "N": "Neuroticism (Emotional Stability)"
  };

  static const traitAdjectives = {
    "O": {
      "high": ["curious", "imaginative", "open-minded"],
      "moderate": ["balanced in imagination and practicality"],
      "low": ["practical", "conventional"]
    },
    "C": {
      "high": ["organized", "reliable", "goal-oriented"],
      "moderate": ["reasonably organized", "sometimes disciplined"],
      "low": ["spontaneous", "flexible"]
    },
    "E": {
      "high": ["outgoing", "energetic", "sociable"],
      "moderate": ["balanced between introversion and extraversion"],
      "low": ["reserved", "quiet"]
    },
    "A": {
      "high": ["cooperative", "compassionate", "trusting"],
      "moderate": ["balanced in empathy and pragmatism"],
      "low": ["competitive", "skeptical"]
    },
    "N": {
      "high": ["emotionally reactive", "sensitive to stress"],
      "moderate": ["occasionally anxious"],
      "low": ["resilient", "calm under pressure"]
    }
  };

  String _bucketLabel(double score) {
    if (score >= 66) return "high";
    if (score <= 33) return "low";
    return "moderate";
  }

  /// Normalize raw integer scores heuristically to 0..100.
  Map<String, double> _normalizeToPercent(Map<String, int> rawScores) {
    if (rawScores.isEmpty) {
      return {"O": 0.0, "C": 0.0, "E": 0.0, "A": 0.0, "N": 0.0};
    }

    final values = rawScores.values.map((v) => v.toDouble()).toList();
    final maxObserved = values.reduce((a, b) => a > b ? a : b);

    double baseMax;
    if (maxObserved <= 5.0) {
      baseMax = 5.0; // likely single-item scale 1-5
    } else if (maxObserved <= 25.0) {
      baseMax = 25.0; // likely 5 questions * 5
    } else if (maxObserved <= 100.0) {
      baseMax = 100.0; // already percent-like
    } else {
      baseMax = maxObserved; // fallback
    }

    final Map<String, double> normalized = {};
    rawScores.forEach((k, v) {
      final pct = ((v.toDouble() / baseMax) * 100.0).clamp(0.0, 100.0);
      normalized[k] = pct;
    });
    return normalized;
  }

  String _generateProfileText(Map<String, double> percentScores, List<String> shownTraits) {
    final buffer = StringBuffer();

    buffer.writeln("🌟 Personality Profile (OCEAN)");
    buffer.writeln("--------------------------------\n");

    final dominant = <String>[];
    for (final t in shownTraits) {
      final label = _bucketLabel(percentScores[t]!);
      if (label == "high") dominant.add(traitNames[t] ?? t);
    }

    if (dominant.isNotEmpty) {
      buffer.writeln("Summary: Strong tendencies in ${dominant.join(", ")}.\n");
    } else {
      buffer.writeln("Summary: Balanced profile across traits.\n");
    }

    for (final t in shownTraits) {
      final pct = percentScores[t]!;
      final label = _bucketLabel(pct);
      final adj = traitAdjectives[t]?[label]?.join(", ") ?? "";
      buffer.writeln(
          "${traitNames[t]} ($t): ${pct.round()}/100 — ${label.toUpperCase()}.\n"
          "People with this level tend to be $adj.\n");
      if (t == "N" && label == "low") {
        buffer.writeln("This suggests good emotional stability.\n");
      }
    }

    buffer.writeln("💡 Tips: Build on your strengths. "
        "If Neuroticism is high, practice stress-management; "
        "if Conscientiousness is low, try time-blocking for better structure.\n");

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final percentScores = _normalizeToPercent(traitScores);

    // All possible traits in order (we will display labels for all)
    final allTraits = ["O", "C", "E", "A", "N"];

    // Check whether *any* trait has non-zero percent
    final anyNonZero = allTraits.any((t) => (percentScores[t] ?? 0.0) > 0.0);

    // If nothing to show, display friendly message
    if (!anyNonZero) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Your OCEAN Result", style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.teal,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFe0f7fa), Color(0xFF80deea)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Card(
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text("No responses recorded",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 12),
                  const Text("It looks like no trait has a recorded score yet. Please complete the quiz.",
                      style: TextStyle(color: Colors.black)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, "/"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    child: const Text("Restart Quiz"),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
    }

    // Build values for all traits (zero ones will be 0.0)
    final values = allTraits.map((t) => percentScores[t] ?? 0.0).toList();

    // Generate personality profile using the external function
    final personalityInput = {
      "Openness": percentScores["O"]!,
      "Conscientiousness": percentScores["C"]!,
      "Extraversion": percentScores["E"]!,
      "Agreeableness": percentScores["A"]!,
      "Neuroticism": percentScores["N"]!,
    };

    final profile = generateProfile(personalityInput);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your OCEAN Result", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.teal,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFe0f7fa), Color(0xFF80deea)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Chart (left) — chart slightly lowered using top spacer; shows all 5 labels
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      // tweak this SizedBox height to move chart further down/up
                      const SizedBox(height: 28),
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            maxY: 100,
                            alignment: BarChartAlignment.spaceAround,
                            barGroups: List.generate(allTraits.length, (i) {
                              return BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: values[i],
                                    color: Colors.teal.shade700,
                                    width: 18,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ],
                                showingTooltipIndicators: [0],
                              );
                            }),
                            titlesData: FlTitlesData(
                              show: true,
                              bottomTitles: AxisTitles(
                                axisNameWidget: const SizedBox.shrink(),
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 56,
                                  getTitlesWidget: (value, meta) {
                                    final i = value.toInt();
                                    if (i < 0 || i >= allTraits.length) return const SizedBox();
                                    final abbr = allTraits[i];
                                    final scoreLabel = values[i].round();
                                    return Column(mainAxisSize: MainAxisSize.min, children: [
                                      Text(abbr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                                      const SizedBox(height: 4),
                                      Text('$scoreLabel', style: const TextStyle(fontSize: 12, color: Colors.black)),
                                    ]);
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(show: true),
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: Colors.white,
                                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                  final value = values[group.x.toInt()].round();
                                  return BarTooltipItem('$value', const TextStyle(color: Colors.black, fontWeight: FontWeight.bold));
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Profile text and restart (right)
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // New personality label and summary
                              Text(
                                "🌟 Personality Label: ${profile['Label']}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "${profile['Summary']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.4,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Detailed Analysis:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Original detailed profile text
                              Text(
                                _generateProfileText(percentScores, allTraits.where((t) => values[allTraits.indexOf(t)] > 0.0).toList()),
                                style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pushReplacementNamed(context, "/"),
                    child: const Text("🔄 Restart Quiz", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Chatbot()),
                      );
                    },
                    child: const Text("💬 Go to Chatbot", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}