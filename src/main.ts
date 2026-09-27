import Phaser from 'phaser';
import { ChapterMapScene } from './scenes/ChapterMapScene';
import { FarmScene } from './scenes/FarmScene';
import { GameScene } from './scenes/GameScene';
import { RecipeScene } from './scenes/RecipeScene';
import { COLORS, HEIGHT, WIDTH } from './view/theme';

new Phaser.Game({
  type: Phaser.AUTO,
  parent: 'game',
  width: WIDTH,
  height: HEIGHT,
  backgroundColor: COLORS.bg,
  scale: { mode: Phaser.Scale.FIT, autoCenter: Phaser.Scale.CENTER_BOTH },
  scene: [ChapterMapScene, GameScene, RecipeScene, FarmScene],
});
