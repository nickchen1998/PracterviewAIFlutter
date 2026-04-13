import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_data.dart';
import '../models/interview.dart';

final interviewSetupProvider =
    NotifierProvider<InterviewSetupNotifier, InterviewSetup>(
        InterviewSetupNotifier.new);

class InterviewSetupNotifier extends Notifier<InterviewSetup> {
  @override
  InterviewSetup build() => const InterviewSetup(
        type: InterviewType.technical,
        position: '前端工程師',
        industry: '軟體科技',
        difficulty: InterviewDifficulty.intermediate,
        mode: InterviewMode.text,
      );

  void setType(InterviewType type) {
    final s = state;
    state = InterviewSetup(
      type: type,
      position: s.position,
      industry: s.industry,
      difficulty: s.difficulty,
      mode: s.mode,
    );
  }

  void setPosition(String position) {
    final s = state;
    state = InterviewSetup(
      type: s.type,
      position: position,
      industry: s.industry,
      difficulty: s.difficulty,
      mode: s.mode,
    );
  }

  void setIndustry(String industry) {
    final s = state;
    state = InterviewSetup(
      type: s.type,
      position: s.position,
      industry: industry,
      difficulty: s.difficulty,
      mode: s.mode,
    );
  }

  void setDifficulty(InterviewDifficulty difficulty) {
    final s = state;
    state = InterviewSetup(
      type: s.type,
      position: s.position,
      industry: s.industry,
      difficulty: difficulty,
      mode: s.mode,
    );
  }

  void setMode(InterviewMode mode) {
    final s = state;
    state = InterviewSetup(
      type: s.type,
      position: s.position,
      industry: s.industry,
      difficulty: s.difficulty,
      mode: mode,
    );
  }
}

final messagesProvider = Provider<List<InterviewMessage>>((ref) {
  return MockData.sampleMessages;
});
