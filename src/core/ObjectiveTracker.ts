import type { ObjectiveDef, Tile } from './types';

export class ObjectiveTracker {
  readonly progress: number[];

  constructor(readonly objectives: readonly ObjectiveDef[], progress?: number[]) {
    this.progress = progress ? [...progress] : objectives.map(() => 0);
  }

  /** Index of the first unfinished objective this tile satisfies, or null. */
  match(tile: Pick<Tile, 'tier' | 'skinId'>): number | null {
    const idx = this.objectives.findIndex(
      (o, i) =>
        this.progress[i] < o.target && o.tier === tile.tier && (!o.skinId || o.skinId === tile.skinId),
    );
    return idx === -1 ? null : idx;
  }

  add(index: number): void {
    this.progress[index]++;
  }

  /** Highest tier still needed by an unfinished objective (0 when all done). */
  maxActiveTier(): number {
    return this.objectives.reduce((m, o, i) => (this.progress[i] < o.target ? Math.max(m, o.tier) : m), 0);
  }

  isComplete(): boolean {
    return this.objectives.every((o, i) => this.progress[i] >= o.target);
  }

  clone(): ObjectiveTracker {
    return new ObjectiveTracker(this.objectives, this.progress);
  }
}
