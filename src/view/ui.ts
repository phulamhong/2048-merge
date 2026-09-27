import Phaser from 'phaser';
import { COLORS, FONT } from './theme';

export function text(
  scene: Phaser.Scene,
  x: number,
  y: number,
  content: string,
  size: number,
  color: string = COLORS.text,
  style: Phaser.Types.GameObjects.Text.TextStyle = {},
): Phaser.GameObjects.Text {
  return scene.add
    .text(x, y, content, { fontFamily: FONT, fontSize: `${size}px`, color, padding: { top: 6, bottom: 4 }, ...style })
    .setOrigin(0.5);
}

export function panel(scene: Phaser.Scene, x: number, y: number, w: number, h: number, color = COLORS.panel, radius = 24) {
  const g = scene.add.graphics();
  g.fillStyle(0x000000, 0.12).fillRoundedRect(x + 4, y + 6, w, h, radius);
  g.fillStyle(color, 1).fillRoundedRect(x, y, w, h, radius);
  g.lineStyle(3, COLORS.panelEdge, 1).strokeRoundedRect(x, y, w, h, radius);
  return g;
}

export interface ButtonOptions {
  color?: number;
  textColor?: string;
  fontSize?: number;
  disabled?: boolean;
}

/** Rounded button centred at (x, y). */
export function button(
  scene: Phaser.Scene,
  x: number,
  y: number,
  w: number,
  h: number,
  label: string,
  onClick: () => void,
  opts: ButtonOptions = {},
): Phaser.GameObjects.Container {
  const color = opts.disabled ? COLORS.disabled : (opts.color ?? COLORS.accent);
  const bg = scene.add.graphics();
  bg.fillStyle(0x000000, 0.18).fillRoundedRect(-w / 2, -h / 2 + 5, w, h, 18);
  bg.fillStyle(color, 1).fillRoundedRect(-w / 2, -h / 2, w, h, 18);
  const t = text(scene, 0, 0, label, opts.fontSize ?? 28, opts.textColor ?? COLORS.textLight, { fontStyle: 'bold' });
  const c = scene.add.container(x, y, [bg, t]).setSize(w, h);
  if (!opts.disabled) {
    c.setInteractive({ useHandCursor: true });
    c.on('pointerdown', () => c.setScale(0.95));
    c.on('pointerout', () => c.setScale(1));
    c.on('pointerup', () => {
      c.setScale(1);
      onClick();
    });
  }
  return c;
}

export function tweenAsync(scene: Phaser.Scene, config: Phaser.Types.Tweens.TweenBuilderConfig): Promise<void> {
  return new Promise((resolve) => {
    scene.tweens.add({ ...config, onComplete: () => resolve() });
  });
}

export function delay(scene: Phaser.Scene, ms: number): Promise<void> {
  return new Promise((resolve) => scene.time.delayedCall(ms, resolve));
}
