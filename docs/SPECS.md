# Nông Trại & Bếp Việt — Đặc tả kỹ thuật & gameplay

> Phiên bản: 0.1.0 (Phase 1 – MVP) · Cập nhật: 2026-09-27
> Tài liệu mô tả **đúng trạng thái code hiện tại**. Mọi con số (lượt, xác suất, thời gian animation) lấy trực tiếp từ source.

---

## Mục lục

1. [Tổng quan](#1-tổng-quan)
2. [Cài đặt & chạy](#2-cài-đặt--chạy)
3. [Luật chơi lõi](#3-luật-chơi-lõi)
4. [Ba kiểu màn](#4-ba-kiểu-màn)
5. [Chuỗi vật phẩm (Chain)](#5-chuỗi-vật-phẩm-chain)
6. [Danh sách màn chơi](#6-danh-sách-màn-chơi)
7. [Chương, công thức & mở khoá](#7-chương-công-thức--mở-khoá)
8. [Kinh tế](#8-kinh-tế)
9. [Lưu tiến trình](#9-lưu-tiến-trình)
10. [Mô hình độ khó & mô phỏng](#10-mô-hình-độ-khó--mô-phỏng)
11. [Kiến trúc kỹ thuật](#11-kiến-trúc-kỹ-thuật)
12. [Giao diện & animation](#12-giao-diện--animation)
13. [Kiểm thử](#13-kiểm-thử)
14. [Hướng dẫn thêm nội dung](#14-hướng-dẫn-thêm-nội-dung)
15. [Giới hạn hiện tại & lộ trình](#15-giới-hạn-hiện-tại--lộ-trình)

---

## 1. Tổng quan

| Hạng mục | Giá trị |
|---|---|
| Thể loại | Puzzle merge dựa trên 2048, chủ đề nông trại / ẩm thực Việt |
| Nền tảng | Web (trình duyệt desktop & mobile), màn hình dọc |
| Công nghệ | Phaser 3.90 · TypeScript 5 · Vite 6 · Vitest 3 · tsx (chạy mô phỏng) |
| Độ phân giải logic | 720 × 1280, `Scale.FIT` + căn giữa |
| Đồ hoạ | Tạm thời bằng emoji + khối màu bo góc, chưa có asset |
| Nội dung | 2 chương, 10 màn, 6 chuỗi vật phẩm |

**Ý tưởng cốt lõi:** giữ nguyên cơ chế của 2048 (vuốt, các ô trượt, hai ô cùng cấp va vào nhau thì gộp lên cấp kế tiếp) nhưng đổi mục tiêu thành *thu thập đủ vật phẩm theo yêu cầu*. Mỗi màn làm ra 1 nguyên liệu, gom đủ nguyên liệu của một chương thì nấu/dựng được món và mở khoá công trình ở Nông trại.

```
Chương (món ăn) ──► Màn (1 nguyên liệu) ──► Lưới 2048 (gom / tách)
      │                                             │
      └── đủ nguyên liệu → Nấu / Dựng → mở khoá công trình ◄── thu hoạch
```

---

## 2. Cài đặt & chạy

Yêu cầu Node.js ≥ 20 (máy dev đang dùng 24.19 LTS).

| Lệnh | Tác dụng |
|---|---|
| `npm install` | Cài dependencies |
| `npm run dev` | Dev server tại http://localhost:5173 |
| `npm test` | Chạy toàn bộ unit test (Vitest) |
| `npm run sim [số_ván]` | Mô phỏng độ khó, mặc định 300 ván/bot/màn |
| `npm run build` | Type-check (`tsc --noEmit`) + build production vào `dist/` |
| `npm run preview` | Chạy thử bản build |

Bản build là web tĩnh (`base: './'`), deploy được lên bất kỳ static host nào.

---

## 3. Luật chơi lõi

Nguồn: [src/core/GameSession.ts](../src/core/GameSession.ts), [src/core/Board.ts](../src/core/Board.ts), [src/core/resolveLine.ts](../src/core/resolveLine.ts)

### 3.1 Vuốt (Swipe)

- Điều khiển: vuốt trên màn hình (quãng di chuyển ≥ **36 px**), hoặc phím mũi tên / `W A S D`.
- Mọi ô trượt tới sát mép theo hướng vuốt.
- Hai ô **cùng tier** va vào nhau thì gộp thành 1 ô **tier + 1**.
- **Mỗi cặp chỉ gộp một lần mỗi lượt**, không gộp dây chuyền:
  - `[1,1,1,1]` → `[2,2]`
  - `[1,1,2]` → `[2,2]` (không thành 3)
  - `[2,2,2]` → `[3,2]` (cặp ở phía mép đích gộp trước)
- **Tier trần** (tier cuối của chuỗi) không gộp tiếp được.
- Nếu vuốt mà không ô nào thay đổi: **không tốn lượt**, không sinh ô mới.
- Vuốt làm lưới thay đổi: **tốn 1 lượt**.
- Không vuốt được khi đã hết lượt.

### 3.2 Chạm (Tap) — thứ tự ưu tiên

| Ưu tiên | Điều kiện | Kết quả | Tốn lượt |
|---|---|---|---|
| 1 | Ô khớp với một mục tiêu **chưa xong** (đúng tier, và đúng skin nếu mục tiêu yêu cầu) | **Thu hoạch**: ô biến mất, mục tiêu +1 | **Không** |
| 2 | Màn `split`/`mixed`, ô có tier > 1 và còn ô trống kề bên | **Tách**: thành 2 ô tier − 1 | 1 |
| 3 | Màn `merge` và ô không cần thu hoạch | Báo không hợp lệ (`notNeeded`), ô rung | Không |
| 3 | Ô tier 1 (ở màn tách) | Báo không hợp lệ (`tier1`), ô rung | Không |
| 3 | Không có ô trống kề bên | Báo không hợp lệ (`noSpace`), ô rung | Không |

- Ô thu hoạch được có **viền xanh ngọc** để người chơi nhận biết.
- Vẫn **thu hoạch được khi đã hết lượt**, miễn là trên bàn còn ô khớp mục tiêu.

### 3.3 Tách (Split)

- Ô tier *k* được tách thành 2 ô tier *k − 1*:
  - **Ô gốc giữ nguyên vị trí và uid**, chỉ đổi tier và gắn `bornFrom = 'split'`.
  - **Ô mới** xuất hiện ở ô trống kề bên đầu tiên theo thứ tự **phải → dưới → trái → trên**.
- Nếu tier *k − 1* có skin thì skin được random lại; nếu không thì bỏ skin.
- Luật gộp **vẫn áp dụng** ở màn tách. Vuốt ẩu có thể gộp lại chính hai miếng vừa tách, và người chơi phải tính toán để tránh.

### 3.4 Sinh ô mới (Spawn)

| Cấu hình (`LevelConfig.spawn`) | Thời điểm | Chi tiết |
|---|---|---|
| `perTurn` | Sau mỗi lần **vuốt có làm thay đổi lưới** | Sinh `perTurn` ô tier 1 vào các ô trống ngẫu nhiên |
| `doubleChance` | Cùng lúc với `perTurn` | Xác suất sinh thêm 1 ô tier 1 (chưa màn nào dùng) |
| `bigTileEvery: {turns, tier}` | Sau **mọi hành động tốn lượt** (vuốt hoặc tách), khi `movesUsed % turns === 0` | Sinh 1 ô tier lớn (chưa màn nào dùng) |

Ô ban đầu của màn:
- `initialTiles`: đặt đúng ô nếu có `row`/`col`, nếu không thì đặt ngẫu nhiên.
- `initialRandom` ô tier 1 ngẫu nhiên. Mặc định là **2** với `merge`/`mixed` và **0** với `split`.
- Hết ô trống thì bỏ qua lần sinh đó.

### 3.5 Tự thu hoạch khi gộp dư (Overflow) — chỉ ở màn `merge`

Một ô **vừa sinh ra từ phép gộp** bị tự thu hoạch thành xu khi thoả cả hai điều kiện:
1. Không khớp mục tiêu nào còn dang dở, **và**
2. `tier ≥ maxActiveTier`, tức là tier cao nhất mà các mục tiêu chưa xong còn cần.

Như vậy các trường hợp sau đều bị tự đổi thành xu:
- Gộp vượt cấp cần.
- Ra sai skin ở tier trần (ví dụ cần Hành lá nhưng ra Húng quế).
- Ô thuộc tier của mục tiêu đã hoàn thành, khi không còn mục tiêu nào cao hơn.

Mỗi ô tự thu hoạch được **5 × tier xu**.

Màn `split`/`mixed` **không** tự thu hoạch, để ô lớn vừa gộp lại vẫn có thể tách tiếp.

### 3.6 Thắng / Thua

Thứ tự kiểm tra sau mỗi hành động: **thắng trước**, sau đó mới đến sinh ô, rồi kiểm tra thua.

| Kết quả | Điều kiện |
|---|---|
| **Thắng** | Mọi mục tiêu đạt `progress ≥ target` |
| **Thua — hết lượt** (`outOfMoves`) | `movesLeft ≤ 0` **và** không còn ô nào thu hoạch được |
| **Thua — kẹt** (`stuck`) | (bàn trống hoàn toàn **hoặc** bàn đầy) **và** không có cặp kề nhau gộp được **và** không có ô nào thu hoạch được |

Khi bàn còn ít nhất 1 ô và 1 ô trống thì luôn có ít nhất một hướng vuốt hợp lệ, và nếu ô đó tách được thì cũng tách được. Vì vậy chỉ cần xét hai trạng thái biên là bàn trống hoàn toàn và bàn đầy.

### 3.7 Chấm sao

Tính theo tỉ lệ `movesLeft / moveLimit` lúc thắng. Ngưỡng mặc định `[0.15, 0.30]`, có thể đổi theo từng màn bằng `starThresholds`.

| Sao | Điều kiện |
|---|---|
| ★★★ | tỉ lệ ≥ 0.30 |
| ★★☆ | tỉ lệ ≥ 0.15 |
| ★☆☆ | hoàn thành |

---

## 4. Ba kiểu màn

| Kiểu (`mode`) | Nhãn UI | Bàn ban đầu | Sinh ô sau khi vuốt | Tách | Tự thu hoạch khi gộp dư |
|---|---|---|---|---|---|
| `merge` | Gom | 2 ô tier 1 | Có | Không | Có |
| `split` | Tách | Ô lớn (theo `initialTiles`) | Tuỳ cấu hình (hiện tại: không) | Có | Không |
| `mixed` | Gom + Tách | Ô lớn + 2 ô tier 1 | Có | Có | Không |

---

## 5. Chuỗi vật phẩm (Chain)

Nguồn: [src/data/chains.ts](../src/data/chains.ts)

### 5.1 `poultry` — Gia cầm
| Tier | Tên | Emoji |
|---|---|---|
| 1 | Trứng | 🥚 |
| 2 | Gà con | 🐣 |
| 3 | Gà giò | 🐥 |
| 4 | Gà mái | 🐔 |
| 5 | Gà trống | 🐓 |

### 5.2 `rice` — Lúa gạo
| Tier | Tên | Emoji |
|---|---|---|
| 1 | Hạt gạo | 🍚 |
| 2 | Bông lúa | 🌾 |
| 3 | Bao gạo | 🛍️ |
| 4 | Bột gạo | 🥣 |
| 5 | Bánh phở | 🍜 |

### 5.3 `herbs` — Rau thơm (tier trần có skin ngẫu nhiên)
| Tier | Tên | Emoji |
|---|---|---|
| 1 | Hạt giống | 🫘 |
| 2 | Mầm | 🌱 |
| 3 | Cây non | 🪴 |
| 4 | Bó rau → *skin* | 🥬 |

| Skin tier 4 | Emoji | Trọng số | Xác suất |
|---|---|---|---|
| Hành lá (`scallion`) | 🧅 | 50 | 50% |
| Ngò (`cilantro`) | 🌿 | 30 | 30% |
| Húng quế (`basil`) | 🍃 | 20 | 20% |

### 5.4 `beef` — Thịt bò (chuỗi dùng để tách)
| Tier | Tên | Emoji |
|---|---|---|
| 1 | Lát bò tái | 🥓 |
| 2 | Miếng thăn | 🥩 |
| 3 | Tảng thịt | 🍖 |
| 4 | Đùi bò | 🍗 |
| 5 | Con bò | 🐄 |

### 5.5 `broth` — Nước dùng
| Tier | Tên | Emoji |
|---|---|---|
| 1 | Xương | 🦴 |
| 2 | Nồi xương | 🥘 |
| 3 | Nồi ninh | 🍲 |
| 4 | Nồi nước dùng | 🫕 |
| 5 | Thùng lớn | 🛢️ |

### 5.6 `spice` — Gia vị (tier trần có skin ngẫu nhiên)
| Tier | Tên | Emoji |
|---|---|---|
| 1 | Hạt | 🌰 |
| 2 | Mầm | 🌱 |
| 3 | Cây gia vị | 🌳 |
| 4 | Gia vị → *skin* | 🧂 |

| Skin tier 4 | Emoji | Trọng số | Xác suất |
|---|---|---|---|
| Quế (`cinnamon`) | 🪵 | 40 | 40% |
| Hồi (`anise`) | ⭐ | 35 | 35% |
| Thảo quả (`cardamom`) | 🫒 | 25 | 25% |

Mỗi tier (và mỗi skin) có một màu nền riêng, đậm dần theo tier. Chữ trên ô tự đổi đen hoặc trắng theo độ sáng của màu nền.

---

## 6. Danh sách màn chơi

Nguồn: [src/data/levels.ts](../src/data/levels.ts)

### 6.1 Chương 1 — Trại gà nhỏ (hướng dẫn, chỉ gom)

| Màn | Tên | Kiểu | Lưới | Mục tiêu | Lượt | Nguyên liệu | Dạy gì |
|---|---|---|---|---|---|---|---|
| 1-1 | Ổ trứng đầu tiên | merge | 4×4 | 2 Gà giò (t3) | 16 | Ổ trứng | Vuốt để gộp |
| 1-2 | Đàn gà giò | merge | 4×4 | 3 Gà giò (t3) | 22 | Đàn gà giò | Thu hoạch không tốn lượt |
| 1-3 | Gà mái đẻ | merge | 4×4 | 2 Gà giò (t3) + 1 Gà mái (t4) | 29 | Gà mái đẻ | Chọn thời điểm thu hoạch khi có 2 mục tiêu |
| 1-4 | Cặp gà mái | merge | 4×4 | 2 Gà mái (t4) | 29 | Cặp gà mái | Xây tier cao |
| 1-5 | Gà trống gáy **(Boss)** | merge | 4×4 | 1 Gà trống (t5) + 2 Gà giò (t3) | 36 | Gà trống | Tổng hợp |

### 6.2 Chương 2 — Tô phở bò (giới thiệu Tách & Kết hợp)

| Màn | Tên | Kiểu | Chain | Lưới | Bàn ban đầu | Mục tiêu | Lượt | Nguyên liệu |
|---|---|---|---|---|---|---|---|---|
| 2-1 | Bánh phở | merge | rice | 4×4 | 2 ô t1 | 2 Bánh phở (t5) | 45 | Bánh phở |
| 2-2 | Rau thơm | merge | herbs | 4×4 | 2 ô t1 | 2 Hành lá + 1 Ngò (t4, theo skin) | 36 | Rau thơm |
| 2-3 | Thịt bò tái | **split** | beef | 4×4 | 1 Con bò (t5) tại (1,1) | 8 Lát bò tái (t1) | 13 | Thịt bò tái |
| 2-4 | Nước dùng | **mixed** | broth | 4×4 | 1 Thùng lớn (t5) tại (0,0) + 2 ô t1 | 3 Nồi nước dùng (t4) | 16 | Nước dùng |
| 2-5 | Gia vị **(Boss)** | merge | spice | **5×5** | 2 ô t1 | 1 Quế + 1 Hồi (t4, theo skin) | 27 | Gia vị |

Mọi màn đều dùng `spawn.perTurn = 1`, riêng 2-3 là `0`.

Các màn có dòng gợi ý (`hint`) hiển thị dưới bàn cờ: 1-1, 1-2, 1-3, 2-2, 2-3, 2-4. Màn không có `hint` hiển thị câu hướng dẫn mặc định theo kiểu màn.

---

## 7. Chương, công thức & mở khoá

Nguồn: [src/data/chapters.ts](../src/data/chapters.ts)

| Chương | Công thức | Hành động | Dụng cụ (animation) | Nguyên liệu cần (mỗi thứ ×1) | Mở khoá |
|---|---|---|---|---|---|
| `ch1` Trại gà nhỏ | 🛖 Chuồng gà | Dựng | 🧱 | Ổ trứng · Đàn gà giò · Gà mái đẻ · Cặp gà mái · Gà trống | 🛖 Chuồng gà |
| `ch2` Tô phở bò | 🍜 Tô phở bò | Nấu | 🍲 | Bánh phở · Rau thơm · Thịt bò tái · Nước dùng · Gia vị | 🏮 Quán phở |

**Quy tắc mở khoá:**
- Chương đầu tiên luôn mở. Các chương sau mở khi chương liền trước đã được **nấu/dựng**.
- Màn đầu của một chương mở khi chương đó mở. Các màn sau mở khi màn liền trước đã qua (≥ 1 sao).
- Nút **Nấu/Dựng** sáng khi chương chưa được làm món và kho có đủ mọi nguyên liệu (mỗi thứ ≥ 1).
- Khi nấu/dựng:
  - Trừ mỗi nguyên liệu 1 đơn vị.
  - Đánh dấu chương đã hoàn thành (`cooked`).
  - Thêm công trình (`decor`) vào Nông trại.
  - Mỗi chương chỉ làm món **một lần**.

---

## 8. Kinh tế

| Nguồn thu | Số lượng |
|---|---|
| Tự thu hoạch khi gộp dư | 5 × tier xu mỗi ô (cộng dồn trong màn) |
| Sao | 10 xu cho **mỗi sao vượt kỷ lục cũ** của màn |
| Nguyên liệu | +1 **chỉ ở lần qua màn đầu tiên**; chơi lại chỉ để lấy thêm sao |

Ví dụ: qua màn lần đầu được 1★ thì nhận 10 xu. Chơi lại được 3★ thì nhận thêm 20 xu. Chơi lại lần nữa được 2★ thì không nhận thêm gì.

Hiện tại xu mới chỉ để hiển thị (bản đồ, Nông trại, HUD). Cửa hàng và vật phẩm hỗ trợ thuộc Phase 2.

---

## 9. Lưu tiến trình

Nguồn: [src/core/SaveManager.ts](../src/core/SaveManager.ts), [src/services.ts](../src/services.ts)

- **Khoá lưu:** `localStorage["farm2048.save.v1"]`.
- **Thời điểm ghi:** ghi ngay lập tức mỗi khi thắng màn, nấu món hoặc reset.
- **Dự phòng:**
  - localStorage bị chặn (chế độ riêng tư, iframe, ...): tự chuyển sang lưu trong bộ nhớ, mất khi tải lại trang.
  - Dữ liệu hỏng hoặc `version` không khớp: dùng save rỗng.
  - Ghi lỗi (ví dụ đầy bộ nhớ): bỏ qua, tiến trình vẫn còn trong phiên hiện tại.

```ts
interface SaveData {
  version: 1;
  levels: Record<string, { stars: number }>; // kỷ lục sao, >0 nghĩa là đã qua
  inventory: Record<string, number>;         // id nguyên liệu → số lượng
  cooked: string[];                          // id chương đã nấu/dựng
  decor: string[];                           // id công trình đã mở
  coins: number;
}
```

API `SaveManager` gồm:
- `isChapterUnlocked`, `isLevelUnlocked`, `isLevelCleared`, `levelStars`, `isCooked`
- `recordWin(levelId, stars, levelCoins)` → `{ firstClear, coinsEarned }`
- `canCook`, `cook`, `reset`

---

## 10. Mô hình độ khó & mô phỏng

### 10.1 Công thức ước lượng ban đầu

- **Gom:** tạo 1 ô tier *t* cần 2^(t−1) ô tier 1, mỗi lần vuốt sinh 1 ô.
  `minMoves = Σ (target × 2^(tier−1)) ÷ p`, với *p* là xác suất ra đúng skin (bằng 1 nếu mục tiêu không yêu cầu skin).
- **Tách:** tách ô tier *T* hết xuống tier *t* cần 2^(T−t) − 1 lần tách, cộng thêm vài lần vuốt để dọn chỗ.
- **Giới hạn lượt khởi điểm:** `moveLimit = ceil(minMoves × slack)`, với slack 1.8 ở Chương 1 và 1.6 ở Chương 2. Màn Boss trừ thêm 0.15.

**Nhận xét rút ra từ mô phỏng:** với các màn có skin, công thức ÷p ước tính dư nhiều so với số lượt thực tế. Lý do là bó ra sai loại vẫn có thể phục vụ mục tiêu còn lại, còn bó dư bị đổi thành xu và giải phóng chỗ ngay. Vì vậy **giới hạn lượt cuối cùng được chỉnh theo kết quả mô phỏng**, công thức chỉ dùng làm điểm xuất phát.

### 10.2 Công cụ mô phỏng — [sim/simulate.ts](../sim/simulate.ts)

Script chạy trực tiếp logic trong `src/core` (không qua Phaser) với seed cố định 1..N nên kết quả lặp lại được.

- **Bot ngẫu nhiên:**
  1. Thu hoạch mọi ô thu hoạch được.
  2. Chọn ngẫu nhiên một hành động hợp lệ: 4 hướng vuốt, và thêm các lần tách nếu màn cho phép.
- **Bot tham lam (nhìn trước 1 bước):**
  1. Thu hoạch mọi ô thu hoạch được.
  2. Thử từng hành động trên một bản sao của ván (`GameSession.clone()`), thu hoạch hết trên bản sao, rồi chấm điểm và chọn hành động điểm cao nhất.
  3. Hàm điểm:
     - Thắng: +10⁶. Thua: −10⁶.
     - +100 × Σ(tiến độ × 2^(tier−1)) cho các mục tiêu.
     - Với mỗi ô: +tier² nếu tier ≤ tier cần; −2·3^(tier − tier cần) nếu vượt. Mức phạt theo lũy thừa 3 làm cho mỗi lần tách luôn tốt hơn giữ nguyên.
     - +3 × số ô trống.

### 10.3 Kết quả hiện tại (300 ván/bot/màn)

| Màn | Kiểu | Lượt | minMoves (công thức) | Bot ngẫu nhiên thắng | Bot tham lam thắng | Lượt TB khi thắng | Sao TB |
|---|---|---|---|---|---|---|---|
| 1-1 | merge | 16 | 8 | 99% | 100% | 9.1 | 2.96 |
| 1-2 | merge | 22 | 12 | 100% | 100% | 13.1 | 2.95 |
| 1-3 | merge | 29 | 16 | 93% | 100% | 19.9 | 2.62 |
| 1-4 | merge | 29 | 16 | 92% | 99% | 20.3 | 2.57 |
| 1-5 (Boss) | merge | 36 | 24 | 39% | 70% | 31.3 | 1.42 |
| 2-1 | merge | 45 | 32 | 39% | 78% | 40.2 | 1.32 |
| 2-2 | merge | 36 | 59 | 20% | 78% | 30.1 | 1.60 |
| 2-3 | split | 13 | – | 0% | 100% | 9.0 | 3.00 |
| 2-4 | mixed | 16 | – | 14% | 86% | 12.4 | 2.10 |
| 2-5 (Boss) | merge | 27 | 43 | 21% | 70% | 21.8 | 1.73 |

**Đọc kết quả:**
- **Hình răng cưa:** Chương 1 dễ, độ khó tăng dần tới Boss 1-5. Chương 2 giữ mức trung bình rồi tăng lên ở Boss 2-5.
- **Màn 2-3 (Tách):** không có yếu tố ngẫu nhiên, nên người chơi có kế hoạch luôn thắng (9 lượt, 3★), còn đi ngẫu nhiên thì luôn thua. Độ khó của màn này nằm ở tư duy, không phải may rủi.
- **Tham chiếu tỉ lệ thắng:** bot tham lam mạnh hơn người mới chơi lần đầu, còn bot ngẫu nhiên là mức sàn. Tỉ lệ thắng thực tế của người chơi dự kiến nằm giữa hai cột này.

**Quy trình chỉnh độ khó:** sửa `moveLimit` trong `levels.ts` → chạy `npm run sim` → so với mục tiêu (bot tham lam thắng khoảng 100% ở Chương 1, khoảng 80% ở Chương 2, khoảng 70% ở Boss).

---

## 11. Kiến trúc kỹ thuật

### 11.1 Nguyên tắc

1. **`src/core` không import Phaser.** Toàn bộ luật chơi là TypeScript thuần, nên unit test được và script mô phỏng dùng lại được chính code đó.
2. **Model đi trước, view diễn lại sau.** Mỗi hành động cập nhật model đồng bộ rồi trả về danh sách `GameEvent`. View chỉ phát lại danh sách đó bằng tween, không tự suy luận luật chơi.
3. **Nội dung là dữ liệu.** Thêm chain, màn hay chương mới chỉ cần sửa `src/data`, không sửa core.
4. **RNG có seed** (mulberry32) dùng chung cho sinh ô, chọn ô trống và chọn skin, nên test và mô phỏng lặp lại được.

### 11.2 Cấu trúc thư mục

```
2048-merge/
├─ index.html                 # container #game, nền, chặn cuộn/zoom trên mobile
├─ package.json · tsconfig.json · vite.config.ts (kiêm cấu hình Vitest)
├─ src/
│  ├─ main.ts                 # khởi tạo Phaser.Game, đăng ký scene
│  ├─ services.ts             # instance SaveManager dùng chung (localStorage hoặc bộ nhớ)
│  ├─ core/                   # LOGIC THUẦN — không Phaser
│  │  ├─ types.ts             # mọi kiểu dữ liệu & GameEvent
│  │  ├─ rng.ts               # Rng: next / int / pick / weighted / clone
│  │  ├─ resolveLine.ts       # gộp 1 hàng theo luật 2048 (generic)
│  │  ├─ Board.ts             # lưới, slide, split, spawn, clone
│  │  ├─ ObjectiveTracker.ts  # tiến độ mục tiêu, match, maxActiveTier
│  │  ├─ GameSession.ts       # 1 ván chơi: swipe/tap, overflow, thắng/thua, sao
│  │  └─ SaveManager.ts       # tiến trình, mở khoá, kho, nấu món
│  ├─ data/
│  │  ├─ chains.ts            # 6 chain + CHAINS
│  │  ├─ levels.ts            # 10 màn + LEVEL_LIST / LEVELS
│  │  └─ chapters.ts          # 2 chương + công thức + công trình
│  ├─ view/
│  │  ├─ theme.ts             # kích thước, màu, font, lookOf(), starString()
│  │  ├─ ui.ts                # text, panel, button, tweenAsync, delay
│  │  ├─ TileView.ts          # 1 ô: nền bo góc + emoji + tên + viền thu hoạch
│  │  └─ BoardView.ts         # vẽ lưới, map uid→TileView, phát lại event
│  └─ scenes/
│     ├─ ChapterMapScene.ts   # 'ChapterMap' — màn hình chính
│     ├─ GameScene.ts         # 'Game' — chơi màn + HUD + bảng kết quả
│     ├─ RecipeScene.ts       # 'Recipe' — animation nấu/dựng
│     └─ FarmScene.ts         # 'Farm' — công trình đã mở khoá
├─ tests/
│  ├─ core/ helpers.ts · resolveLine.test.ts · session.test.ts · save.test.ts
│  └─ data/content.test.ts
├─ sim/simulate.ts
└─ docs/SPECS.md
```

### 11.3 Kiểu dữ liệu chính ([src/core/types.ts](../src/core/types.ts))

```ts
type Direction = 'up' | 'down' | 'left' | 'right';
type LevelMode = 'merge' | 'split' | 'mixed';

interface SkinDef  { id; name; emoji; color: number; weight: number }
interface TierDef  { tier; id; name; emoji; color: number; skins?: SkinDef[] }
interface ChainDef { id; name; tiers: TierDef[] }            // tier kế tiếp = phần tử kế trong mảng

interface ObjectiveDef { tier: number; skinId?: string; target: number }

interface LevelConfig {
  id; name; chainId; mode: LevelMode;
  grid: { rows; cols };
  initialTiles?: { tier; row?; col? }[];
  initialRandom?: number;                                  // mặc định 2 (merge/mixed) / 0 (split)
  spawn: { perTurn: number; doubleChance?: number; bigTileEvery?: { turns; tier } };
  objectives: ObjectiveDef[];
  moveLimit: number;
  starThresholds?: [number, number];                       // mặc định [0.15, 0.30]
  producesIngredient: string;
  boss?: boolean;
  hint?: string;
}

interface RecipeDef  { id; name; verb; emoji; station; ingredients: IngredientDef[] }
interface ChapterDef { id; name; recipe: RecipeDef; levelIds: string[]; unlocks: DecorDef[] }

interface Tile { uid: number; tier; skinId?; row; col; bornFrom: 'initial' | 'spawn' | 'merge' | 'split' }
```

### 11.4 Sự kiện (GameEvent)

| Event | Trường | Phát ra khi |
|---|---|---|
| `move` | `uid, to` | Ô trượt sang ô khác |
| `merge` | `a, b, result` | Hai ô gộp; `result` là ô mới (uid mới) |
| `spawn` | `tile` | Sinh ô mới |
| `split` | `kept, spawned` | Tách ô; `kept` giữ uid cũ |
| `harvest` | `tile, auto, objectiveIndex, coins` | Thu hoạch thủ công (`auto=false`) hoặc tự đổi thành xu khi gộp dư (`auto=true`) |
| `invalid` | `uid, reason` | Chạm không hợp lệ: `noSpace` / `tier1` / `notNeeded` |
| `noChange` | – | Vuốt nhưng lưới không đổi |

### 11.5 Luồng một lượt chơi

```
Input (vuốt / chạm / phím)
  → GameSession.swipe(dir) | tap(row, col)        // cập nhật model, trả GameEvent[]
      swipe: slide → +1 lượt → tự thu hoạch overflow → thắng? → spawn → thua?
      tap:   thu hoạch (0 lượt) | tách (+1 lượt, sinh ô lớn định kỳ) | invalid
  → GameScene.run(events)                          // khoá input (busy)
  → BoardView.play(events)                         // 4 pha animation
  → refreshHud()                                   // lượt, tiến độ mục tiêu, xu
  → đang chơi ? mở khoá input : sau 350 ms hiện bảng kết quả
       thắng → SaveManager.recordWin() → Màn tiếp / Nấu món / Về bản đồ
       thua  → Chơi lại / Về bản đồ
```

### 11.6 Thuật toán slide

1. Dựng các "line" theo hướng vuốt. Mỗi line là danh sách vị trí ô, sắp **từ mép đích trở về**:
   - `left`: mỗi hàng, cột 0 → n.
   - `right`: mỗi hàng, cột n → 0.
   - `up` / `down`: làm tương tự theo cột.
2. `resolveLine` lọc bỏ ô trống rồi duyệt tuần tự. Nếu ô đang xét và ô kế tiếp gộp được (`canMerge`: cùng tier và tier < tier trần) thì tạo slot gộp và **nhảy qua cả cặp**; ngược lại giữ nguyên ô. Kết quả là danh sách slot đã dồn về đầu line.
3. Board ghi các slot trở lại lưới:
   - Slot giữ nguyên ô: ô đổi chỗ thì phát `move`.
   - Slot gộp: tạo ô tier+1 với `bornFrom='merge'` (random skin nếu tier đó có skin) và phát `merge`.
4. `changed = có move || có merge`.

---

## 12. Giao diện & animation

### 12.1 Màn hình

| Scene | Nội dung chính |
|---|---|
| **ChapterMap** | Tiêu đề, số xu, nút 🏡 Nông trại. Mỗi chương là một thẻ gồm: tên chương; công thức và dãy nguyên liệu (mờ khi chưa có); 5 nút màn hiển thị sao (màn Boss màu cam, màn khoá có 🔒); trạng thái cuối thẻ (khoá / gợi ý / nút Nấu / ✓ Đã nấu). |
| **Game** | Header gồm nút ‹, `id · tên`, `Kiểu · tên món` và hộp **Lượt** (đỏ khi ≤ 5). Panel **Mục tiêu** hiện emoji, tên, `x/y` hoặc `✓`, cùng số 🪙 trong màn. Bàn cờ 640 px bắt đầu ở y = 300. Dòng gợi ý và nút **↺ Chơi lại** ở dưới. Bảng kết quả hiện dạng modal. |
| **Recipe** | Tự gọi `save.cook()` (nếu không nấu được thì quay về bản đồ). Nguyên liệu xếp hình vòng cung, lần lượt bay vào dụng cụ (🍲 / 🧱), dụng cụ rung rồi biến mất, món ăn nảy ra. Sau đó hiện dòng "Mở khoá ở nông trại" cùng nút Xem nông trại / Về bản đồ. |
| **Farm** | Nền trời và cỏ, xu, số món đã làm. Mỗi công trình nằm trên một ô đất: đã mở thì nhún nhảy, chưa mở thì hiện ❔ kèm "Làm … để mở". |

### 12.2 Điều khiển

| Thao tác | Nhận diện |
|---|---|
| Vuốt | `pointerup` cách `pointerdown` ≥ 36 px, lấy trục có độ lệch lớn hơn làm hướng. Bỏ qua các cú vuốt bắt đầu ở vùng header (y < 280) mà không nằm trên bàn. |
| Chạm | Di chuyển < 36 px và điểm nhả nằm trong bàn cờ. Toạ độ được quy đổi thẳng sang ô (hit-test theo lưới, không theo sprite, nên chạm đúng cả khi ô đang tween). |
| Bàn phím | Mũi tên và W/A/S/D |
| Khoá input | Mọi thao tác bị bỏ qua khi animation đang chạy hoặc khi bảng kết quả đang mở |

### 12.3 Pha animation ([src/view/BoardView.ts](../src/view/BoardView.ts))

Các pha chạy tuần tự, trong mỗi pha các tween chạy song song và được chờ bằng `Promise.all`.

| Pha | Event | Hiệu ứng | Thời gian |
|---|---|---|---|
| 1 | `move`, `merge` | Ô trượt tới ô đích (`Quad.Out`). Hai ô nguồn của phép gộp cùng trượt vào vị trí kết quả. | 110 ms |
| 2 | `merge` | Xoá 2 view nguồn, tạo view kết quả, phóng to lên 1.18 rồi thu lại | 140 ms |
| 2 | `split` | Ô gốc đổi hình và nảy nhẹ. Ô mới xuất hiện ở ô gốc với scale 0.6 rồi trượt sang ô kề (`Back.Out`). | 180 ms |
| 2 | `invalid` | Rung ngang ±8 px, 3 lần | ~270 ms |
| 3 | `harvest` | Bay về icon mục tiêu (hoặc về số xu nếu là tự thu hoạch), thu nhỏ còn 0.35 và mờ dần (`Cubic.In`) | 380 ms |
| 4 | `spawn` | Phóng từ 0 lên 1 (`Back.Out`) | 150 ms |
| cuối | – | Cập nhật lại viền "thu hoạch được" cho toàn bàn | – |

---

## 13. Kiểm thử

`npm test` gồm **37 test, tất cả đều pass**.

| File | Nội dung kiểm tra |
|---|---|
| [tests/core/resolveLine.test.ts](../tests/core/resolveLine.test.ts) | `[1,1,1,1]→[2,2]`; không gộp dây chuyền; dồn qua khoảng trống; cặp ở mép đích gộp trước; tier trần không gộp |
| [tests/core/session.test.ts](../tests/core/session.test.ts) | Trượt và gộp theo cả 4 hướng; vuốt không đổi lưới thì không tốn lượt và không sinh ô; sinh ô sau vuốt; tự đổi xu khi gộp dư ở màn merge nhưng giữ lại ở màn split; thu hoạch không tốn lượt và thắng; từ chối chạm ô không cần; tách ưu tiên ô bên phải, chuyển hướng khác khi bị chặn, báo `noSpace` khi bị vây; thu hoạch được ưu tiên hơn tách; mục tiêu theo skin; thua do kẹt; thua do hết lượt; vẫn thu hoạch được khi 0 lượt; ngưỡng sao; `clone()` độc lập với bản gốc |
| [tests/core/save.test.ts](../tests/core/save.test.ts) | Mở khoá màn tuần tự; nguyên liệu chỉ cấp lần đầu, giữ kỷ lục sao, tính xu; nấu món mở chương sau và thêm công trình; ghi/đọc lại save; save hỏng thì dùng mặc định |
| [tests/data/content.test.ts](../tests/data/content.test.ts) | Mọi màn tham chiếu chain có tồn tại, tier và skin của mục tiêu hợp lệ, `initialTiles` nằm trong lưới và không trùng ô; mọi nguyên liệu trong công thức đều có màn tạo ra |

**Kiểm tra khác:**
- `npm run build`: `tsc --noEmit` không lỗi và Vite build thành công (bundle khoảng 1.5 MB, khoảng 351 KB sau gzip, phần lớn là Phaser).
- `npm run sim`: kết quả như mục 10.3.
- **Chưa làm:** chơi thủ công trên trình duyệt để kiểm tra giao diện, animation và thao tác trên điện thoại thật.

---

## 14. Hướng dẫn thêm nội dung

| Muốn thêm | Làm gì | Có sửa core không |
|---|---|---|
| **Chain mới** | Khai báo `ChainDef` trong `src/data/chains.ts` và thêm vào mảng tạo `CHAINS`. Thêm `skins` ở tier nào muốn có biến thể ngẫu nhiên. | Không |
| **Màn mới** | Thêm `LevelConfig` vào `chapter1`/`chapter2` hoặc một mảng chương mới trong `levels.ts`, sau đó chạy `npm run sim` để chỉnh `moveLimit`. | Không |
| **Chương mới** | Thêm `ChapterDef` vào `CHAPTERS` với `levelIds`, `recipe.ingredients` (id phải khớp `producesIngredient` của các màn) và `unlocks`. | Không |
| **Biến thể sinh ô** | Dùng `spawn.doubleChance` hoặc `spawn.bigTileEvery` | Không |
| **Ngưỡng sao riêng** | `starThresholds: [x, y]` | Không |

Sau khi thêm, chạy `npm test`: `content.test.ts` sẽ bắt các lỗi tham chiếu sai, như sai chain, sai tier/skin, ô ban đầu nằm ngoài lưới hoặc nguyên liệu không có màn nào tạo ra.

**Lưu ý bố cục:**
- Màn hình bản đồ hiện đủ chỗ cho **2 thẻ chương**. Từ chương 3 trở đi cần thêm cuộn.
- Panel mục tiêu chia đều theo chiều ngang, hiển thị tốt với tối đa khoảng 3 mục tiêu.

---

## 15. Giới hạn hiện tại & lộ trình

### Khác biệt so với plan ban đầu
- HUD được vẽ trực tiếp trong `GameScene`, không tách thành `HUDScene` chạy song song.
- Chưa có Boot/Preload và chưa sinh texture. Đồ hoạ tạm dùng emoji và Graphics vẽ trực tiếp.
- Nông trại là một màn hình riêng. Chưa có dải "Farm" nằm dưới bàn cờ để vật phẩm bay vào: hiện tại vật phẩm thu hoạch bay về icon mục tiêu trên HUD.
- Chưa có EventBus. Chỉ có một luồng dữ liệu (session → view) nên chưa cần.

### Hạn chế đã biết
- Emoji hiển thị khác nhau giữa các hệ điều hành và font; trên máy thiếu font emoji có thể hiện ô vuông.
- Bản đồ chương chưa cuộn được.
- Chưa có âm thanh, rung (haptics) hay hoàn tác.
- Kết quả mô phỏng dựa trên bot, chưa có dữ liệu từ người chơi thật.

### Phase 2 — Cân bằng & nội dung
- Vật cản, mỗi chương giới thiệu một loại:
  - **Đá** (Ch.3 Cơm gà Hội An): ô bị chặn, cắt line khi trượt.
  - **Cỏ dại** (Ch.4 Bánh mì): cứ N lượt lan sang một ô trống kề bên; gộp ở ô cạnh nó để dọn.
  - **Băng** (Ch.5 Bún chả): ô bị đóng băng không trượt được cho tới khi có phép gộp ở ô kề bên.
- Chương 3 dùng lại chuỗi gà theo kiểu Tách, để nối Nông trại với Bếp.
- Dùng xu để mua vật phẩm hỗ trợ: Hoàn tác, Xẻng xoá 1 ô, +5 lượt.
- Bản đồ chương cuộn được.

### Phase 3 — Hoàn thiện
- Art thật: giữ quy ước "mỗi tier/skin một hình", thay emoji mà không phải sửa logic.
- Âm thanh và nhạc, animation nấu món phong phú hơn.
- Nông trại cho phép tự sắp xếp công trình.
