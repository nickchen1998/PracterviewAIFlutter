import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../../models/interview.dart';
import '../../providers/interview_provider.dart';
import '../../utils/breakpoints.dart';
import '../../utils/strings.dart';

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setup = ref.watch(interviewSetupProvider);
    final notifier = ref.read(interviewSetupProvider.notifier);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Widget form = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(S.interviewSetup,
            style:
                textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),

        // Interview Type
        Text(S.interviewType,
            style:
                textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: InterviewType.values.map((t) {
            final selected = setup.type == t;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                    right: t != InterviewType.values.last ? 8.0 : 0),
                child: _TypeCard(
                  icon: _typeIcon(t),
                  label: _typeLabel(t),
                  selected: selected,
                  onTap: () => notifier.setType(t),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),

        // Position
        Text(S.targetPosition,
            style:
                textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: setup.position,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.work_outlined),
          ),
          items: MockData.positions
              .map((p) => DropdownMenuItem(value: p, child: Text(p)))
              .toList(),
          onChanged: (v) {
            if (v != null) notifier.setPosition(v);
          },
        ),
        const SizedBox(height: 20),

        // Industry
        Text(S.targetIndustry,
            style:
                textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: setup.industry,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.business_outlined),
          ),
          items: MockData.industries
              .map((i) => DropdownMenuItem(value: i, child: Text(i)))
              .toList(),
          onChanged: (v) {
            if (v != null) notifier.setIndustry(v);
          },
        ),
        const SizedBox(height: 20),

        // Difficulty
        Text(S.difficulty,
            style:
                textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SegmentedButton<InterviewDifficulty>(
          segments: const [
            ButtonSegment(
              value: InterviewDifficulty.beginner,
              label: Text(S.difficultyBeginner),
            ),
            ButtonSegment(
              value: InterviewDifficulty.intermediate,
              label: Text(S.difficultyIntermediate),
            ),
            ButtonSegment(
              value: InterviewDifficulty.advanced,
              label: Text(S.difficultyAdvanced),
            ),
          ],
          selected: {setup.difficulty},
          onSelectionChanged: (s) => notifier.setDifficulty(s.first),
        ),
        const SizedBox(height: 20),

        // Mode
        Text(S.interviewMode,
            style:
                textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        SegmentedButton<InterviewMode>(
          segments: const [
            ButtonSegment(
              value: InterviewMode.text,
              icon: Icon(Icons.chat_outlined),
              label: Text(S.textMode),
            ),
            ButtonSegment(
              value: InterviewMode.voice,
              icon: Icon(Icons.mic_outlined),
              label: Text(S.voiceMode),
            ),
          ],
          selected: {setup.mode},
          onSelectionChanged: (s) => notifier.setMode(s.first),
        ),
      ],
    );

    // Summary card
    Widget summary = Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('面試摘要',
                style:
                    textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _SummaryRow(label: S.interviewType, value: _typeLabel(setup.type)),
            _SummaryRow(label: S.targetPosition, value: setup.position),
            _SummaryRow(label: S.targetIndustry, value: setup.industry),
            _SummaryRow(
                label: S.difficulty, value: _difficultyLabel(setup.difficulty)),
            _SummaryRow(
                label: S.interviewMode,
                value: setup.mode == InterviewMode.text
                    ? S.textMode
                    : S.voiceMode),
            const Divider(height: 24),
            Row(
              children: [
                Icon(Icons.timer_outlined, color: colors.primary, size: 20),
                const SizedBox(width: 8),
                Text('${S.estimatedTime}：', style: textTheme.bodyMedium),
                Text(
                  '${setup.estimatedMinutes} ${S.minutes}',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: () => context.push('/interview/session'),
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text(S.beginInterview),
              ),
            ),
          ],
        ),
      ),
    );

    if (isExpanded(context)) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(child: form),
              ),
              const SizedBox(width: 24),
              SizedBox(width: 320, child: summary),
            ],
          ),
        ),
      );
    }

    // Compact / Medium
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                form,
                const SizedBox(height: 20),
                // Inline estimated time + button
                Card(
                  color: colors.primaryContainer.withValues(alpha: 0.3),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.timer_outlined, color: colors.primary),
                        const SizedBox(width: 12),
                        Text('${S.estimatedTime}：',
                            style: textTheme.bodyMedium),
                        Text(
                          '${setup.estimatedMinutes} ${S.minutes}',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: () => context.push('/interview/session'),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: Text(
                      S.beginInterview,
                      style: textTheme.titleMedium?.copyWith(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(InterviewType type) {
    switch (type) {
      case InterviewType.technical:
        return Icons.code;
      case InterviewType.behavioral:
        return Icons.psychology;
      case InterviewType.comprehensive:
        return Icons.assessment;
    }
  }

  String _typeLabel(InterviewType type) {
    switch (type) {
      case InterviewType.technical:
        return S.technicalInterview;
      case InterviewType.behavioral:
        return S.behavioralInterview;
      case InterviewType.comprehensive:
        return S.comprehensiveInterview;
    }
  }

  String _difficultyLabel(InterviewDifficulty d) {
    switch (d) {
      case InterviewDifficulty.beginner:
        return S.difficultyBeginner;
      case InterviewDifficulty.intermediate:
        return S.difficultyIntermediate;
      case InterviewDifficulty.advanced:
        return S.difficultyAdvanced;
    }
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      color: selected ? colors.primaryContainer : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Column(
            children: [
              Icon(icon,
                  color: selected
                      ? colors.onPrimaryContainer
                      : colors.onSurfaceVariant),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: selected
                          ? colors.onPrimaryContainer
                          : colors.onSurfaceVariant,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant)),
          Text(value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
