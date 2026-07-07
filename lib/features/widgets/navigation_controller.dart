import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/presentation/providers/auth_provider.dart';

enum NavTab {
  home,
  calls,
  dialer,
  wallet,
  profile,
}

class NavigationState {
  final int currentIndex;
  final bool isNavVisible;
  final List<NavTab> availableTabs;

  const NavigationState({
    this.currentIndex = 0,
    this.isNavVisible = true,
    this.availableTabs = const [NavTab.home],
  });

  NavigationState copyWith({
    int? currentIndex,
    bool? isNavVisible,
    List<NavTab>? availableTabs,
  }) {
    return NavigationState(
      currentIndex: currentIndex ?? this.currentIndex,
      isNavVisible: isNavVisible ?? this.isNavVisible,
      availableTabs: availableTabs ?? this.availableTabs,
    );
  }
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  final Ref ref;

  NavigationNotifier(this.ref) : super(const NavigationState()) {
    // Re-evaluate tabs when authState changes
    ref.listen(authProvider, (previous, next) {
      evaluateTabs();
    });
    // Initial evaluation
    evaluateTabs();
  }

  void evaluateTabs() {
    final authState = ref.read(authProvider);
    // For now, show all modules to the user (no permissions filtering).
    authState.maybeWhen(
      authenticated: (user) {
        final List<NavTab> tabs = NavTab.values.toList();
        state = state.copyWith(
          availableTabs: tabs,
          currentIndex: 0,
        );
      },
      orElse: () {
        // If you prefer guests to see fewer tabs, change this to a smaller list.
        final List<NavTab> tabs = NavTab.values.toList();
        state = state.copyWith(
          availableTabs: tabs,
          currentIndex: 0,
        );
      },
    );
  }

  void changePage(int index) {
    if (index >= state.availableTabs.length) return;
    state = state.copyWith(currentIndex: index);
    _fetchDataForTab(index);
    _logTabAnalytics(index);
  }

  void _logTabAnalytics(int index) {
    if (index >= state.availableTabs.length) return;
    // Placeholder for telemetry / analytics logging (GetX equivalent)
  }

  void _fetchDataForTab(int index) {
    if (index >= state.availableTabs.length) return;
    // Placeholder for dynamic data fetching based on tab (GetX equivalent)
  }

  void setNavVisibility(bool visible) {
    state = state.copyWith(isNavVisible: visible);
  }

  void reset() {
    state = const NavigationState();
    evaluateTabs();
  }
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>((ref) {
  return NavigationNotifier(ref);
});
