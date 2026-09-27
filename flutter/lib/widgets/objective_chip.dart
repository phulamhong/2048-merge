import 'package:flutter/material.dart';

import '../core/types.dart';
import '../game/tile_look.dart';

/// Same visual as the in-canvas objective icon (ObjectiveIconComponent), as a
/// plain Flutter widget for screens outside the Flame board: the level-intro
/// and level-result dialogs.
class ObjectiveChip extends StatelessWidget {
  final ChainDef chain;
  final ObjectiveDef objective;
  final int progress;

  const ObjectiveChip({super.key, required this.chain, required this.objective, this.progress = 0});

  @override
  Widget build(BuildContext context) {
    final look = objectiveLookOf(chain, objective);
    final complete = progress >= objective.target;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: complete ? const Color(0xFF3D6B3F) : toFlutterColor(look.color),
            borderRadius: BorderRadius.circular(10),
            border: complete ? Border.all(color: const Color(0xFF8FE388), width: 2) : null,
          ),
          child: Text(look.emoji, style: const TextStyle(fontSize: 26)),
        ),
        const SizedBox(height: 4),
        Text(
          complete ? '✓ ${objective.target}/${objective.target}' : '$progress/${objective.target}',
          style: TextStyle(
            color: complete ? const Color(0xFF8FE388) : Colors.white70,
            fontSize: 13,
            fontWeight: complete ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
