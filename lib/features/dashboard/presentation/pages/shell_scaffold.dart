import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Navigation layout wrapper containing the BottomNavigationBar for Shell routing.
class ShellScaffold extends StatelessWidget {
  final Widget child;

  const ShellScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Determine selected index by reading route matching details.
    final location = GoRouterState.of(context).matchedLocation;
    final int selectedIndex = location == '/profile' ? 1 : 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          if (index == 0) {
            context.go('/dashboard');
          } else {
            context.go('/profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
