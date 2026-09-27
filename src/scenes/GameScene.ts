import Phaser from 'phaser';
import { GameSession } from '../core/GameSession';
import type { ChapterDef, Direction, GameEvent, LevelConfig } from '../core/types';
import { CHAINS } from '../data/chains';
import { CHAPTERS } from '../data/chapters';
import { LEVELS } from '../data/levels';
import { save } from '../services';
import { BoardView } from '../view/BoardView';
import { COLORS, HEIGHT, objectiveLook, starString, WIDTH } from '../view/theme';
import { button, panel, text } from '../view/ui';

const SWIPE_MIN_PX = 36;
const MODE_LABEL = { merge: 'Gom', split: 'Tách', mixed: 'Gom + Tách' } as const;
const KEY_DIRS: Record<string, Direction> = {
  ArrowUp: 'up', ArrowDown: 'down', ArrowLeft: 'left', ArrowRight: 'right',
  w: 'up', s: 'down', a: 'left', d: 'right',
};

interface ObjectiveUi {
  x: number;
  y: number;
  count: Phaser.GameObjects.Text;
}

export class GameScene extends Phaser.Scene {
  private level!: LevelConfig;
  private chapter!: ChapterDef;
  private session!: GameSession;
  private boardView!: BoardView;
  private busy = false;
  private pointerStart: { x: number; y: number } | null = null;
  private movesText!: Phaser.GameObjects.Text;
  private coinsText!: Phaser.GameObjects.Text;
  private objectiveUi: ObjectiveUi[] = [];

  constructor() {
    super('Game');
  }

  init(data: { levelId: string }): void {
    this.level = LEVELS[data.levelId];
    this.chapter = CHAPTERS.find((c) => c.levelIds.includes(this.level.id))!;
    this.busy = false;
    this.pointerStart = null;
    this.objectiveUi = [];
  }

  create(): void {
    this.cameras.main.setBackgroundColor(COLORS.bg);
    this.session = new GameSession(this.level, CHAINS[this.level.chainId]);
    this.createHeader();
    this.createObjectives();

    const boardSize = 640;
    this.boardView = new BoardView(this, this.session, (WIDTH - boardSize) / 2, 300, boardSize);

    const hint =
      this.level.hint ??
      (this.session.canSplit ? 'Vuốt để gộp · Chạm để thu hoạch hoặc tách' : 'Vuốt để gộp · Chạm ô viền xanh để thu hoạch');
    text(this, WIDTH / 2, 1030, hint, 24, COLORS.textMuted, { wordWrap: { width: 640 }, align: 'center' });

    button(this, WIDTH / 2, 1170, 260, 76, '↺ Chơi lại', () => this.scene.restart({ levelId: this.level.id }), {
      color: COLORS.warm,
    });

    this.input.on('pointerdown', (p: Phaser.Input.Pointer) => (this.pointerStart = { x: p.x, y: p.y }));
    this.input.on('pointerup', (p: Phaser.Input.Pointer) => this.onPointerUp(p));
    this.input.keyboard?.on('keydown', (e: KeyboardEvent) => {
      const dir = KEY_DIRS[e.key];
      if (dir) this.run(this.session.swipe(dir));
    });
    this.refreshHud();
  }

  private createHeader(): void {
    button(this, 70, 60, 110, 64, '‹', () => this.scene.start('ChapterMap'), { color: COLORS.board, fontSize: 40 });
    text(this, WIDTH / 2, 42, `${this.level.id} · ${this.level.name}`, 30, COLORS.text, { fontStyle: 'bold' });
    text(this, WIDTH / 2, 84, `Kiểu: ${MODE_LABEL[this.level.mode]} · ${this.chapter.recipe.name}`, 22, COLORS.textMuted);
    panel(this, WIDTH - 130, 20, 110, 80, COLORS.panel, 18);
    text(this, WIDTH - 75, 42, 'Lượt', 20, COLORS.textMuted);
    this.movesText = text(this, WIDTH - 75, 74, '', 32, COLORS.text, { fontStyle: 'bold' });
  }

  private createObjectives(): void {
    panel(this, 20, 115, WIDTH - 40, 150);
    text(this, 60, 140, 'Mục tiêu', 20, COLORS.textMuted).setOrigin(0, 0.5);
    this.coinsText = text(this, WIDTH - 60, 140, '', 22, COLORS.gold, { fontStyle: 'bold' }).setOrigin(1, 0.5);
    const objs = this.level.objectives;
    const slot = (WIDTH - 40) / objs.length;
    objs.forEach((o, i) => {
      const look = objectiveLook(this.session.chain, o);
      const x = 20 + slot * (i + 0.5);
      text(this, x - 50, 200, look.emoji, 52);
      text(this, x + 30, 185, look.name, 22, COLORS.text, { fontStyle: 'bold' });
      const count = text(this, x + 30, 220, '', 26, COLORS.text);
      this.objectiveUi.push({ x: x - 50, y: 200, count });
    });
  }

