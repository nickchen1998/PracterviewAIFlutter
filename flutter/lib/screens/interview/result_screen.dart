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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Score overview card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Row(
                      children: [
                        ScoreRing(
                            score: result.overallScore,
                            size: 120,
                            strokeWidth: 10),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('面試表現總覽',
                                  style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                '${result.position} · ${result.industry}',
                                style: textTheme.bodyMedium?.copyWith(
                                    color: colors.onSurfaceVariant),
                              ),
                              const SizedBox(height: 16),
                              ...result.categoryScores.entries.map((e) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 70,
                                        child: Text(e.key,
                                            style: textTheme.bodySmall
                                                ?.copyWith(
                                                    color: colors
                                                        .onSurfaceVariant)),
                                      ),
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: LinearProgressIndicator(
                                            value: e.value / 100,
                                            minHeight: 8,
                                            backgroundColor:
                                                const Color(0xFFE8EAED),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      SizedBox(
                                        width: 32,
                                        child: Text(
                                          '${e.value.round()}',
                                          style: textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Detailed feedback
                if (result.questionFeedbacks.isNotEmpty) ...[
                  Text(S.detailedFeedback,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...result.questionFeedbacks.map((qf) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: ExpansionTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          title: Text(qf.question,
                              style: textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w500)),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: colors.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${qf.score.round()} ${S.score}',
                              style: textTheme.labelSmall?.copyWith(
                                  color: colors.onPrimaryContainer,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF3F5F7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('你的回答',
                                            style: textTheme.labelMedium
                                                ?.copyWith(
                                                    color: colors
                                                        .onSurfaceVariant)),
                                        const SizedBox(height: 4),
                                        Text(qf.userAnswer,
                                            style: textTheme.bodySmall),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: colors.primary
                                          .withValues(alpha: 0.06),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.auto_awesome,
                                                size: 16,
                                                color: colors.primary),
                                            const SizedBox(width: 6),
                                            Text('AI 回饋',
                                                style: textTheme.labelMedium
                                                    ?.copyWith(
                                                        color:
                                                            colors.primary,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(qf.aiFeedback,
                                            style: textTheme.bodySmall),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],

                // Suggestions
                Text(S.suggestions,
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: result.suggestions
                          .map(
                            (s) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.lightbulb_outline,
                                      size: 18, color: colors.tertiary),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: Text(s,
                                          style: textTheme.bodyMedium)),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => context.go('/interview/setup'),
                      icon: const Icon(Icons.refresh),
                      label: const Text(S.retryInterview),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                      ),
                    ),
                    const SizedBox(width: 16),
                    FilledButton.icon(
                      onPressed: () => context.go('/home'),
                      icon: const Icon(Icons.home),
                      label: const Text(S.backToHome),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
