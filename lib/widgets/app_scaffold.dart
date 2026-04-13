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
    if (location.startsWith('/interview')) return 1;
    if (location.startsWith('/history')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _currentIndex(context);

    if (isCompact(context)) {
      return Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (i) => _onTap(context, i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: S.navHome,
            ),
            NavigationDestination(
              icon: Icon(Icons.record_voice_over_outlined),
              selectedIcon: Icon(Icons.record_voice_over),
              label: S.navInterview,
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: S.navHistory,
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: S.navProfile,
            ),
          ],
        ),
      );
    }

    // Medium + Expanded: top navbar
    return Scaffold(
      body: Column(
        children: [
          _WebNavBar(currentIndex: index, onTap: (i) => _onTap(context, i)),
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
        context.go('/interview/setup');
      case 2:
        context.go('/history');
      case 3:
        context.go('/profile');
    }
  }
}

class _WebNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _WebNavBar({required this.currentIndex, required this.onTap});

  static const _items = [
    (icon: Icons.home_outlined, selectedIcon: Icons.home, label: S.navHome),
    (
      icon: Icons.record_voice_over_outlined,
      selectedIcon: Icons.record_voice_over,
      label: S.navInterview,
    ),
    (
      icon: Icons.history_outlined,
      selectedIcon: Icons.history,
      label: S.navHistory,
    ),
    (
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: S.navProfile,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.5))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // Logo
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onTap(0),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'icons/Icon-192.png',
                    width: 32,
                    height: 32,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.work_outline,
                      size: 28,
                      color: colors.primary,
                    ),
                  ),
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
          ),
          const SizedBox(width: 32),

          // Nav items
          ...List.generate(_items.length, (i) {
            final item = _items[i];
            final selected = currentIndex == i;
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: _NavItem(
                icon: selected ? item.selectedIcon : item.icon,
                label: item.label,
                selected: selected,
                onTap: () => onTap(i),
              ),
            );
          }),

          const Spacer(),

          // User avatar
          PopupMenuButton<String>(
            offset: const Offset(0, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 20),
                    SizedBox(width: 8),
                    Text(S.profile),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text('登出'),
                  ],
                ),
              ),
            ],
            onSelected: (v) {
              if (v == 'profile') onTap(3);
            },
            child: CircleAvatar(
              radius: 18,
              backgroundColor: colors.primaryContainer,
              child: Text(
                '王',
                style: textTheme.labelLarge?.copyWith(
                  color: colors.onPrimaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: selected ? colors.primaryContainer.withValues(alpha: 0.5) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? colors.primary : colors.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: textTheme.labelLarge?.copyWith(
                color: selected ? colors.primary : colors.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
