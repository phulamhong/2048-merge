import Phaser from 'phaser';
import { FONT, textColorFor, type Look } from './theme';

export class TileView extends Phaser.GameObjects.Container {
  private readonly bg: Phaser.GameObjects.Graphics;
  private readonly emoji: Phaser.GameObjects.Text;
  private readonly label: Phaser.GameObjects.Text;
  private readonly glow: Phaser.GameObjects.Graphics;

  constructor(
    scene: Phaser.Scene,
    x: number,
    y: number,
    private readonly size: number,
    look: Look,
  ) {
    super(scene, x, y);
    this.glow = scene.add.graphics();
    this.bg = scene.add.graphics();
    this.emoji = scene.add
      .text(0, -size * 0.08, '', { fontFamily: FONT, fontSize: `${Math.round(size * 0.42)}px`, padding: { top: 8, bottom: 4 } })
      .setOrigin(0.5);
    this.label = scene.add
      .text(0, size * 0.3, '', { fontFamily: FONT, fontSize: `${Math.round(size * 0.14)}px`, fontStyle: 'bold' })
      .setOrigin(0.5);
    this.add([this.glow, this.bg, this.emoji, this.label]);
    this.setLook(look);
    scene.add.existing(this);
  }

  setLook(look: Look): void {
    const s = this.size * 0.92;
    this.bg.clear();
    this.bg.fillStyle(0x000000, 0.15).fillRoundedRect(-s / 2, -s / 2 + 4, s, s, s * 0.16);
    this.bg.fillStyle(look.color, 1).fillRoundedRect(-s / 2, -s / 2, s, s, s * 0.16);
    this.emoji.setText(look.emoji);
    this.label.setText(look.name).setColor(textColorFor(look.color));
  }

  /** Pulsing outline marking a tile that can be harvested right now. */
  setHarvestable(on: boolean): void {
    const s = this.size * 0.96;
    this.glow.clear();
    if (on) this.glow.lineStyle(6, 0x2a9d8f, 1).strokeRoundedRect(-s / 2, -s / 2, s, s, s * 0.18);
  }
}
