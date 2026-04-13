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

    Widget formSection = Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('基本資料',
                style:
                    textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildFieldRow(context, [
              const _Field(label: S.name, icon: Icons.person_outlined, value: '王小明'),
              const _Field(label: S.email, icon: Icons.email_outlined, value: 'xiaoming@example.com'),
            ]),
            const SizedBox(height: 14),
            _buildFieldRow(context, [
              const _Field(label: S.phone, icon: Icons.phone_outlined, value: '0912-345-678'),
            ]),
            const SizedBox(height: 24),
            Text('學歷',
                style:
                    textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _buildFieldRow(context, [
              _Field(label: S.school, icon: Icons.school_outlined, value: user.education?.school ?? ''),
              _Field(label: S.department, icon: Icons.menu_book_outlined, value: user.education?.department ?? ''),
            ]),
            const SizedBox(height: 14),
            _buildFieldRow(context, [
              _Field(label: S.graduationYear, icon: Icons.calendar_today_outlined, value: '${user.education?.graduationYear ?? ''}'),
            ]),
            const SizedBox(height: 24),
            Text('工作經驗',
                style:
                    textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _buildFieldRow(context, [
              _Field(label: S.jobTitle, icon: Icons.badge_outlined, value: user.experience?.jobTitle ?? ''),
              _Field(label: S.company, icon: Icons.business_outlined, value: user.experience?.company ?? ''),
            ]),
            const SizedBox(height: 14),
            _buildFieldRow(context, [
              _Field(label: S.yearsOfExperience, icon: Icons.work_history_outlined, value: '${user.experience?.yearsOfExperience ?? ''}'),
            ]),
            const SizedBox(height: 24),
            Text(S.skills,
                style:
                    textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...user.skills.map((s) => Chip(
                      label: Text(s),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {},
                      backgroundColor: colors.secondaryContainer,
                      side: BorderSide.none,
                    )),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text('新增技能'),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save, size: 18),
                label: const Text('儲存'),
              ),
            ),
          ],
        ),
      ),
    );

    Widget resumeSection = Column(
      children: [
        // Upload area
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(S.uploadResume,
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: colors.outlineVariant,
                        width: 2,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(12),
                    color: colors.surfaceContainerLowest,
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.cloud_upload_outlined,
                          size: 40, color: colors.primary),
                      const SizedBox(height: 8),
                      Text('拖放檔案或點擊上傳',
                          style: textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 4),
                      Text(S.uploadResumeHint,
                          style: textTheme.bodySmall
                              ?.copyWith(color: colors.onSurfaceVariant)),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file, size: 18),
                        label: const Text('選擇檔案'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Uploaded file
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.surfaceContainerHighest.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.picture_as_pdf, color: colors.error),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(resume.fileName,
                                style: textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w500)),
                            Text(
                              '上傳於 ${resume.uploadedAt.year}/${resume.uploadedAt.month}/${resume.uploadedAt.day}',
                              style: textTheme.bodySmall
                                  ?.copyWith(color: colors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          icon: const Icon(Icons.visibility_outlined, size: 20),
                          onPressed: () {}),
                      IconButton(
                          icon: Icon(Icons.delete_outline,
                              size: 20, color: colors.error),
                          onPressed: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // AI Analysis
        if (resume.analysis != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: colors.primary, size: 22),
                      const SizedBox(width: 8),
                      Text('AI 履歷分析',
                          style: textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${resume.analysis!.overallScore.round()} / 100',
                          style: textTheme.labelLarge?.copyWith(
                              color: colors.onPrimaryContainer,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(S.strengths,
                      style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.primary)),
                  const SizedBox(height: 6),
                  ...resume.analysis!.strengths.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle,
                              size: 16, color: colors.primary),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(s, style: textTheme.bodySmall)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(S.improvements,
                      style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colors.tertiary)),
                  const SizedBox(height: 6),
                  ...resume.analysis!.improvements.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline,
                              size: 16, color: colors.tertiary),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(s, style: textTheme.bodySmall)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('個人經歷',
              style: textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          if (isExpanded(context))
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: formSection),
                const SizedBox(width: 20),
                Expanded(flex: 2, child: resumeSection),
              ],
            )
          else ...[
            formSection,
            const SizedBox(height: 16),
            resumeSection,
          ],
        ],
      ),
    );
  }

  Widget _buildFieldRow(BuildContext context, List<_Field> fields) {
    if (fields.length == 1 || isCompact(context)) {
      return Column(
        children: fields
            .map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildTextField(f),
                ))
            .toList(),
      );
    }
    return Row(
      children: fields
          .map((f) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: f != fields.last ? 12 : 0),
                  child: _buildTextField(f),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildTextField(_Field field) {
    return TextFormField(
      initialValue: field.value,
      decoration: InputDecoration(
        labelText: field.label,
        prefixIcon: Icon(field.icon),
      ),
    );
  }
}

class _Field {
  final String label;
  final IconData icon;
  final String value;

  const _Field({required this.label, required this.icon, required this.value});
}
