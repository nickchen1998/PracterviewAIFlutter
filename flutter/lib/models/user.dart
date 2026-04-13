class AppUser {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final Education? education;
  final WorkExperience? experience;
  final List<String> skills;
  final bool hasCompletedOnboarding;
  final double resumeCompleteness;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.education,
    this.experience,
    this.skills = const [],
    this.hasCompletedOnboarding = false,
    this.resumeCompleteness = 0,
  });
}

class Education {
  final String school;
  final String department;
  final int graduationYear;

  const Education({
    required this.school,
    required this.department,
    required this.graduationYear,
  });
}

class WorkExperience {
  final String jobTitle;
  final String company;
  final int yearsOfExperience;

  const WorkExperience({
    required this.jobTitle,
    required this.company,
    required this.yearsOfExperience,
  });
}
