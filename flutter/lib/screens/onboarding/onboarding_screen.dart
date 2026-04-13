import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../utils/strings.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(S.onboardingTitle),
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(authProvider.notifier).completeOnboarding(),
            child: const Text(S.skip),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  S.onboardingSubtitle,
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colors.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ),
              // Step indicators
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: List.generate(4, (i) {
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: i <= _currentStep
                              ? colors.primary
                              : colors.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _stepTitle,
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildStepContent(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              setState(() => _currentStep--),
                          child: const Text(S.previous),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (_currentStep < 3) {
                            setState(() => _currentStep++);
                          } else {
                            ref
                                .read(authProvider.notifier)
                                .completeOnboarding();
                          }
                        },
                        child: Text(
                            _currentStep < 3 ? S.next : S.complete),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _stepTitle {
    switch (_currentStep) {
      case 0:
        return 'Step 1: ${S.stepBasicInfo}';
      case 1:
        return 'Step 2: ${S.stepEducation}';
      case 2:
        return 'Step 3: ${S.stepExperience}';
      case 3:
        return 'Step 4: ${S.stepResume}';
      default:
        return '';
    }
  }

  Widget _buildStepContent(BuildContext context) {
    switch (_currentStep) {
      case 0:
        return _buildBasicInfoStep();
      case 1:
        return _buildEducationStep();
      case 2:
        return _buildExperienceStep();
      case 3:
        return _buildResumeStep(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBasicInfoStep() {
    return const Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: S.name,
            prefixIcon: Icon(Icons.person_outlined),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: S.email,
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: S.phone,
            prefixIcon: Icon(Icons.phone_outlined),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationStep() {
    return const Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: S.school,
            prefixIcon: Icon(Icons.school_outlined),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: S.department,
            prefixIcon: Icon(Icons.menu_book_outlined),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: S.graduationYear,
            prefixIcon: Icon(Icons.calendar_today_outlined),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildExperienceStep() {
    return const Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: S.jobTitle,
            prefixIcon: Icon(Icons.badge_outlined),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: S.company,
            prefixIcon: Icon(Icons.business_outlined),
          ),
        ),
        SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: S.yearsOfExperience,
            prefixIcon: Icon(Icons.work_history_outlined),
          ),
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildResumeStep(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            border: Border.all(color: colors.outlineVariant, width: 2),
            borderRadius: BorderRadius.circular(16),
            color: colors.surfaceContainerLowest,
          ),
          child: Column(
            children: [
              Icon(Icons.cloud_upload_outlined,
                  size: 48, color: colors.primary),
              const SizedBox(height: 12),
              Text(
                S.uploadResume,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                S.uploadResumeHint,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.attach_file),
                label: const Text('選擇檔案'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: colors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'AI 分析預覽',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '上傳履歷後，AI 將自動分析你的履歷內容，提供優勢分析和改善建議。',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
