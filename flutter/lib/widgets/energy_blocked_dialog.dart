import 'package:flutter/material.dart';

import '../core/save_manager.dart';
import '../game/farm_merge_game.dart' show energyRefillGemCost;

/// Shown instead of the level board whenever energy is empty — previously
/// the player could still land on the (unplayable) board with only a small
/// in-canvas HUD label explaining why swipes did nothing. This is a real
/// Flutter dialog with real buttons so there's no way to end up stuck with
/// no visible way forward.
class EnergyBlockedDialog extends StatefulWidget {
  final SaveManager saveManager;
  const EnergyBlockedDialog({super.key, required this.saveManager});

  @override
  State<EnergyBlockedDialog> createState() => _EnergyBlockedDialogState();
}

class _EnergyBlockedDialogState extends State<EnergyBlockedDialog> {
  @override
  Widget build(BuildContext context) {
    final save = widget.saveManager;
    final wait = save.timeUntilNextEnergy;
    final minutes = (wait.inSeconds / 60).ceil();
    final canRefill = save.data.gems >= energyRefillGemCost;

    return Dialog(
      backgroundColor: const Color(0xFF3A4A2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⚡', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            const Text('Hết năng lượng', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Năng lượng hồi tự nhiên sau $minutes phút, hoặc nạp đầy ngay bằng kim cương.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: canRefill ? const Color(0xFF6A994E) : Colors.white24,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: !canRefill
                    ? null
                    : () {
                        save.refillEnergyWithGems(gemCost: energyRefillGemCost);
                        Navigator.of(context).pop(true);
                      },
                child: Text(
                  'Nạp đầy ngay ($energyRefillGemCost 💎)',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white38), padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Về trang chủ', style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
