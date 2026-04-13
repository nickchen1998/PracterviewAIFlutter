import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/interview.dart';
import '../../providers/history_provider.dart';
import '../../providers/user_provider.dart';
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
    final lastScore =
        results.isEmpty ? 0.0 : results.first.overallScore;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${S.welcomeBack}，${user.name}',
                      style: textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
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
          const SizedBox(height: 24),

          // Stats cards
          LayoutBuilder(builder: (context, constraints) {
            final cardWidth = constraints.maxWidth > 700
                ? (constraints.maxWidth - 36) / 4
                : (constraints.maxWidth - 12) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _StatCard(
                    width: cardWidth,
                    icon: Icons.quiz_outlined,
                    label: S.totalInterviews,
                    value: '${results.length}',
                    color: colors.primary),
                _StatCard(
                    width: cardWidth,
                    icon: Icons.trending_up,
                    label: S.averageScore,
                    value: '${avgScore.round()}',
                    color: colors.tertiary),
                _StatCard(
                    width: cardWidth,
                    icon: Icons.star_outline,
                    label: '最近分數',
                    value: '${lastScore.round()}',
                    color: colors.secondary),
                _StatCard(
                    width: cardWidth,
                    icon: Icons.description_outlined,
                    label: S.resumeCompleteness,
                    value: '${(user.resumeCompleteness * 100).round()}%',
                    color: colors.error),
              ],
            );
          }),
          const SizedBox(height: 28),

          // Score trend placeholder
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('分數趨勢',
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: results.reversed.map((r) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('${r.overallScore.round()}',
                                  style: textTheme.labelSmall
                                      ?.copyWith(color: colors.primary)),
                              const SizedBox(height: 4),
                              Container(
                                width: 40,
                                height: r.overallScore * 1.0,
                                decoration: BoxDecoration(
                                  color:
                                      colors.primary.withValues(alpha: 0.7),
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(4)),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                  '${r.date.month}/${r.date.day}',
                                  style: textTheme.labelSmall?.copyWith(
                                      color: colors.onSurfaceVariant)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Recent interviews table
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('最近面試紀錄',
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => context.go('/history'),
                child: const Text('查看全部'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            child: SizedBox(
              width: double.infinity,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('日期')),
                  DataColumn(label: Text('職位')),
                  DataColumn(label: Text('產業')),
                  DataColumn(label: Text('分數'), numeric: true),
                ],
                rows: results.take(3).map((r) {
                  return DataRow(
                    cells: [
                      DataCell(Text(
                          '${r.date.month}/${r.date.day}')),
                      DataCell(Text(r.position)),
                      DataCell(Text(r.industry)),
                      DataCell(Text(
                        '${r.overallScore.round()}',
                        style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.primary),
                      )),
                    ],
                    onSelectChanged: (_) =>
                        context.push('/history/${r.id}'),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.width,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 2),
                  Text(value,
                      style: textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
