import 'package:flutter/material.dart';

import '../data/scenes.dart';

class _SpeakerLook {
  final String? portraitAsset;
  final String emoji;
  final Color color;
  const _SpeakerLook({this.portraitAsset, required this.emoji, required this.color});
}

/// Portrait (character art + accent color) per named character. Falls back
/// to an emoji placeholder for any name not listed here, or if its art
/// asset is missing.
const _speakerLooks = <String, _SpeakerLook>{
  'Mai': _SpeakerLook(portraitAsset: 'assets/characters/mai_portrait.png', emoji: '👩', color: Color(0xFFE9C46A)),
  'Ông Tư': _SpeakerLook(portraitAsset: 'assets/characters/ong_tu_portrait.png', emoji: '👨‍🌾', color: Color(0xFF6A994E)),
  'Chú Bảy': _SpeakerLook(portraitAsset: 'assets/characters/chu_bay_portrait.png', emoji: '🧑‍🌾', color: Color(0xFFBC6C25)),
  'Bé Na': _SpeakerLook(portraitAsset: 'assets/characters/be_na_portrait.png', emoji: '👧', color: Color(0xFFE07A9E)),
  'Dì Sáu': _SpeakerLook(portraitAsset: 'assets/characters/di_sau_portrait.png', emoji: '👵', color: Color(0xFFE76F51)),
};
const _defaultLook = _SpeakerLook(emoji: '🧑', color: Colors.white38);

/// Shown once per chapter (see `ChapterDef.introSceneId`), before
/// LevelIntroDialog on that chapter's first level. A proper dialogue
/// sequence — one line at a time, in order, each with the speaker's
/// portrait — rather than a wall of text dumped all at once.
class SceneDialog extends StatefulWidget {
  final SceneDef scene;

  const SceneDialog({super.key, required this.scene});

  @override
  State<SceneDialog> createState() => _SceneDialogState();
}

class _SceneDialogState extends State<SceneDialog> {
  int _index = 0;

  void _advance() {
    if (_index < widget.scene.lines.length - 1) {
      setState(() => _index++);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final line = widget.scene.lines[_index];
    final isLast = _index == widget.scene.lines.length - 1;
    final look = line.speaker.isEmpty ? null : (_speakerLooks[line.speaker] ?? _defaultLook);

    return Dialog(
      backgroundColor: const Color(0xFF3A4A2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StepDots(count: widget.scene.lines.length, current: _index),
            const SizedBox(height: 18),
            GestureDetector(
              key: const Key('scene_dialog_tap_area'),
              behavior: HitTestBehavior.opaque,
              onTap: _advance,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 120),
                child: look == null ? _DirectionLine(text: line.text) : _SpokenLine(line: line, look: look),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6A994E),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _advance,
                child: Text(
                  isLast ? 'Tiếp tục' : 'Tiếp ›',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  final int count;
  final int current;

  const _StepDots({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            width: i == current ? 16 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == current ? const Color(0xFFE9C46A) : Colors.white24,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}

class _SpokenLine extends StatelessWidget {
  final DialogueLine line;
  final _SpeakerLook look;

  const _SpokenLine({required this.line, required this.look});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: look.color.withValues(alpha: 0.85),
          backgroundImage: look.portraitAsset == null ? null : AssetImage(look.portraitAsset!),
          child: look.portraitAsset == null ? Text(look.emoji, style: const TextStyle(fontSize: 24)) : null,
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    line.speaker,
                    style: TextStyle(color: look.color, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  if (line.note != null) ...[
                    const SizedBox(width: 6),
                    Text('· ${line.note}', style: const TextStyle(color: Colors.white38, fontSize: 12, fontStyle: FontStyle.italic)),
                  ],
                ],
              ),
              const SizedBox(height: 6),
              Text(line.text, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

class _DirectionLine extends StatelessWidget {
  final String text;

  const _DirectionLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white54, fontSize: 14, fontStyle: FontStyle.italic),
      ),
    );
  }
}
