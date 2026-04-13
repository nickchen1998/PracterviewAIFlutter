import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_data.dart';
import '../models/interview_result.dart';

final historyProvider = Provider<List<InterviewResult>>((ref) {
  return MockData.interviewResults;
});

final selectedResultProvider = Provider.family<InterviewResult?, String>((ref, id) {
  final results = ref.watch(historyProvider);
  try {
    return results.firstWhere((r) => r.id == id);
  } catch (_) {
    return null;
  }
});
