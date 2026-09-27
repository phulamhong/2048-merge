import Phaser from 'phaser';
import { CHAPTERS } from '../data/chapters';
import { save } from '../services';
import { COLORS, HEIGHT, WIDTH } from '../view/theme';
import { button, text } from '../view/ui';

export class FarmScene extends Phaser.Scene {
  constructor() {
    super('Farm');
  }

  create(): void {
    this.cameras.main.setBackgroundColor(0xa7c957);
    const g = this.add.graphics();
    g.fillStyle(0x8ecae6, 1).fillRect(0, 0, WIDTH, 260);
    g.fillStyle(0x6a994e, 1).fillRect(0, 260, WIDTH, HEIGHT - 260);
    text(this, WIDTH - 110, 80, '☀️', 90);
    text(this, WIDTH / 2, 70, 'Nông trại của bạn', 42, COLORS.text, { fontStyle: 'bold' });
    text(this, WIDTH / 2, 130, `🪙 ${save.data.coins} · Món đã làm: ${save.data.cooked.length}/${CHAPTERS.length}`, 26, COLORS.text);

    const decor = CHAPTERS.flatMap((c) => c.unlocks.map((d) => ({ ...d, recipe: c.recipe })));
    const cols = 2;
    const cellW = WIDTH / cols;
    decor.forEach((d, i) => {
      const x = cellW * ((i % cols) + 0.5);
      const y = 420 + Math.floor(i / cols) * 300;
      const owned = save.data.decor.includes(d.id);
      const plot = this.add.graphics();
      plot.fillStyle(owned ? 0xdda15e : 0x7a9e4f, 1).fillEllipse(x, y + 80, 260, 90);
      const icon = text(this, x, y, owned ? d.emoji : '❔', 130).setAlpha(owned ? 1 : 0.5);
      text(this, x, y + 150, owned ? d.name : `Làm ${d.recipe.name} để mở`, 26, owned ? COLORS.textLight : '#e9f5db', {
        fontStyle: owned ? 'bold' : 'normal',
      });
      if (owned) this.tweens.add({ targets: icon, y: y - 10, duration: 900, yoyo: true, repeat: -1, ease: 'Sine.InOut' });
    });

    button(this, WIDTH / 2, HEIGHT - 110, 400, 80, '‹ Về bản đồ', () => this.scene.start('ChapterMap'), {
      color: COLORS.board,
    });
  }
}
