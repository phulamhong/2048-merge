import Phaser from 'phaser';
import type { ChapterDef } from '../core/types';
import { CHAPTERS } from '../data/chapters';
import { LEVELS } from '../data/levels';
import { save } from '../services';
import { COLORS, starString, WIDTH } from '../view/theme';
import { button, panel, text } from '../view/ui';

const CARD_H = 470;

export class ChapterMapScene extends Phaser.Scene {
  constructor() {
    super('ChapterMap');
  }

  create(): void {
    this.cameras.main.setBackgroundColor(COLORS.bg);
    text(this, WIDTH / 2, 55, 'Nông Trại & Bếp Việt', 44, COLORS.text, { fontStyle: 'bold' });
    text(this, 40, 120, `🪙 ${save.data.coins}`, 30, COLORS.gold, { fontStyle: 'bold' }).setOrigin(0, 0.5);
    button(this, WIDTH - 130, 120, 220, 64, '🏡 Nông trại', () => this.scene.start('Farm'), { fontSize: 26 });

    CHAPTERS.forEach((c, i) => this.drawChapter(c, 175 + i * (CARD_H + 30)));
  }

  private drawChapter(chapter: ChapterDef, y: number): void {
    const x = 24;
    const w = WIDTH - 48;
    const unlocked = save.isChapterUnlocked(chapter.id);
    panel(this, x, y, w, CARD_H, unlocked ? COLORS.panel : 0xe9e1d0);
    text(this, WIDTH / 2, y + 40, chapter.name, 32, COLORS.text, { fontStyle: 'bold' });

    const r = chapter.recipe;
    text(this, WIDTH / 2, y + 90, `${r.verb} ${r.emoji} ${r.name} — cần:`, 24, COLORS.textMuted);
    const slot = w / r.ingredients.length;
    r.ingredients.forEach((ing, i) => {
      const have = save.isCooked(chapter.id) || (save.data.inventory[ing.id] ?? 0) > 0;
      const cx = x + slot * (i + 0.5);
      text(this, cx, y + 145, ing.emoji, 44).setAlpha(have ? 1 : 0.3);
      text(this, cx, y + 190, ing.name, 17, have ? COLORS.text : COLORS.textMuted, {
        wordWrap: { width: slot - 8 },
        align: 'center',
      });
    });

    const lw = (w - 40) / chapter.levelIds.length;
    chapter.levelIds.forEach((id, i) => {
      const level = LEVELS[id];
      const open = save.isLevelUnlocked(id);
      const stars = save.levelStars(id);
      const cx = x + 20 + lw * (i + 0.5);
      const label = open ? `${id}\n${stars > 0 ? starString(stars) : level.boss ? 'BOSS' : '·'}` : `🔒\n${id}`;
      button(this, cx, y + 290, lw - 14, 110, label, () => this.scene.start('Game', { levelId: id }), {
        disabled: !open,
        color: level.boss ? COLORS.warm : stars > 0 ? COLORS.accentDark : COLORS.accent,
        fontSize: 24,
      });
    });

    if (!unlocked) {
      text(this, WIDTH / 2, y + 405, '🔒 Hoàn thành chương trước để mở', 24, COLORS.textMuted);
    } else if (save.isCooked(chapter.id)) {
      text(this, WIDTH / 2, y + 405, `✓ Đã ${r.verb.toLowerCase()} ${r.name}`, 28, '#2a9d8f', { fontStyle: 'bold' });
    } else if (save.canCook(chapter.id)) {
      button(this, WIDTH / 2, y + 405, 420, 76, `${r.station} ${r.verb} ${r.name}!`, () =>
        this.scene.start('Recipe', { chapterId: chapter.id }), { color: COLORS.warm });
    } else {
      text(this, WIDTH / 2, y + 405, 'Qua mỗi màn để nhận 1 nguyên liệu', 22, COLORS.textMuted);
    }
  }
}
