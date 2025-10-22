class CBTService {
  // 🌿 Step 1: Detect negative thinking or crisis patterns
  String identifyNegativePattern(String userThought) {
    final crisisKeywords = [
      "suicide",
      "kill myself",
      "die",
      "end it",
      "no reason to live",
      "worthless",
    ];

    final patterns = {
      "always": "overgeneralization",
      "never": "black-and-white thinking",
      "should": "self-criticism",
      "can't": "helplessness",
      "fail": "catastrophizing",
    };

    // 🚨 Check for crisis-related words first
    for (var word in crisisKeywords) {
      if (userThought.toLowerCase().contains(word)) {
        return "crisis";
      }
    }

    // Then check for negative thinking patterns
    for (var word in patterns.keys) {
      if (userThought.toLowerCase().contains(word)) {
        return patterns[word]!;
      }
    }

    return "balanced thinking";
  }

  // 🌿 Step 2: Reframe or respond to the identified pattern
  String reframeThought(String pattern) {
    switch (pattern) {
      case "overgeneralization":
        return "Try to look for specific exceptions instead of assuming it always happens.";
      case "black-and-white thinking":
        return "Remember, life often has shades of grey — not just success or failure.";
      case "self-criticism":
        return "Be kind to yourself. You’re learning and improving each day.";
      case "helplessness":
        return "Focus on what *you can* control, even if it’s small steps.";
      case "catastrophizing":
        return "Pause and ask yourself: Is it really as bad as it seems?";
      case "crisis":
        return "⚠️ It sounds like you might be going through something very difficult. "
            "You are *not alone*. Please reach out immediately to someone you trust "
            "or a professional counselor.\n\nIf you're in India, you can contact:\n"
            "📞 AASRA Helpline: 91-9820466726\n"
            "📞 Vandrevala Foundation Helpline: 1860 266 2345\n"
            "📞 iCall: +91 9152987821";
      default:
        return "That’s a healthy and balanced way of thinking.";
    }
  }

  // 🌿 Step 3: Generate full CBT or Crisis Supportive message
  String generateSupportiveMessage(String userThought) {
    String pattern = identifyNegativePattern(userThought);
    String reframe = reframeThought(pattern);

    if (pattern == "crisis") {
      return "🚨 Crisis Detected\n\n$reframe";
    }

    return "🧠 Detected thinking style: $pattern\n\n💬 Tip: $reframe";
  }
}
