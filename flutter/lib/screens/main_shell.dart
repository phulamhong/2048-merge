import 'package:flutter/material.dart';

import '../core/save_manager.dart';
import 'home_screen.dart';
import 'properties_screen.dart';

/// App root: 2 tabs sharing 1 [SaveManager] — "Chơi" (the existing flat
/// chapter list, HomeScreen, unchanged) and "Tài sản" (the world-map view,
/// PropertiesScreen). An [IndexedStack] keeps both alive so switching tabs
/// doesn't lose scroll position or rebuild state.
class MainShell extends StatefulWidget {
  final SaveManager saveManager;
  const MainShell({super.key, required this.saveManager});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _tab,
        children: [HomeScreen(saveManager: widget.saveManager), PropertiesScreen(saveManager: widget.saveManager)],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Text('🎮', style: TextStyle(fontSize: 22)), label: 'Chơi'),
          NavigationDestination(icon: Text('🗺️', style: TextStyle(fontSize: 22)), label: 'Tài sản'),
        ],
      ),
    );
  }
}
