import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/interview.dart';
import '../../providers/history_provider.dart';
import '../../providers/user_provider.dart';
import '../../utils/breakpoints.dart';
import '../../utils/strings.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final results = ref.watch(historyProvider);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final avgScore = results.isEmpty
        ? 0.0
        : results.map((r) => r.overallScore).reduce((a, b) => a + b) /
            results.length;

    final mainContent = [
      // Welcome + CTA
      Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${S.welcomeBack}，${user.name}',
                  style:
                      textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '準備好今天的面試練習了嗎？',
                  style: textTheme.bodyMedium
                      ?.copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: () => context.go('/interview/setup'),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text(S.startInterview),
          ),
        ],
      ),
      const SizedBox(height: 28),

      // Recent interviews
      Text(
        S.recentInterviews,
        style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
    ];

    // Sidebar content
    Widget sidebar = Column(
      children: [
        _StatCard(
          icon: Icons.quiz_outlined,
          label: S.totalInterviews,
          value: '${results.length}',
          color: colors.primary,
        ),
        const SizedBox(height: 12),
        _StatCard(
          icon: Icons.trending_up,
          label: S.averageScore,
          value: '${avgScore.round()}',
          color: colors.tertiary,
        ),
        const SizedBox(height: 12),
        _StatCard(
          icon: Icons.description_outlined,
          label: S.resumeCompleteness,
          value: '${(user.resumeCompleteness * 100).round()}%',
          color: colors.secondary,
        ),
        const SizedBox(height: 16),
        // Quick actions
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('快速操作',
                    style: textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                _QuickAction(
                  icon: Icons.upload_file,
                  label: '上傳履歷',
                  onTap: () => context.go('/profile'),
                ),
                _QuickAction(
                  icon: Icons.person_outline,
                  label: '編輯個人資料',
                  onTap: () => context.go('/profile'),
                ),
                _QuickAction(
                  icon: Icons.history,
                  label: '查看歷史紀錄',
                  onTap: () => context.go('/history'),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    // Interview list (grid on desktop, horizontal scroll on mobile)
    Widget interviewList;
    if (results.isEmpty) {
      interviewList = Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                Icon(Icons.record_voice_over_outlined,
                    size: 48, color: colors.onSurfaceVariant),
                const SizedBox(height: 12),
                Text(S.noHistory,
                    style: textTheme.bodyLarge
                        ?.copyWith(color: colors.onSurfaceVariant)),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () => context.go('/interview/setup'),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('開始第一次面試'),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (isExpanded(context)) {
      // Grid layout for desktop
      interviewList = Wrap(
        spacing: 12,
        runSpacing: 12,
        children: results
            .map((r) => SizedBox(
                  width: 280,
                  child: _InterviewCard(result: r),
                ))
            .toList(),
      );
    } else {
      // Horizontal scroll for compact/medium
      interviewList = SizedBox(
        height: 140,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: results.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) =>
              SizedBox(width: 240, child: _InterviewCard(result: results[i])),
        ),
      );
    }

    if (isExpanded(context)) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...mainContent,
                      interviewList,
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              SizedBox(width: 300, child: SingleChildScrollView(child: sidebar)),
            ],
          ),
        ),
      );
    }

    // Compact / Medium: single column
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...mainContent,
                interviewList,
                const SizedBox(height: 24),
                // Stats row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.quiz_outlined,
                        label: S.totalInterviews,
                        value: '${results.length}',
                        color: colors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.trending_up,
                        label: S.averageScore,
                        value: '${avgScore.round()}',
                        color: colors.tertiary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.description_outlined,
                        label: S.resumeCompleteness,
                        value: '${(user.resumeCompleteness * 100).round()}%',
                        color: colors.secondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InterviewCard extends StatelessWidget {
  final dynamic result;

  const _InterviewCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.push('/history/${result.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_typeIcon(result.type), size: 18, color: colors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      result.position,
                      style: textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(result.industry,
                  style: textTheme.bodySmall
                      ?.copyWith(color: colors.onSurfaceVariant)),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${result.overallScore.round()} ${S.score}',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                  Text(
                    '${result.date.month}/${result.date.day}',
                    style: textTheme.bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
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
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.onSurfaceVariant),
            const SizedBox(width: 12),
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            Icon(Icons.chevron_right,
                size: 18, color: colors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
