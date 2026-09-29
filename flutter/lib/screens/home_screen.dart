import 'package:flutter/material.dart';

import '../core/save_manager.dart';
import '../data/chapters.dart' as chapter_data;
import '../main.dart' show routeObserver;
import '../widgets/chapter_card.dart';
import '../widgets/shop_dialog.dart';
import 'game_screen.dart';

const _bg = Color(0xFF2E3A23);

/// Chapter map / home screen — port of src/scenes/ChapterMapScene.ts. Shows
/// every chapter with its recipe, ingredient progress, and level buttons;
/// tapping an unlocked level opens [GameScreen].
class HomeScreen extends StatefulWidget {
  final SaveManager saveManager;
  const HomeScreen({super.key, required this.saveManager});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  SaveManager get _save => widget.saveManager;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of<void>(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  /// Called whenever a pushed route above this one is popped and Home
  /// becomes visible again. Refreshes unconditionally rather than relying on
  /// awaiting the original `Navigator.push` future, which only tracks the
  /// single route it pushed — fragile once "Màn tiếp" replaces that route
  /// with the next level's (chained several levels deep via
  /// `pushReplacement`), the reported symptom being stars/unlocks for
  /// levels played after the first "Màn tiếp" not showing up back home.
  @override
  void didPopNext() {
    if (mounted) setState(() {});
  }

  void _openLevel(String levelId) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => GameScreen(saveManager: _save, levelId: levelId)));
  }

  void _cook(String chapterId) {
    setState(() => _save.cook(chapterId));
  }

  Future<void> _openShop() async {
    await showDialog<void>(context: context, builder: (_) => ShopDialog(saveManager: _save));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            _Header(save: _save, onOpenShop: _openShop),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: chapter_data.chapters.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ChapterCard(save: _save, chapter: chapter_data.chapters[i], onOpenLevel: _openLevel, onCook: _cook),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final SaveManager save;
  final VoidCallback onOpenShop;
  const _Header({required this.save, required this.onOpenShop});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Nông Trại & Bếp Việt', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('🪙 ${save.data.coins}', style: const TextStyle(color: Color(0xFFE9C46A), fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              Text('💎 ${save.data.gems}', style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              Text('⚡ ${save.energy}/${save.energyMax}', style: const TextStyle(color: Colors.white70, fontSize: 17)),
              const Spacer(),
              IconButton(onPressed: onOpenShop, icon: const Text('🛍️', style: TextStyle(fontSize: 22)), tooltip: 'Cửa hàng'),
            ],
          ),
        ],
      ),
    );
  }
}
