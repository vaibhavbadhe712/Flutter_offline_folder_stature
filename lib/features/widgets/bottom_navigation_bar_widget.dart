import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navigation_controller.dart';

class BottomNavigationBarWidget extends ConsumerWidget {
  const BottomNavigationBarWidget({super.key});

  BottomNavigationBarItem _buildItemForTab(NavTab tab) {
    switch (tab) {
      case NavTab.home:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        );
      case NavTab.calls:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy_outlined),
          activeIcon: Icon(Icons.smart_toy),
          label: 'Calls',
        );
      case NavTab.dialer:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.phone_outlined),
          activeIcon: Icon(Icons.phone),
          label: 'Dialer',
        );
      case NavTab.wallet:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet_outlined),
          activeIcon: Icon(Icons.account_balance_wallet),
          label: 'Wallet',
        );
      case NavTab.profile:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          activeIcon: Icon(Icons.menu),
          label: 'More',
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final navState = ref.watch(navigationProvider);
    final navNotifier = ref.read(navigationProvider.notifier);

    if (!navState.isNavVisible) return const SizedBox.shrink();

    final isDark = theme.brightness == Brightness.dark;
    final navBarSelectedColor = isDark ? const Color(0xFF00B0FF) : const Color(0xFF0288D1);

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: navState.currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.colorScheme.surface,
        selectedItemColor: navBarSelectedColor,
        unselectedItemColor: theme.colorScheme.onSurfaceVariant.withValues(
          alpha: 0.6,
        ),
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.2,
        ),
        onTap: (index) {
          navNotifier.changePage(index);
        },
        items: navState.availableTabs
            .map((tab) => _buildItemForTab(tab))
            .toList(),
      ),
    );
  }
}
