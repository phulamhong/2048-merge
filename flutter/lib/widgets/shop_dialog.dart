import 'package:flutter/material.dart';

import '../core/save_manager.dart';
import '../game/farm_merge_game.dart' show energyRefillGemCost;

class _Package {
  final String label;
  final void Function(SaveManager save) grant;
  const _Package(this.label, this.grant);
}

final _packages = <_Package>[
  _Package('+100 🪙', (save) => save.addCoins(100)),
  _Package('+500 🪙', (save) => save.addCoins(500)),
  _Package('+50 💎', (save) => save.addGems(50)),
  _Package('+200 💎', (save) => save.addGems(200)),
];

/// Simulated in-app purchase — grants coins/gems instantly, no real payment.
/// For testing the economy only; when a real store (App Store/Play Billing)
/// is wired in, its purchase-success handler should call
/// [SaveManager.addCoins]/[SaveManager.addGems] after verifying the receipt,
/// replacing the direct calls this dialog's buttons make.
class ShopDialog extends StatefulWidget {
  final SaveManager saveManager;
  const ShopDialog({super.key, required this.saveManager});

  @override
  State<ShopDialog> createState() => _ShopDialogState();
}

class _ShopDialogState extends State<ShopDialog> {
  @override
  Widget build(BuildContext context) {
    final save = widget.saveManager;
    return Dialog(
      backgroundColor: const Color(0xFF3A4A2C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Cửa hàng', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text(
              '(Giả lập để test — chưa nối thanh toán thật)',
              style: TextStyle(color: Colors.white38, fontSize: 12, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Text('🪙 ${save.data.coins}', style: const TextStyle(color: Color(0xFFE9C46A), fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                Text('💎 ${save.data.gems}', style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                Text('⚡ ${save.energy}/${save.energyMax}', style: const TextStyle(color: Colors.white70, fontSize: 16)),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: save.data.gems >= energyRefillGemCost ? const Color(0xFF6A994E) : Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: save.energy >= save.energyMax || save.data.gems < energyRefillGemCost
                    ? null
                    : () => setState(() => save.refillEnergyWithGems(gemCost: energyRefillGemCost)),
                child: Text(
                  '⚡ Nạp đầy năng lượng ($energyRefillGemCost 💎)',
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 18),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.4,
              children: [
                for (final pkg in _packages)
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6A994E)),
                    onPressed: () => setState(() => pkg.grant(save)),
                    child: Text(pkg.label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white38), padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Đóng', style: TextStyle(color: Colors.white, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