  private refreshHud(): void {
    const left = this.session.movesLeft;
    this.movesText.setText(String(left)).setColor(left <= 5 ? '#d62828' : COLORS.text);
    this.coinsText.setText(`🪙 ${this.session.coins}`);
    this.level.objectives.forEach((o, i) => {
      const p = this.session.tracker.progress[i];
      this.objectiveUi[i].count.setText(p >= o.target ? `✓ ${o.target}/${o.target}` : `${p}/${o.target}`);
      this.objectiveUi[i].count.setColor(p >= o.target ? '#2a9d8f' : COLORS.text);
    });
  }

  private onPointerUp(p: Phaser.Input.Pointer): void {
    const start = this.pointerStart;
    this.pointerStart = null;
    if (!start) return;
    const dx = p.x - start.x;
    const dy = p.y - start.y;
    if (Math.max(Math.abs(dx), Math.abs(dy)) >= SWIPE_MIN_PX) {
      if (!this.boardView.cellAt(start.x, start.y) && start.y < 280) return;
      const dir: Direction = Math.abs(dx) > Math.abs(dy) ? (dx > 0 ? 'right' : 'left') : dy > 0 ? 'down' : 'up';
      this.run(this.session.swipe(dir));
      return;
    }
    const cell = this.boardView.cellAt(p.x, p.y);
    if (cell) this.run(this.session.tap(cell.row, cell.col));
  }

  /** Session state is already updated; replay the events, then react to the outcome. */
  private run(events: GameEvent[]): void {
    if (this.busy || events.length === 0) return;
    this.busy = true;
    this.boardView
      .play(events, (e) => (e.auto || e.objectiveIndex === null ? { x: WIDTH - 90, y: 140 } : this.objectiveUi[e.objectiveIndex]))
      .then(() => {
        this.refreshHud();
        if (this.session.status === 'playing') {
          this.busy = false;
        } else {
          this.time.delayedCall(350, () => this.showResult());
        }
      });
  }

  private showResult(): void {
    const won = this.session.status === 'won';
    const overlay = this.add.container(0, 0).setDepth(200);
    const shade = this.add.rectangle(0, 0, WIDTH, HEIGHT, 0x000000, 0.55).setOrigin(0).setInteractive();
    overlay.add(shade);
    const pw = 580;
    const ph = 640;
    const px = (WIDTH - pw) / 2;
    const py = 300;
    overlay.add(panel(this, px, py, pw, ph, COLORS.panel, 32));

    const add = <T extends Phaser.GameObjects.GameObject>(o: T) => (overlay.add(o), o);
    if (won) {
      const stars = this.session.stars;
      const { firstClear, coinsEarned } = save.recordWin(this.level.id, stars, this.session.coins);
      add(text(this, WIDTH / 2, py + 70, 'Hoàn thành!', 48, COLORS.text, { fontStyle: 'bold' }));
      add(text(this, WIDTH / 2, py + 150, starString(stars), 72, COLORS.gold));
      add(text(this, WIDTH / 2, py + 230, `Còn dư ${this.session.movesLeft} lượt`, 26, COLORS.textMuted));
      const ing = this.chapter.recipe.ingredients.find((i) => i.id === this.level.producesIngredient);
      if (firstClear && ing) add(text(this, WIDTH / 2, py + 290, `Nhận nguyên liệu: ${ing.emoji} ${ing.name}`, 28));
      add(text(this, WIDTH / 2, py + 340, `+${coinsEarned} 🪙`, 28, COLORS.gold, { fontStyle: 'bold' }));

      const idx = this.chapter.levelIds.indexOf(this.level.id);
      const nextId = this.chapter.levelIds[idx + 1];
      if (save.canCook(this.chapter.id)) {
        const r = this.chapter.recipe;
        add(button(this, WIDTH / 2, py + 450, 440, 84, `${r.station} ${r.verb} ${r.name}!`, () =>
          this.scene.start('Recipe', { chapterId: this.chapter.id }), { color: COLORS.warm }));
      } else if (nextId) {
        add(button(this, WIDTH / 2, py + 450, 400, 84, 'Màn tiếp ›', () => this.scene.restart({ levelId: nextId })));
      }
    } else {
      const reason = this.session.loseReason === 'outOfMoves' ? 'Hết lượt đi' : 'Bàn cờ bị kẹt, không còn nước đi';
      add(text(this, WIDTH / 2, py + 90, 'Chưa đạt!', 48, COLORS.text, { fontStyle: 'bold' }));
      add(text(this, WIDTH / 2, py + 180, reason, 28, COLORS.textMuted));
      add(button(this, WIDTH / 2, py + 450, 400, 84, '↺ Chơi lại', () => this.scene.restart({ levelId: this.level.id }), {
        color: COLORS.warm,
      }));
    }
    add(button(this, WIDTH / 2, py + 560, 400, 72, 'Về bản đồ', () => this.scene.start('ChapterMap'), {
      color: COLORS.board,
    }));
    overlay.setAlpha(0);
    this.tweens.add({ targets: overlay, alpha: 1, duration: 200 });
  }
}
