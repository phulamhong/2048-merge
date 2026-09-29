import 'package:flutter/material.dart';

import '../core/save_manager.dart';
import '../core/types.dart';
import '../data/properties.dart' as property_data;
import '../main.dart' show routeObserver;
import 'property_grid_screen.dart';

const _bg = Color(0xFF2E3A23);
const _panel = Color(0xFF3A4A2C);
const _panelLocked = Color(0xFF2A3320);

/// "Tài sản" tab — the world map: 1 banner per [PropertyDef], locked until
/// the property before it is done. Tapping an unlocked one drills into
/// [PropertyGridScreen] for its chapters-as-locations.
class PropertiesScreen extends StatefulWidget {
  final SaveManager saveManager;
  const PropertiesScreen({super.key, required this.saveManager});

  @override
  State<PropertiesScreen> createState() => _PropertiesScreenState();
}

class _PropertiesScreenState extends State<PropertiesScreen> with RouteAware {
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

  // Same unconditional-refresh reasoning as HomeScreen's didPopNext (see
  // home_screen.dart) — this tab stays alive in MainShell's IndexedStack, so
  // it needs its own subscription to notice unlocks after returning to Home.
  @override
  void didPopNext() {
    if (mounted) setState(() {});
  }

  void _openProperty(PropertyDef property) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PropertyGridScreen(saveManager: _save, property: property)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Tài sản', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: property_data.properties.length,
                itemBuilder: (context, i) {
                  final property = property_data.properties[i];
                  final unlocked = _save.isPropertyUnlocked(property);
                  final done = _save.isPropertyDone(property);
                  final prevName = i > 0 ? property_data.properties[i - 1].name : null;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _PropertyBanner(
                      property: property,
                      unlocked: unlocked,
                      done: done,
                      lockedReason: unlocked || prevName == null ? null : 'Hoàn thành "$prevName" để mở khoá',
                      onTap: unlocked ? () => _openProperty(property) : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyBanner extends StatelessWidget {
  final PropertyDef property;
  final bool unlocked;
  final bool done;
  final String? lockedReason;
  final VoidCallback? onTap;

  const _PropertyBanner({required this.property, required this.unlocked, required this.done, this.lockedReason, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: unlocked ? _panel : _panelLocked,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
          child: Row(
            children: [
              Text(unlocked ? property.emoji : '🔒', style: const TextStyle(fontSize: 40)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(property.name, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    if (!unlocked)
                      Text(lockedReason ?? '', style: const TextStyle(color: Colors.white54, fontSize: 13))
                    else if (done)
                      const Text('✓ Đã hoàn thành', style: TextStyle(color: Color(0xFF8FE388), fontSize: 13, fontWeight: FontWeight.bold))
                    else
                      Text('${property.chapterIds.length} địa điểm', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
              if (unlocked) const Icon(Icons.chevron_right, color: Colors.white38),
            ],
          ),
        ),
      ),
    );
  }
}
