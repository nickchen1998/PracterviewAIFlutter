import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import '../../utils/breakpoints.dart';
import '../../utils/strings.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final resume = ref.watch(resumeProvider);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Identity column
    Widget identityCol = Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: colors.primaryContainer,
          child: Text(
            user.name.isNotEmpty ? user.name[0] : '?',
            style: textTheme.headlineMedium
                ?.copyWith(color: colors.onPrimaryContainer),
          ),
        ),
        const SizedBox(height: 12),
        Text(user.name,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        Text(user.email,
            style:
                textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant)),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.edit, size: 16),
          label: const Text(S.editProfile),
        ),
        const SizedBox(height: 20),
        _SectionCard(
          title: S.stepBasicInfo,
          icon: Icons.person_outlined,
          children: [
            _InfoRow(label: S.phone, value: user.phone ?? '-'),
            if (user.education != null) ...[
              _InfoRow(label: S.school, value: user.education!.school),
              _InfoRow(label: S.department, value: user.education!.department),
              _InfoRow(
                  label: S.graduationYear,
                  value: '${user.education!.graduationYear}'),
            ],
            if (user.experience != null) ...[
              _InfoRow(label: S.jobTitle, value: user.experience!.jobTitle),
              _InfoRow(label: S.company, value: user.experience!.company),
              _InfoRow(
                  label: S.yearsOfExperience,
                  value: '${user.experience!.yearsOfExperience} 年'),
            ],
          ],
        ),
        const SizedBox(height: 16),
        _SectionCard(
          title: S.skills,
          icon: Icons.label_outlined,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: user.skills
                  .map((s) => Chip(
                        label: Text(s),
                        backgroundColor: colors.secondaryContainer,
                        side: BorderSide.none,
                      ))
                  .toList(),
            ),
          ],
        ),
      ],
    );

    // Documents column
    Widget docsCol = Column(
      children: [
        _SectionCard(
          title: S.myResume,
          icon: Icons.description_outlined,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.picture_as_pdf, color: colors.error),
              title: Text(resume.fileName),
              subtitle: Text(
                '上傳於 ${resume.uploadedAt.year}/${resume.uploadedAt.month}/${resume.uploadedAt.day}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.visibility_outlined),
                onPressed: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (resume.analysis != null)
          _SectionCard(
            title: S.aiAnalysis,
            icon: Icons.auto_awesome,
            children: [
              Row(
                children: [
                  Text(
                    '${resume.analysis!.overallScore.round()}',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                  Text(' / 100',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colors.onSurfaceVariant)),
                ],
              ),
              const SizedBox(height: 12),
              Text(S.strengths,
                  style: textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              ...resume.analysis!.strengths.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, size: 16, color: colors.primary),
                      const SizedBox(width: 8),
                      Expanded(child: Text(s, style: textTheme.bodySmall)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(S.improvements,
                  style: textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              ...resume.analysis!.improvements.map(
                (s) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb_outline,
                          size: 16, color: colors.tertiary),
                      const SizedBox(width: 8),
                      Expanded(child: Text(s, style: textTheme.bodySmall)),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );

    if (isExpanded(context)) {
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: identityCol),
              const SizedBox(width: 24),
              Expanded(child: docsCol),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                identityCol,
                const SizedBox(height: 16),
                docsCol,
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          Expanded(
              child:
                  Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
