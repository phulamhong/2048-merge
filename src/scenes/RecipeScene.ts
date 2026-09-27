import Phaser from 'phaser';
import type { ChapterDef } from '../core/types';
import { CHAPTERS } from '../data/chapters';
import { save } from '../services';
import { COLORS, WIDTH } from '../view/theme';
import { button, delay, text, tweenAsync } from '../view/ui';

export class RecipeScene extends Phaser.Scene {
  private chapter!: ChapterDef;

  constructor() {
    super('Recipe');
  }

  init(data: { chapterId: string }): void {
    this.chapter = CHAPTERS.find((c) => c.id === data.chapterId)!;
  }

  create(): void {
    this.cameras.main.setBackgroundColor(0xfdf0d5);
    const r = this.chapter.recipe;
    if (!save.cook(this.chapter.id)) {
      this.scene.start('ChapterMap');
      return;
    }
    text(this, WIDTH / 2, 90, `${r.verb} ${r.name}`, 46, COLORS.text, { fontStyle: 'bold' });
    void this.animate();
  }

  private async animate(): Promise<void> {
    const r = this.chapter.recipe;
    const station = text(this, WIDTH / 2, 640, r.station, 200);
    const cx = WIDTH / 2;
    const items = r.ingredients.map((ing, i) => {
      const angle = Math.PI + (Math.PI * (i + 0.5)) / r.ingredients.length;
      return text(this, cx + Math.cos(angle) * 270, 560 + Math.sin(angle) * 280, ing.emoji, 72);
    });
    await delay(this, 400);
    for (const item of items) {
      await tweenAsync(this, { targets: item, x: cx, y: 600, scale: 0.4, duration: 380, ease: 'Cubic.In' });
      item.destroy();
      void tweenAsync(this, { targets: station, scale: 1.08, duration: 90, yoyo: true });
    }
    await tweenAsync(this, { targets: station, angle: 8, duration: 70, yoyo: true, repeat: 5 });
    await tweenAsync(this, { targets: station, scale: 0, duration: 200, ease: 'Back.In' });

    const dish = text(this, cx, 620, r.emoji, 220).setScale(0);
    await tweenAsync(this, { targets: dish, scale: 1, duration: 450, ease: 'Back.Out' });
    text(this, cx, 820, `${r.name} đã hoàn thành!`, 38, COLORS.text, { fontStyle: 'bold' });
    const unlocks = this.chapter.unlocks.map((d) => `${d.emoji} ${d.name}`).join(', ');
    text(this, cx, 880, `Mở khoá ở nông trại: ${unlocks}`, 28, COLORS.textMuted);

    button(this, cx, 1030, 400, 84, '🏡 Xem nông trại', () => this.scene.start('Farm'));
    button(this, cx, 1140, 400, 72, 'Về bản đồ', () => this.scene.start('ChapterMap'), { color: COLORS.board });
  }
}
