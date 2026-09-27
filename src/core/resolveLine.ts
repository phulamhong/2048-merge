export type LineSlot<T> = { tile: T } | { merge: [T, T] };

/**
 * Compacts one line toward index 0 using 2048 rules. Each pair merges at most
 * once per move because a merged pair is consumed together (no chain merges).
 */
export function resolveLine<T>(line: readonly (T | null)[], canMerge: (a: T, b: T) => boolean): LineSlot<T>[] {
  const tiles = line.filter((t): t is T => t !== null);
  const slots: LineSlot<T>[] = [];
  let i = 0;
  while (i < tiles.length) {
    const a = tiles[i];
    const b = tiles[i + 1];
    if (b !== undefined && canMerge(a, b)) {
      slots.push({ merge: [a, b] });
      i += 2;
    } else {
      slots.push({ tile: a });
      i += 1;
    }
  }
  return slots;
}
