// lib/personality.dart
Map<String, dynamic> generateProfile(Map<String, double> scores) {
  String _traitSummary(String trait, double val) {
    if (trait == "Openness") {
      if (val >= 66) return "open to new ideas and creative";
      if (val <= 33) return "prefers familiar routines";
      return "moderately curious";
    }
    if (trait == "Conscientiousness") {
      if (val >= 66) return "organized and reliable";
      if (val <= 33) return "flexible and spontaneous";
      return "reasonably organized";
    }
    if (trait == "Extraversion") {
      if (val >= 66) return "social and energetic";
      if (val <= 33) return "reserved and reflective";
      return "balanced in social settings";
    }
    if (trait == "Agreeableness") {
      if (val >= 66) return "kind and cooperative";
      if (val <= 33) return "direct and assertive";
      return "friendly and balanced";
    }
    if (trait == "Neuroticism") {
      if (val >= 66) return "emotionally sensitive";
      if (val <= 33) return "emotionally stable";
      return "sometimes stressed";
    }
    return "";
  }

  final traits = [
    _traitSummary("Openness", scores["Openness"]!),
    _traitSummary("Conscientiousness", scores["Conscientiousness"]!),
    _traitSummary("Extraversion", scores["Extraversion"]!),
    _traitSummary("Agreeableness", scores["Agreeableness"]!),
    _traitSummary("Neuroticism", scores["Neuroticism"]!),
  ];

  final summary = "You are ${traits.take(3).join(", ")}.";
  String label;

  if (scores["Openness"]! >= 66 && scores["Extraversion"]! < 50) {
    label = "Creative Introvert";
  } else if (scores["Openness"]! >= 66 && scores["Extraversion"]! >= 66) {
    label = "Innovative Socializer";
  } else if (scores["Agreeableness"]! >= 70) {
    label = "Compassionate Helper";
  } else if (scores["Conscientiousness"]! >= 70) {
    label = "Dependable Achiever";
  } else {
    label = "Balanced Explorer";
  }

  return {
    ...scores,
    "Label": label,
    "Summary": summary,
  };
}

