import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../utils/breakpoints.dart';
import '../../utils/strings.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isCompact(context)) {
      return Scaffold(body: Center(child: _LoginForm(ref: ref)));
    }

    // Medium + Expanded: split layout
    return Scaffold(
      body: Row(
        children: [
          const Expanded(flex: 5, child: _BrandingPanel()),
          Expanded(
            flex: 4,
            child: Center(child: _LoginForm(ref: ref)),
          ),
        ],
      ),
    );
  }
}

class _BrandingPanel extends StatelessWidget {
  const _BrandingPanel();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.primary,
            colors.primary.withValues(alpha: 0.85),
            colors.tertiary.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'icons/Icon-192.png',
                width: 80,
                height: 80,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.work_outline,
                  size: 80,
                  color: colors.onPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                S.appName,
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.onPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                S.appTagline,
                style: textTheme.titleMedium?.copyWith(
                  color: colors.onPrimary.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 48),
              // Feature highlights
              ...['AI 即時回饋，精準提升', '模擬真實面試場景', '支援文字與語音模式'].map(
                (text) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: colors.onPrimary.withValues(alpha: 0.8), size: 20),
                      const SizedBox(width: 12),
                      Text(
                        text,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colors.onPrimary.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  final WidgetRef ref;

  const _LoginForm({required this.ref});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isCompact(context)) ...[
              Center(
                child: Column(
                  children: [
                    Icon(Icons.work_outline, size: 48, color: colors.primary),
                    const SizedBox(height: 8),
                    Text(
                      S.appName,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
            Text(
              '歡迎回來',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '登入你的帳號開始面試練習',
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            const TextField(
              decoration: InputDecoration(
                labelText: S.email,
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: S.password,
                prefixIcon: Icon(Icons.lock_outlined),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(S.forgotPassword),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(
                onPressed: () => ref.read(authProvider.notifier).login(),
                child: const Text(S.login),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    S.orLoginWith,
                    style: textTheme.bodySmall
                        ?.copyWith(color: colors.onSurfaceVariant),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => ref.read(authProvider.notifier).login(),
                    icon: const Icon(Icons.g_mobiledata, size: 24),
                    label: const Text('Google'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => ref.read(authProvider.notifier).login(),
                    icon: const Icon(Icons.apple, size: 20),
                    label: const Text('Apple'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.noAccount,
                    style: textTheme.bodyMedium
                        ?.copyWith(color: colors.onSurfaceVariant)),
                TextButton(
                  onPressed: () => context.go('/register'),
                  child: const Text(S.register),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
