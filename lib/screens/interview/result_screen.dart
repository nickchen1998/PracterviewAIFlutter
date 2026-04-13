import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/mock_data.dart';
import '../../utils/strings.dart';
import '../../widgets/score_ring.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = MockData.interviewResults.first;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(S.interviewResult),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                // Overall score
                ScoreRing(score: result.overallScore, size: 140, strokeWidth: 12),
                const SizedBox(height: 8),
                Text(S.overallScore,
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colors.onSurfaceVariant)),
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
                                    backgroundColor:
                                        colors.surfaceContainerHighest,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              SizedBox(
                                width: 36,
                                child: Text(
                                  '${e.value.round()}',
                                  style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Detailed feedback
                if (result.questionFeedbacks.isNotEmpty) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(S.detailedFeedback,
                        style: textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 8),
                  ...result.questionFeedbacks.map((qf) {
                    return Card(
                      child: ExpansionTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(qf.question,
                                  style: textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w500)),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: colors.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${qf.score.round()} ${S.score}',
                                style: textTheme.labelSmall?.copyWith(
                                    color: colors.onPrimaryContainer,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('你的回答',
                                    style: textTheme.labelMedium?.copyWith(
                                        color: colors.onSurfaceVariant)),
                                const SizedBox(height: 4),
                                Text(qf.userAnswer,
                                    style: textTheme.bodySmall),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Icon(Icons.auto_awesome,
                                        size: 16, color: colors.primary),
                                    const SizedBox(width: 4),
                                    Text('AI 回饋',
                                        style: textTheme.labelMedium?.copyWith(
                                            color: colors.primary)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(qf.aiFeedback,
                                    style: textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 20),
                ],

                // Suggestions
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
                          .map(
                            (s) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.lightbulb_outline,
                                      size: 18, color: colors.tertiary),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(s,
                                          style: textTheme.bodySmall)),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.go('/interview/setup'),
                        icon: const Icon(Icons.refresh),
                        label: const Text(S.retryInterview),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => context.go('/home'),
                        icon: const Icon(Icons.home),
                        label: const Text(S.backToHome),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
