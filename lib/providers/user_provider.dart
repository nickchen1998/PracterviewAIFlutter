import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/mock_data.dart';
import '../models/user.dart';
import '../models/resume.dart';

final userProvider = Provider<AppUser>((ref) {
  return MockData.currentUser;
});

final resumeProvider = Provider<Resume>((ref) {
  return MockData.currentResume;
});
