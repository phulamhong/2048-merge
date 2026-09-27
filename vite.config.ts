import basicSsl from '@vitejs/plugin-basic-ssl';
import { defineConfig } from 'vitest/config';
import { VitePWA } from 'vite-plugin-pwa';

const icons = [
  { src: 'icons/icon-192.png', sizes: '192x192', type: 'image/png', purpose: 'any' as const },
  { src: 'icons/icon-512.png', sizes: '512x512', type: 'image/png', purpose: 'any' as const },
  { src: 'icons/icon-512-maskable.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' as const },
];

export default defineConfig({
  base: './',
  server: { port: 5173, host: true },
  plugins: [
    // Self-signed HTTPS for the dev server: Android requires a secure context
    // to offer "Install app" for a page served from a LAN IP (localhost is exempt).
    basicSsl(),
    VitePWA({
      registerType: 'autoUpdate',
      devOptions: { enabled: true, type: 'module' },
      includeAssets: ['icons/apple-touch-icon.png'],
      manifest: {
        name: 'Nông Trại & Bếp Việt',
        short_name: 'Bếp Việt',
        description: 'Game merge kiểu 2048 chủ đề nông trại & ẩm thực Việt Nam',
        start_url: '.',
        id: '.',
        display: 'standalone',
        orientation: 'portrait',
        background_color: '#f3e9d2',
        theme_color: '#e76f51',
        icons,
      },
    }),
  ],
  test: {
    include: ['tests/**/*.test.ts'],
  },
});
