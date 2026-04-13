import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import '../../providers/history_provider.dart';
import '../../utils/strings.dart';
import '../../models/interview.dart';

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

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: colors.primaryContainer,
                      child: Text(
                        user.name.isNotEmpty ? user.name[0] : '?',
                        style: textTheme.titleLarge
                            ?.copyWith(color: colors.onPrimaryContainer),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${S.welcomeBack}，',
                          style: textTheme.bodyMedium
                              ?.copyWith(color: colors.onSurfaceVariant),
                        ),
                        Text(
                          user.name,
                          style: textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: () => context.go('/interview/setup'),
                    icon: const Icon(Icons.play_arrow_rounded, size: 28),
                    label: Text(
                      S.startInterview,
                      style: textTheme.titleMedium?.copyWith(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Stats cards
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
                const SizedBox(height: 28),

                // Recent interviews
                Text(
                  S.recentInterviews,
                  style:
                      textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (results.isEmpty)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(S.noHistory,
                            style: textTheme.bodyMedium
                                ?.copyWith(color: colors.onSurfaceVariant)),
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, i) {
                        final r = results[i];
                        return SizedBox(
                          width: 200,
                          child: Card(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () => context.push('/history/${r.id}'),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          _typeIcon(r.type),
                                          size: 18,
                                          color: colors.primary,
                                        ),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            r.position,
                                            style: textTheme.titleSmall
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      r.industry,
                                      style: textTheme.bodySmall?.copyWith(
                                          color: colors.onSurfaceVariant),
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${r.overallScore.round()} ${S.score}',
                                          style:
                                              textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: colors.primary,
                                          ),
                                        ),
                                        Text(
                                          '${r.date.month}/${r.date.day}',
                                          style: textTheme.bodySmall?.copyWith(
                                              color: colors.onSurfaceVariant),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
