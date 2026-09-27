import { mkdirSync, writeFileSync } from 'node:fs';
import { COLORS } from '../src/view/theme';
import { encodePng } from './png';

const hex = (color: number): [number, number, number] => [(color >> 16) & 0xff, (color >> 8) & 0xff, color & 0xff];
const BG = hex(COLORS.warm);
const BOWL = hex(COLORS.panel);
const BROTH = hex(COLORS.board);
const HERB = hex(COLORS.accent);

/** Signed distance-ish membership test for a square with rounded corners. */
function insideRoundedSquare(x: number, y: number, size: number, radius: number): boolean {
  const dx = Math.max(radius - x, x - (size - radius), 0);
  const dy = Math.max(radius - y, y - (size - radius), 0);
  return dx * dx + dy * dy <= radius * radius;
}

function inEllipse(x: number, y: number, cx: number, cy: number, rx: number, ry: number): boolean {
  const nx = (x - cx) / rx;
  const ny = (y - cy) / ry;
  return nx * nx + ny * ny <= 1;
}

/** Placeholder "bowl of phở" icon, drawn from flat shapes so no font/emoji rendering is needed. */
function drawIcon(size: number, edgeToEdge: boolean): Buffer {
  const data = new Uint8Array(size * size * 4);
  const cornerRadius = size * 0.22;
  const herbOffsets = [-0.16, 0, 0.16];

  for (let y = 0; y < size; y++) {
    for (let x = 0; x < size; x++) {
      const i = (y * size + x) * 4;
      const inRounded = edgeToEdge || insideRoundedSquare(x + 0.5, y + 0.5, size, cornerRadius);
      let [r, g, b] = BG;
      let a = 255;
      if (!inRounded) {
        a = 0;
      } else if (inEllipse(x, y, size * 0.5, size * 0.6, size * 0.36, size * 0.24)) {
        [r, g, b] = BOWL;
        if (inEllipse(x, y, size * 0.5, size * 0.56, size * 0.3, size * 0.14)) {
          [r, g, b] = BROTH;
          for (const off of herbOffsets) {
            if (inEllipse(x, y, size * (0.5 + off), size * 0.47, size * 0.045, size * 0.045)) [r, g, b] = HERB;
          }
        }
      }
      data[i] = r;
      data[i + 1] = g;
      data[i + 2] = b;
      data[i + 3] = a;
    }
  }
  return encodePng(size, size, data);
}

mkdirSync('public/icons', { recursive: true });
writeFileSync('public/icons/icon-192.png', drawIcon(192, false));
writeFileSync('public/icons/icon-512.png', drawIcon(512, false));
writeFileSync('public/icons/icon-512-maskable.png', drawIcon(512, true));
writeFileSync('public/icons/apple-touch-icon.png', drawIcon(180, true));
console.log('Đã tạo icon trong public/icons/');
