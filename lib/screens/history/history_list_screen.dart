import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/interview.dart';
import '../../providers/history_provider.dart';
import '../../utils/strings.dart';

class HistoryListScreen extends ConsumerWidget {
  const HistoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(historyProvider);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(S.history,
                style: textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ),
          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                FilterChip(
                  label: const Text(S.filterByDate),
                  onSelected: (_) {},
                  selected: false,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text(S.filterByPosition),
                  onSelected: (_) {},
                  selected: false,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text(S.filterByIndustry),
                  onSelected: (_) {},
                  selected: false,
                ),
              ],
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history,
                            size: 64, color: colors.onSurfaceVariant),
                        const SizedBox(height: 16),
                        Text(S.noHistory,
                            style: textTheme.bodyLarge
                                ?.copyWith(color: colors.onSurfaceVariant)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, i) {
                      final r = results[i];
                      return Card(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => context.push('/history/${r.id}'),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: colors.primaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${r.overallScore.round()}',
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colors.onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(r.position,
                                          style: textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${r.industry} | ${_typeLabel(r.type)}',
                                        style: textTheme.bodySmall?.copyWith(
                                            color: colors.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${r.date.month}/${r.date.day}',
                                      style: textTheme.labelMedium?.copyWith(
                                          color: colors.onSurfaceVariant),
                                    ),
                                    const SizedBox(height: 4),
                                    Icon(Icons.chevron_right,
                                        color: colors.onSurfaceVariant),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
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
}
