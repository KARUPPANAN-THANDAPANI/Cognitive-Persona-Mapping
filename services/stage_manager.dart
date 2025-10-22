// lib/stage_manager.dart
enum Stage {
  initial,   // default starting point
  stable,    // system or person behaving normally
  atRisk,    // showing mild instability
  critical,  // severe instability
  escalated  // emergency or high alert
}

class StageConfig {
  final double stableThreshold;
  final double atRiskThreshold;
  final double criticalThreshold;

  const StageConfig({
    this.stableThreshold = 0.75,
    this.atRiskThreshold = 0.60,
    this.criticalThreshold = 0.40,
  });
}

class Metrics {
  final double moodScore;    // 0–1
  final double engagement;   // 0–1
  final double consistency;  // 0–1
  final double errorRate;    // 0–1 (lower = better)

  const Metrics({
    required this.moodScore,
    required this.engagement,
    required this.consistency,
    required this.errorRate,
  });
}
