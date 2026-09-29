import 'package:flutter/material.dart';

import '../data/scenes.dart';

/// Shown once per chapter (see [ChapterDef.introSceneId]), before
/// [LevelIntroDialog] on that chapter's first level — a short NPC scene
/// scrollable in one dialog, all lines visible at once rather than
/// advanced one at a time.
class SceneDialog extends StatelessWidget {
  final SceneDef scene;

  const SceneDialog({super.key, required this.scene});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF3A4A2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 360),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [for (final line in scene.lines) _LineWidget(line: line)],
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6A994E),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Tiếp tục', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineWidget extends StatelessWidget {
  final DialogueLine line;

  const _LineWidget({required this.line});

  @override
  Widget build(BuildContext context) {
    if (line.speaker.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          line.text,
          style: const TextStyle(color: Colors.white54, fontSize: 13, fontStyle: FontStyle.italic),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            line.speaker,
            style: const TextStyle(color: Color(0xFFE9C46A), fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(line.text, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }
}
