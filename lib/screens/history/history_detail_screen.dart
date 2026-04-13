import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/history_provider.dart';
import '../../utils/strings.dart';
import '../../widgets/score_ring.dart';

class HistoryDetailScreen extends ConsumerWidget {
  final String resultId;

  const HistoryDetailScreen({super.key, required this.resultId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(selectedResultProvider(resultId));
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('找不到該筆紀錄')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(result.position),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                // Header info
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${result.date.year}/${result.date.month}/${result.date.day}',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colors.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(result.industry,
                          style: textTheme.labelSmall?.copyWith(
                              color: colors.onSecondaryContainer)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                ScoreRing(score: result.overallScore, size: 120),
                const SizedBox(height: 24),

                // Category scores
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: result.categoryScores.entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(e.key,
                                    style: textTheme.bodySmall?.copyWith(
                                        color: colors.onSurfaceVariant)),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: e.value / 100,
                                    minHeight: 8,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text('${e.value.round()}',
                                  style: textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Q&A
                if (result.questionFeedbacks.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(S.detailedFeedback,
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  ...result.questionFeedbacks.map((qf) => Card(
                        child: ExpansionTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: Text(qf.question,
                              style: textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500)),
                          trailing: Text('${qf.score.round()} ${S.score}',
                              style: textTheme.labelMedium?.copyWith(
                                  color: colors.primary,
                                  fontWeight: FontWeight.w600)),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(qf.userAnswer,
                                      style: textTheme.bodySmall),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: colors.primaryContainer
                                          .withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.auto_awesome,
                                            size: 16, color: colors.primary),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(qf.aiFeedback,
                                                style: textTheme.bodySmall)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),
                ],

                // Suggestions
                if (result.suggestions.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(S.suggestions,
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: result.suggestions
                            .map((s) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.lightbulb_outline,
                                          size: 18, color: colors.tertiary),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(s,
                                              style: textTheme.bodySmall)),
                                    ],
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
