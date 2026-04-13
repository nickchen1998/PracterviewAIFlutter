import 'interview.dart';

class InterviewResult {
  final String id;
  final DateTime date;
  final String position;
  final String industry;
  final InterviewType type;
  final double overallScore;
  final Map<String, double> categoryScores;
  final List<QuestionFeedback> questionFeedbacks;
  final List<String> suggestions;

  const InterviewResult({
    required this.id,
    required this.date,
    required this.position,
    required this.industry,
    required this.type,
    required this.overallScore,
    required this.categoryScores,
    required this.questionFeedbacks,
    required this.suggestions,
  });
}

class QuestionFeedback {
  final String question;
  final String userAnswer;
  final String aiFeedback;
  final double score;

  const QuestionFeedback({
    required this.question,
    required this.userAnswer,
    required this.aiFeedback,
    required this.score,
  });
}
