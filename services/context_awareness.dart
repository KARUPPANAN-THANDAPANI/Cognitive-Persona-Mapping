class ContextAwareness {
  double _scoreForKeywords(String text, List<String> kws) {
    final msg = text.toLowerCase();
    int count = 0;
    for (final k in kws) if (msg.contains(k)) count++;
    return kws.isEmpty ? 0.0 : (count / kws.length);
  }

  Map<String, dynamic> detectMoodWithConfidence(String text) {
    final msg = text.toLowerCase();
    bool hasNegationBeforePositive = false;
    final negations = ['not ', "don't ", "didn't ", "no "];
    final positiveWords = ['good','happy','great','well','fine','ok','okay'];
    for (final p in positiveWords) {
      for (final n in negations) {
        if (msg.contains('$n$p')) hasNegationBeforePositive = true;
      }
    }

    final posKw = ['good','happy','great','well','fine','ok','okay'];
    final negKw = ['sad','depressed','stressed','anxious','bad','tired','hopeless','lonely','suicid','kill myself'];

    final posScore = _scoreForKeywords(msg, posKw);
    final negScore = _scoreForKeywords(msg, negKw);

    if (hasNegationBeforePositive) {
      return {'mood': 'negative', 'conf': (posScore + 0.2).clamp(0.0, 1.0)};
    }

    if (negScore > posScore && negScore > 0) return {'mood': 'negative', 'conf': negScore};
    if (posScore > negScore && posScore > 0) return {'mood': 'positive', 'conf': posScore};
    return {'mood': 'neutral', 'conf': 0.0};
  }

  String detectIntent(String text) {
    final msg = text.toLowerCase();
    if (msg.contains("help") || msg.contains("support") || msg.contains("need") || msg.contains("can't")) return "help_request";
    if (msg.contains("why") || msg.contains("how") || msg.contains("explain")) return "information";
    if (msg.contains("thank") || msg.contains("thanks")) return "gratitude";
    return "casual";
  }
}

