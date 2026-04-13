import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../utils/breakpoints.dart';
import '../utils/strings.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/profile')) return 1;
    if (location.startsWith('/history') ||
        location.startsWith('/interview')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    if (isCompact(context)) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('images/logo.png', width: 28, height: 28),
              const SizedBox(width: 8),
              Text(
                S.appName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: _SidebarContent(
            currentIndex: index,
            onTap: (i) {
              Navigator.pop(context);
              _onTap(context, i);
            },
          ),
        ),
        body: child,
      );
    }

    // Desktop: fixed sidebar
    return Scaffold(
      body: Row(
        children: [
          _SidebarContent(
            currentIndex: index,
            onTap: (i) => _onTap(context, i),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
      case 1:
        context.go('/profile');
      case 2:
        context.go('/history');
    }
  }
}

class _SidebarContent extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _SidebarContent({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 250,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Logo
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Row(
                children: [
                  Image.asset('images/logo.png', width: 34, height: 34),
                  const SizedBox(width: 10),
                  Text(
                    S.appName,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Nav items
            _NavItem(
              icon: Icons.dashboard_outlined,
              selectedIcon: Icons.dashboard,
              label: '儀表板',
              selected: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: '個人經歷',
              selected: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            _NavItem(
              icon: Icons.history_outlined,
              selectedIcon: Icons.history,
              label: '面試紀錄',
              selected: currentIndex == 2,
              onTap: () => onTap(2),
            ),

            const Spacer(),

            // User section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F5F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: colors.primaryContainer,
                    child: Text(
                      '王',
                      style: textTheme.labelMedium
                          ?.copyWith(color: colors.onPrimaryContainer),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('王小明',
                            style: textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        Text('xiaoming@example.com',
                            style: textTheme.labelSmall?.copyWith(
                                color: colors.onSurfaceVariant),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout,
                        size: 18, color: colors.onSurfaceVariant),
                    onPressed: () {},
                    tooltip: '登出',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: selected ? colors.primary.withValues(alpha: 0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Icon(
                  selected ? selectedIcon : icon,
                  size: 22,
                  color: selected ? colors.primary : colors.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: textTheme.bodyMedium?.copyWith(
                    color: selected ? colors.primary : colors.onSurface,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                if (selected) ...[
                  const Spacer(),
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
