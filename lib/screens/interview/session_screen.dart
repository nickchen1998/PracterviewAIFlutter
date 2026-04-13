import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/interview.dart';
import '../../providers/interview_provider.dart';
import '../../utils/strings.dart';
import '../../widgets/chat_bubble.dart';

class SessionScreen extends ConsumerStatefulWidget {
  const SessionScreen({super.key});

  @override
  ConsumerState<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  final _controller = TextEditingController();
  bool _isVoiceMode = false;
  bool _isRecording = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(messagesProvider);
    final setup = ref.watch(interviewSetupProvider);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.interviewInProgress),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _showEndDialog(context),
        ),
        actions: [
          // Timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: colors.errorContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer, size: 16, color: colors.onErrorContainer),
                const SizedBox(width: 4),
                Text(
                  '12:34',
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${setup.position} - ${setup.industry}',
                        style: textTheme.labelSmall
                            ?.copyWith(color: colors.onSurfaceVariant)),
                    Text('3 / 8 題',
                        style: textTheme.labelSmall
                            ?.copyWith(color: colors.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: 3 / 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ),

          // Mode toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.chat_outlined, size: 16),
                      const SizedBox(width: 4),
                      const Text(S.textMode),
                    ],
                  ),
                  selected: !_isVoiceMode,
                  onSelected: (_) => setState(() => _isVoiceMode = false),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.mic_outlined, size: 16),
                      const SizedBox(width: 4),
                      const Text(S.voiceMode),
                    ],
                  ),
                  selected: _isVoiceMode,
                  onSelected: (_) => setState(() => _isVoiceMode = true),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Messages / Voice area
          Expanded(
            child: _isVoiceMode
                ? _buildVoiceArea(context)
                : _buildChatArea(context, messages),
          ),

          // Input area
          _isVoiceMode
              ? _buildVoiceInput(context)
              : _buildTextInput(context),
        ],
      ),
    );
  }

  Widget _buildChatArea(
      BuildContext context, List<InterviewMessage> messages) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      reverse: false,
      itemCount: messages.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final msg = messages[i];
        return ChatBubble(
          message: msg.content,
          isFromAI: msg.isFromAI,
          time:
              '${msg.timestamp.hour.toString().padLeft(2, '0')}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
        );
      },
    );
  }

  Widget _buildVoiceArea(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Waveform placeholder
          Container(
            width: 200,
            height: 60,
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: _isRecording
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      20,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 4,
                        height: _isRecording ? (10.0 + (i % 5) * 8) : 10,
                        decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      '語音波形',
                      style: textTheme.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          if (_isRecording)
            Text(S.recording,
                style: textTheme.bodyMedium
                    ?.copyWith(color: colors.error))
          else
            Text(S.tapToSpeak,
                style: textTheme.bodyMedium
                    ?.copyWith(color: colors.onSurfaceVariant)),
          const SizedBox(height: 24),
          // Last AI question
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.smart_toy_outlined,
                    size: 20, color: colors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '請問你能解釋一下 React 中的 Virtual DOM 是什麼？它如何提升效能？',
                    style: textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: S.typeYourAnswer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: colors.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                ),
                maxLines: 3,
                minLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: () {},
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceInput(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.outlineVariant)),
      ),
      child: SafeArea(
        top: false,
        child: Center(
          child: GestureDetector(
            onTap: () => setState(() => _isRecording = !_isRecording),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _isRecording ? 80 : 64,
              height: _isRecording ? 80 : 64,
              decoration: BoxDecoration(
                color: _isRecording ? colors.error : colors.primary,
                shape: BoxShape.circle,
                boxShadow: _isRecording
                    ? [
                        BoxShadow(
                          color: colors.error.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: _isRecording ? colors.onError : colors.onPrimary,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEndDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(S.endInterview),
        content: const Text('確定要結束面試嗎？結束後將產生面試結果報告。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/interview/result');
            },
            child: const Text('結束'),
          ),
        ],
      ),
    );
  }
}
