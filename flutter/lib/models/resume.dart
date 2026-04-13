class Resume {
  final String id;
  final String fileName;
  final DateTime uploadedAt;
  final ResumeAnalysis? analysis;

  const Resume({
    required this.id,
    required this.fileName,
    required this.uploadedAt,
    this.analysis,
  });
}

class ResumeAnalysis {
  final List<String> strengths;
  final List<String> improvements;
  final double overallScore;

  const ResumeAnalysis({
    required this.strengths,
    required this.improvements,
    required this.overallScore,
  });
}
