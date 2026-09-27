import Phaser from 'phaser';
import type { GameSession } from '../core/GameSession';
import type { GameEvent, Pos, Tile } from '../core/types';
import { COLORS, tileLook } from './theme';
import { TileView } from './TileView';
import { tweenAsync } from './ui';

const MOVE_MS = 110;
const POP_MS = 140;
const FLY_MS = 380;

export type FlyTarget = (event: Extract<GameEvent, { type: 'harvest' }>) => { x: number; y: number };

/**
 * Renders the board and replays GameEvents as tweens. It never decides game
 * rules; the session has already applied every event before play() runs.
 */
export class BoardView {
  readonly cellSize: number;
  private readonly views = new Map<number, TileView>();

  constructor(
    private readonly scene: Phaser.Scene,
    private readonly session: GameSession,
    readonly x: number,
    readonly y: number,
    readonly size: number,
  ) {
    const { rows, cols } = session.level.grid;
    this.cellSize = size / Math.max(rows, cols);
    const g = scene.add.graphics();
    const pad = 12;
    g.fillStyle(COLORS.board, 1).fillRoundedRect(x - pad, y - pad, cols * this.cellSize + pad * 2, rows * this.cellSize + pad * 2, 28);
    for (let r = 0; r < rows; r++) {
      for (let c = 0; c < cols; c++) {
        const s = this.cellSize * 0.92;
        const p = this.cellCenter({ row: r, col: c });
        g.fillStyle(COLORS.cell, 1).fillRoundedRect(p.x - s / 2, p.y - s / 2, s, s, s * 0.16);
      }
    }
    for (const t of session.board.tiles()) this.createView(t);
    this.refreshHighlights();
  }

  cellCenter(p: Pos): { x: number; y: number } {
    return { x: this.x + (p.col + 0.5) * this.cellSize, y: this.y + (p.row + 0.5) * this.cellSize };
  }

  cellAt(px: number, py: number): Pos | null {
    const col = Math.floor((px - this.x) / this.cellSize);
    const row = Math.floor((py - this.y) / this.cellSize);
    const { rows, cols } = this.session.level.grid;
    return row >= 0 && row < rows && col >= 0 && col < cols ? { row, col } : null;
  }

  async play(events: GameEvent[], flyTarget: FlyTarget): Promise<void> {
    const moves: Promise<void>[] = [];
    for (const e of events) {
      if (e.type === 'move') moves.push(this.tweenTo(e.uid, e.to));
      if (e.type === 'merge') {
        moves.push(this.tweenTo(e.a, e.result), this.tweenTo(e.b, e.result));
      }
    }
    await Promise.all(moves);

    const pops: Promise<void>[] = [];
    for (const e of events) {
      if (e.type === 'merge') {
        this.destroyView(e.a);
        this.destroyView(e.b);
        pops.push(this.pop(this.createView(e.result)));
      } else if (e.type === 'split') {
        pops.push(this.playSplit(e.kept, e.spawned));
      } else if (e.type === 'invalid') {
        pops.push(this.shake(e.uid));
      }
    }
    await Promise.all(pops);

    const flights: Promise<void>[] = [];
    for (const e of events) {
      if (e.type === 'harvest') flights.push(this.flyAway(e.tile.uid, flyTarget(e)));
    }
    await Promise.all(flights);

    const spawns: Promise<void>[] = [];
    for (const e of events) {
      if (e.type === 'spawn') {
        const v = this.createView(e.tile).setScale(0);
        spawns.push(tweenAsync(this.scene, { targets: v, scale: 1, duration: 150, ease: 'Back.Out' }));
      }
    }
    await Promise.all(spawns);
    this.refreshHighlights();
  }

  refreshHighlights(): void {
    for (const t of this.session.board.tiles()) {
      this.views.get(t.uid)?.setHarvestable(this.session.status === 'playing' && this.session.isHarvestable(t));
    }
  }

  private createView(t: Tile): TileView {
    const p = this.cellCenter(t);
    const v = new TileView(this.scene, p.x, p.y, this.cellSize, tileLook(this.session.chain, t));
    this.views.set(t.uid, v);
    return v;
  }

  private destroyView(uid: number): void {
    this.views.get(uid)?.destroy();
    this.views.delete(uid);
  }

  private tweenTo(uid: number, to: Pos): Promise<void> {
    const v = this.views.get(uid);
    if (!v) return Promise.resolve();
    const p = this.cellCenter(to);
    return tweenAsync(this.scene, { targets: v, x: p.x, y: p.y, duration: MOVE_MS, ease: 'Quad.Out' });
  }

  private pop(v: TileView): Promise<void> {
    return tweenAsync(this.scene, { targets: v, scale: 1.18, duration: POP_MS / 2, yoyo: true, ease: 'Quad.Out' });
  }

  private async playSplit(kept: Tile, spawned: Tile): Promise<void> {
    const keptView = this.views.get(kept.uid);
    keptView?.setLook(tileLook(this.session.chain, kept));
    const start = this.cellCenter(kept);
    const child = this.createView(spawned).setPosition(start.x, start.y).setScale(0.6);
    const end = this.cellCenter(spawned);
    await Promise.all([
      keptView ? this.pop(keptView) : Promise.resolve(),
      tweenAsync(this.scene, { targets: child, x: end.x, y: end.y, scale: 1, duration: 180, ease: 'Back.Out' }),
    ]);
  }

  private shake(uid: number): Promise<void> {
    const v = this.views.get(uid);
    if (!v) return Promise.resolve();
    const x = v.x;
    return tweenAsync(this.scene, { targets: v, x: x + 8, duration: 45, yoyo: true, repeat: 2 }).then(
      () => void v.setX(x),
    );
  }

  private flyAway(uid: number, target: { x: number; y: number }): Promise<void> {
    const v = this.views.get(uid);
    if (!v) return Promise.resolve();
    this.views.delete(uid);
    v.setDepth(100);
    return tweenAsync(this.scene, {
      targets: v,
      x: target.x,
      y: target.y,
      scale: 0.35,
      alpha: 0.4,
      duration: FLY_MS,
      ease: 'Cubic.In',
    }).then(() => v.destroy());
  }
}
