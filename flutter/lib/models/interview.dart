enum InterviewType { technical, behavioral, comprehensive }

enum InterviewDifficulty { beginner, intermediate, advanced }

enum InterviewMode { text, voice }

class InterviewSetup {
  final InterviewType type;
  final String position;
  final String industry;
  final InterviewDifficulty difficulty;
  final InterviewMode mode;
  final int estimatedMinutes;

  const InterviewSetup({
    required this.type,
    required this.position,
    required this.industry,
    required this.difficulty,
    required this.mode,
    this.estimatedMinutes = 30,
  });
}

class InterviewMessage {
  final String id;
  final String content;
  final bool isFromAI;
  final DateTime timestamp;

  const InterviewMessage({
    required this.id,
    required this.content,
    required this.isFromAI,
    required this.timestamp,
  });
}
