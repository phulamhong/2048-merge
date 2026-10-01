# Object Art — Prompts thay emoji trong game

Danh sách toàn bộ emoji đang dùng trong `flutter/lib/` và prompt để tạo icon thay
thế. Nguồn kiểm kê: `data/chains.dart`, `data/chapters.dart`, `data/properties.dart`,
`game/*`, `screens/*`, `widgets/*` (quét ngày 2026-09-29).

Nhân vật (đã có ảnh) xem `CHARACTER_ART_PROMPTS.md`. File này chỉ gồm **vật thể,
icon UI và trang trí**.

## 1. Style chung (dán vào đầu MỌI prompt)

```
Art style: warm semi-realistic mobile-game cartoon icon, soft cel-shading, clean
bold dark-brown outlines (#4A3220, ~4px at 512px), gentle top-left light with
soft rim light, slightly glossy highlights, rich saturated but warm colors,
similar visual quality to Hay Day / Merge Dragons item art. Vietnamese
countryside (miền Tây) farm theme.
Palette anchors: leaf green #6A994E, deep green #386641, mustard #E9C46A,
terracotta #BC6C25, warm cream #FAF3E0, sky blue #8DB9D9.

Composition: ONE single object, centered, fills ~80% of the frame, slight 3/4
top-down view (like a game item icon), square 1:1 canvas, 1024x1024.
CRITICAL — transparent PNG background (or flat solid green-screen #00FF00 if
transparency is unsupported). No ground, no floor, no cast shadow, no scenery, no
hand, no text, no watermark, no logo, no frame/border, no extra objects.
```

Sau khi sinh: tách nền, crop sát, resize **256x256** (game hiển thị ô ~60–110 px,
256 đủ cho màn hình 3x), lưu PNG.

## 2. Quy ước tiến hoá trong chuỗi (giữ nhất quán)

- Cùng một chuỗi (chain) phải **cùng góc nhìn, cùng độ dày viền, cùng bảng màu**.
- Mỗi tier lớn hơn tier trước: **to hơn, chi tiết hơn, "đầy đặn / giá trị" hơn**
  (nhiều hơn số lượng, thêm phụ kiện) nhưng vẫn nhận ra cùng "họ".
- Màu nền ô (`color` trong `chains.dart`) sẽ nằm phía sau icon → icon không tự vẽ
  nền, không vẽ bóng.
- Thêm vào prompt mỗi tier câu: `Part of an evolution series "<CHUỖI>", stage N of M — must look like the same family as the other stages.`

## 3. Đường dẫn & đặt tên file

```
flutter/assets/objects/<chain_id>/<tier_id>.png        # vd poultry/egg.png
flutter/assets/objects/<chain_id>/<tier_id>_<skin>.png # vd herbs/bunch_cilantro.png
flutter/assets/objects/ui/<name>.png                   # tiền tệ, nav, trạng thái
flutter/assets/objects/chapters/<chapter_id>.png       # icon món / chương
flutter/assets/objects/decor/<decor_id>.png            # công trình mở khoá
flutter/assets/objects/obstacles/<name>.png
```

Nhớ khai báo `flutter/assets/objects/` (và các thư mục con) trong `pubspec.yaml`,
rồi thay `emoji` bằng `assetPath` trong `TierDef`/`SkinDef`/`IngredientDef`/...

---

## 4. CHUỖI TIẾN HOÁ (vật thể trên bàn chơi) — 54 ảnh

Ghi chú: mỗi khối ở dưới là **phần "Object:"** ghép sau Style chung.

### 4.1 Gia cầm `poultry` (5 tier) — 🥚🐣🐥🐔🐓

| # | id | Emoji cũ | Prompt phần Object |
|---|---|---|---|
| 1 | `egg` | 🥚 | `Object: a single plump cream-colored chicken egg with a subtle warm speckle, resting upright, tiny soft highlight. Stage 1 of 5 in the series "poultry".` |
| 2 | `chick` | 🐣 | `Object: a newly hatched fluffy yellow baby chick emerging from a cracked eggshell, only head and upper body visible above the broken shell halves, big shiny eyes, tiny orange beak. Stage 2 of 5, same family as the egg.` |
| 3 | `young` | 🐥 | `Object: a young fluffy yellow juvenile chick (gà giò), standing, round body, small wings, a few tan feathers starting to grow, cute curious face. Stage 3 of 5.` |
| 4 | `hen` | 🐔 | `Object: a plump white-and-tan laying hen (gà mái), calm expression, small red comb, rounded body, feathers neatly detailed, standing. Stage 4 of 5.` |
| 5 | `rooster` | 🐓 | `Object: a proud Vietnamese rooster (gà trống), tall upright pose, large bright red comb and wattle, glossy iridescent tail feathers in orange, green and dark brown, golden neck feathers, confident chest-out stance. Stage 5 of 5 — the grandest of the series.` |

### 4.2 Lúa gạo `rice` (5 tier) — 🍚🌾🛍️🥣🍜

| # | id | Emoji cũ | Object |
|---|---|---|---|
| 1 | `grain` | 🍚 | `Object: a small pile of about 12 glossy raw white rice grains (hạt gạo), with 3 grains slightly in front, tiny sparkle. Stage 1 of 5 in "rice".` |
| 2 | `stalk` | 🌾 | `Object: a single golden ripe rice stalk (bông lúa) bending gracefully with heavy grain heads, a few green leaves at the base. Stage 2 of 5.` |
| 3 | `sack` | 🛍️ | `Object: a burlap rice sack (bao gạo), tied at the top with rope, a little spilled rice at the opening, rustic stitched texture. Stage 3 of 5.` |
| 4 | `flour` | 🥣 | `Object: a rustic ceramic bowl filled with fine white rice flour (bột gạo) heaped in a soft mound with a wooden scoop resting in it, a light dusting of flour on the rim. Stage 4 of 5.` |
| 5 | `noodle` | 🍜 | `Object: a steaming bowl of Vietnamese phở noodles — flat white rice noodles, a few green herb leaves on top, gentle rising steam curls, blue-and-white ceramic bowl. Stage 5 of 5 — the finished dish.` |

### 4.3 Rau thơm `herbs` (4 tier + 3 skin) — 🫘🌱🪴🥬 (+🧅🌿🍃)

| # | id | Emoji cũ | Object |
|---|---|---|---|
| 1 | `seed` | 🫘 | `Object: three small light-green herb seeds on a tiny pile of dark soil, one seed with a hint of a crack. Stage 1 of 4 in "herbs".` |
| 2 | `sprout` | 🌱 | `Object: a tiny bright green sprout with two round seed leaves emerging from a small mound of soil. Stage 2 of 4.` |
| 3 | `plant` | 🪴 | `Object: a young leafy herb plant in a small terracotta pot, several fresh green leaves. Stage 3 of 4.` |
| 4 | `bunch` (mặc định) | 🥬 | `Object: a fresh bunch of mixed Vietnamese herbs tied with twine, leaves fanned out, dewdrops. Stage 4 of 4.` |
| 4a | `bunch_scallion` | 🧅 | `Object: a bunch of scallions (hành lá) tied with twine, long green stalks and white bulb ends with tiny roots. Variant of stage 4 "bunch", same twine-tied composition.` |
| 4b | `bunch_cilantro` | 🌿 | `Object: a bunch of cilantro (ngò rí) tied with twine, delicate frilly leaves. Variant of stage 4 "bunch", same composition.` |
| 4c | `bunch_basil` | 🍃 | `Object: a bunch of Thai basil (húng quế) tied with twine, glossy leaves with purple-tinged stems. Variant of stage 4 "bunch", same composition.` |

### 4.4 Thịt bò `beef` (5 tier, chuỗi tách) — 🥓🥩🍖🍗🐄

| # | id | Emoji cũ | Object |
|---|---|---|---|
| 1 | `slice` | 🥓 | `Object: 3 thin slices of rare beef (bò tái) fanned out, pink with fine marbling, a fresh glossy look. Stage 1 of 5 in "beef".` |
| 2 | `loin` | 🥩 | `Object: a thick-cut beef loin steak (miếng thăn), rich red with a white fat edge, fine marbling. Stage 2 of 5.` |
| 3 | `chunk` | 🍖 | `Object: a large raw beef chunk (tảng thịt) with a small bone visible, deep red and marbled. Stage 3 of 5.` |
| 4 | `leg` | 🍗 | `Object: a whole beef leg / shank (đùi bò) with the bone end exposed, hearty and large. Stage 4 of 5.` |
| 5 | `cow` | 🐄 | `Object: a sturdy brown-and-cream Vietnamese cow (bò), full body, standing, gentle eyes, small horns, ear tag. Stage 5 of 5 — the source animal.` |

### 4.5 Nước dùng `broth` (5 tier) — 🦴🥘🍲🫕🛢️

| # | id | Emoji cũ | Object |
|---|---|---|---|
| 1 | `bone` | 🦴 | `Object: a large cleaned beef bone (xương ống), cream-white with a marrow end. Stage 1 of 5 in "broth".` |
| 2 | `bonepot` | 🥘 | `Object: a shallow iron pot with beef bones and a few star-anise pods, cold water level, no steam. Stage 2 of 5.` |
| 3 | `simmer` | 🍲 | `Object: a clay simmering pot with a lid slightly ajar, thin steam rising, ginger slice and onion visible at the rim. Stage 3 of 5.` |
| 4 | `stock` | 🫕 | `Object: a large stainless stockpot full of clear amber phở broth, rising steam, star anise and cinnamon floating. Stage 4 of 5.` |
| 5 | `barrel` | 🛢️ | `Object: a big wooden-and-brass barrel of finished broth, tap at the bottom, a warm glow, gold bands. Stage 5 of 5 — the largest of the series.` |

### 4.6 Gia vị `spice` (4 tier + 3 skin) — 🌰🌱🌳🧂 (+🪵⭐🫒)

| # | id | Emoji cũ | Object |
|---|---|---|---|
| 1 | `nut` | 🌰 | `Object: two brown aromatic spice seeds/nuts on a small wooden scoop. Stage 1 of 4 in "spice".` |
| 2 | `sprout` | 🌱 | `Object: a small reddish-brown spice seedling with two leaves in a mound of soil. Stage 2 of 4.` |
| 3 | `tree` | 🌳 | `Object: a small spice sapling tree in a clay pot with dark glossy leaves, tiny berries. Stage 3 of 4.` |
| 4 | `spice` (mặc định) | 🧂 | `Object: a small wooden bowl with an assortment of cinnamon stick, star anise and cardamom pods, lightly dusted with spice powder. Stage 4 of 4.` |
| 4a | `spice_cinnamon` | 🪵 | `Object: a bundle of 3 rolled cinnamon quills (quế) tied with twine, warm brown. Variant of stage 4.` |
| 4b | `spice_anise` | ⭐ | `Object: 3 star anise pods (hồi), glossy dark red-brown, with seeds visible. Variant of stage 4.` |
| 4c | `spice_cardamom` | 🫒 | `Object: a small cluster of green-tan cardamom pods (thảo quả) with a few opened to show black seeds. Variant of stage 4.` |

### 4.7 Dừa `coconut` (8 tier) — 🥥🌱🌿🌴🌴🌴🌸🥥

Emoji cũ dùng 🌴 lặp ở tier 4/5/6 → prompt phải phân biệt bằng **kích thước & độ trưởng thành**.

| # | id | Object |
|---|---|---|
| 1 | `seed` | `Object: a whole brown hairy coconut seed lying on its side. Stage 1 of 8 in "coconut".` |
| 2 | `sprout` | `Object: a coconut with a tiny pale green shoot sprouting from the top. Stage 2 of 8.` |
| 3 | `bud` | `Object: a coconut with a taller shoot with two small green leaves, and a few roots at the base. Stage 3 of 8.` |
| 4 | `sapling` | `Object: a small coconut palm sapling, 3 short green fronds, planted in a mound of soil. Stage 4 of 8.` |
| 5 | `young` | `Object: a young coconut palm, short thin trunk, 5 arching fronds, soil mound. Stage 5 of 8.` |
| 6 | `mature` | `Object: a mature tall coconut palm, thick ringed trunk, full crown of 7 fronds, a small cluster of green coconuts under the crown. Stage 6 of 8.` |
| 7 | `flower` | `Object: a coconut flower spadix (hoa dừa) — a cluster of small creamy-yellow blossoms on a branching stalk, tied to a green palm frond. Stage 7 of 8.` |
| 8 | `fruit` | `Object: a fresh green young coconut (trái dừa) with a straw inserted and a cut top, a half-cut coconut showing white flesh next to it. Stage 8 of 8 — the reward.` |

### 4.8 Bò sữa `dairyCow` (6 tier) — 🐮🐄🐄🥛🫙🧀

| # | id | Object |
|---|---|---|
| 1 | `calf` | `Object: a cute baby calf (bê con), cream-and-brown patches, big eyes, small ears, standing. Stage 1 of 6 in "dairyCow".` |
| 2 | `heifer` | `Object: a young heifer (bò tơ), black-and-white patches, medium size, standing, no udder yet. Stage 2 of 6.` |
| 3 | `cow` | `Object: a full-grown black-and-white dairy cow (bò sữa) with a visible pink udder, a bell around the neck, happy expression. Stage 3 of 6.` |
| 4 | `pail` | `Object: a metal milk pail full of fresh white milk with a foamy top, wooden handle. Stage 4 of 6.` |
| 5 | `churn` | `Object: a tall aluminum milk churn (bình sữa lớn) with a lid and two side handles, a drop of milk on the rim. Stage 5 of 6.` |
| 6 | `stock` | `Object: a stack of golden cheese wheels and a wedge with holes, next to two full milk bottles (kho sữa đầy), on a small wooden pallet. Stage 6 of 6 — the richest.` |

### 4.9 Rau củ `vegetable` (6 tier) — 🌱🌿🥬🧺🥕🌽

| # | id | Object |
|---|---|---|
| 1 | `seed` | `Object: a small paper seed packet with a leafy illustration, and 3 seeds beside it. Stage 1 of 6 in "vegetable".` |
| 2 | `sprout` | `Object: a young row of 3 green seedlings (mầm rau) coming out of dark soil. Stage 2 of 6.` |
| 3 | `row` | `Object: a neat garden row of leafy green bok-choy/lettuce plants in a soil furrow (luống rau). Stage 3 of 6.` |
| 4 | `basket` | `Object: a woven bamboo basket (giỏ rau) filled with fresh leafy greens. Stage 4 of 6.` |
| 5 | `fullBasket` | `Object: a big overflowing bamboo basket (rổ rau đầy) of carrots, greens, tomatoes and cucumbers. Stage 5 of 6.` |
| 6 | `harvest` | `Object: a lush harvest — a wooden crate overflowing with corn, carrots, cabbages, tomatoes and pumpkins, plus a leafy plant behind (vườn rau trĩu quả). Stage 6 of 6 — the abundant top tier.` |

---

## 5. Icon chương / món ăn (`chapters.dart`) — 5 ảnh

Dùng ở `property_grid_screen`, `chapter_card` (emoji 44px). Nền trong suốt, cùng
style chung; khung vuông.

| id file | Emoji cũ | Object |
|---|---|---|
| `chapters/ch1.png` | 🛖 | `Object: a small cozy bamboo-and-thatch chicken coop (chuồng gà) with a little door and three chicks peeking out.` |
| `chapters/ch_coconut.png` | 🌴 | `Object: a coconut palm cluster with 3 coconuts hanging and a small basket at the base.` |
| `chapters/ch_dairy.png` | 🐄 | `Object: a friendly dairy cow head and shoulders with a small milk bottle in front.` |
| `chapters/ch_vegetable.png` | 🥬 | `Object: a leafy green cabbage and a carrot crossed in front of a small bamboo basket.` |
| `chapters/ch2.png` | 🍜 | `Object: a bowl of steaming Vietnamese phở with herbs, a lime wedge and chopsticks.` |

## 6. Trạm chế biến (`station`) — 3 ảnh

| id file | Emoji cũ | Object |
|---|---|---|
| `stations/wood_crate.png` | 🧱 | `Object: a rustic wooden work crate/counter with rope handles (a "delivery station").` |
| `stations/basket_stand.png` | 🧺 | `Object: a large woven bamboo basket resting on a small wooden stand.` |
| `stations/cooking_pot.png` | 🍲 | `Object: a big cooking pot on a small wood fire, gentle steam.` |

## 7. Nguyên liệu công thức (`IngredientDef`) — dùng lại ảnh chuỗi

Các `IngredientDef` trong `chapters.dart` **không cần ảnh mới** — ánh xạ về ảnh
ở mục 4:

| ingredient id | Dùng lại ảnh |
|---|---|
| `nest` | `poultry/egg` |
| `flock` | `poultry/young` |
| `hen`, `hens` | `poultry/hen` (hens: đặt 2 ảnh cạnh nhau bằng code) |
| `rooster` | `poultry/rooster` |
| `coconutSeed` / `coconutSprout` / `coconutSapling` / `coconutMature` / `coconutFruit` | `coconut/seed`, `sprout`, `sapling`, `mature`, `fruit` |
| `milkFirst` | ảnh MỚI: giọt sữa (xem 7.1) |
| `milkFresh` | ảnh MỚI: ly sữa (7.1) |
| `milkJar` | ảnh MỚI: hũ sữa (7.1) |
| `milkCrate` | ảnh MỚI: thùng sữa (7.1) |
| `milkChurn` | `dairyCow/churn` |
| `milkCheese` | ảnh MỚI: phô mai (7.1) |
| `milkCream` | ảnh MỚI: kem sữa (7.1) |
| `milkButter` | ảnh MỚI: bơ (7.1) |
| `milkStock` | `dairyCow/stock` |
| `vegSeed`, `vegSprout`, `vegRow`, `vegBasket`, `vegFullBasket`, `vegHarvest` | `vegetable/seed`, `sprout`, `row`, `basket`, `fullBasket`, `harvest` |
| `vegCrate` | ảnh MỚI: sọt rau (7.2) |
| `vegCart` | ảnh MỚI: xe rau (7.2) |
| `vegStall` | ảnh MỚI: sạp rau (7.2) |
| `noodle` | `rice/noodle` |
| `herbs` | `herbs/bunch` |
| `beef` | `beef/loin` |
| `broth` | `broth/stock` |

### 7.1 Ảnh mới cho chương Bò sữa (`ingredients/`)

| file | Object |
|---|---|
| `milk_first.png` | `Object: a single big glossy white milk drop with a tiny sparkle.` |
| `milk_fresh.png` | `Object: a tall glass of fresh milk with a bit of foam at the top.` |
| `milk_jar.png` | `Object: a glass jar of milk with a cork lid and a small tag.` |
| `milk_crate.png` | `Object: a wooden crate holding 4 milk bottles.` |
| `milk_cheese.png` | `Object: a fresh white cheese wheel with a slice removed.` |
| `milk_cream.png` | `Object: a scoop of vanilla milk cream / ice-cream in a small cup.` |
| `milk_butter.png` | `Object: a golden butter block partly unwrapped from paper, with a small butter knife.` |

### 7.2 Ảnh mới cho chương Rau củ

| file | Object |
|---|---|
| `veg_crate.png` | `Object: a wooden crate stacked with leafy vegetables and radishes.` |
| `veg_cart.png` | `Object: a small two-wheeled wooden vegetable cart loaded with produce.` |
| `veg_stall.png` | `Object: a market stall with a striped awning, a table full of vegetables (sạp rau).` |

## 8. Công trình mở khoá (`DecorDef`) — 5 ảnh

Dùng ở màn "Tài sản"/farm map. Khung **vuông 1:1, góc nhìn iso 3/4 từ trên xuống**
để đặt lên bản đồ được.

| file | Emoji cũ | Object |
|---|---|---|
| `decor/coop.png` | 🛖 | `Object: an isometric bamboo-and-thatch chicken coop with a small fenced yard and 3 hens.` |
| `decor/coconut_grove.png` | 🌴 | `Object: an isometric small coconut grove — 3 palm trees on a grassy patch with fallen coconuts.` |
| `decor/dairy_barn.png` | 🐄 | `Object: an isometric red wooden dairy barn with a small paddock and one dairy cow.` |
| `decor/veg_garden.png` | 🥬 | `Object: an isometric vegetable garden with raised beds, rows of greens, carrots, a scarecrow.` |
| `decor/pho_stall.png` | 🏮 | `Object: an isometric Vietnamese phở street stall with a red lantern, wooden table, plastic stools, and a steaming pot.` |

## 9. Tài sản / property (`properties.dart`) — 2 ảnh

| file | Emoji cũ | Object |
|---|---|---|
| `properties/farm.png` | 🚜 | `Object: a small green farm tractor with a mustard-yellow trim, a hay bale in the trailer.` |
| `properties/cuisine.png` | 🍜 | `Object: a bowl of Vietnamese phở with chopsticks and a red lantern behind it.` |

## 10. Chướng ngại (`obstacle_component.dart`, `level_intro_dialog.dart`) — 2 ảnh

| file | Emoji cũ | Object |
|---|---|---|
| `obstacles/cobweb.png` | 🕸️ | `Object: a translucent silver spider-web (mạng nhện) covering the whole square tile, thin white strands with tiny dew drops. The tile background must show through (semi-transparent web).` |
| `obstacles/cobweb_heavy.png` | 🕸️‼️ | `Object: a dense thick cobweb full-cover with a rusty iron chain-lock in the middle — "heavy" version of the cobweb, darker strands, more strands, a small metal padlock.` |

## 11. UI icon (tiền tệ, thanh trạng thái, nav, nút) — 17 ảnh

Nhỏ (16–40 px): dùng style chung nhưng **viền dày hơn (~6px at 512px)**, hình
đơn giản, đọc rõ ở 24 px. Xuất 128x128.

| file | Emoji cũ | Dùng ở | Object |
|---|---|---|---|
| `ui/coin.png` | 🪙 | shop, home, level result | `Object: a shiny gold coin with an embossed rice-plant symbol, front-facing, a tiny sparkle.` |
| `ui/gem.png` | 💎 | shop, home, HUD, nút Sửa chữa | `Object: a faceted sky-blue diamond gem with bright white highlights.` |
| `ui/energy.png` | ⚡ | shop, home, HUD, dialog hết năng lượng | `Object: a bold yellow lightning bolt inside a soft glowing orange circle.` |
| `ui/shop.png` | 🛍️ | nút cửa hàng (home) | `Object: a small wooden market stall / shopping bag with a green leaf tag.` |
| `ui/home.png` | 🏠 | nút Trang chủ (game HUD) | `Object: a cute small thatched-roof farmhouse, simple.` |
| `ui/lock.png` | 🔒 | chương/level khoá | `Object: a golden padlock, closed, with a green leaf on the shackle.` |
| `ui/star_full.png` | ★ | starString | `Object: a glossy gold five-point star.` |
| `ui/star_empty.png` | ☆ | starString | `Object: a hollow grey five-point star outline with a subtle inner shadow.` |
| `ui/check.png` | ✓ | mục tiêu / chương hoàn thành | `Object: a bold green checkmark inside a soft light-green circle.` |
| `ui/nav_play.png` | 🎮 | tab Chơi | `Object: a green wooden game-controller-like play button (a triangle play icon on a round leaf badge).` |
| `ui/nav_assets.png` | 🗺️ | tab Tài sản | `Object: a small folded treasure map with a red pin.` |
| `ui/booster_shuffle.png` | 🔀 | booster Xáo bàn | `Object: two curved crossing arrows (shuffle) in mustard on a round wooden badge.` |
| `ui/booster_moves.png` | ➕ | booster Thêm lượt | `Object: a bold plus sign in green on a round wooden badge with a small footprint.` |
| `ui/booster_repair.png` | 🛠 | booster Sửa chữa | `Object: a crossed wrench and hammer on a round blue badge.` |
| `ui/warning.png` | ‼️ | chướng ngại nặng | `Object: a red double-exclamation mark on a small yellow triangle badge.` |
| `ui/speaker_default.png` | 🧑 | NPC mặc định (fallback) | `Object: a neutral gray silhouette of a person's head and shoulders, flat.` |
| `ui/npc_fallbacks.png` | 👩👨‍🌾🧑‍🌾👧👵 | fallback khi thiếu portrait | *Bỏ qua* — 5 NPC đã có portrait trong `assets/characters/`; chỉ giữ 1 ảnh silhouette ở trên làm fallback chung. |

## 12. Tổng kết số lượng

| Nhóm | Số ảnh |
|---|---|
| Chuỗi tiến hoá (mục 4) | 5+5+7+5+5+7+8+6+6 = **54** |
| Icon chương (5) | 5 |
| Trạm chế biến (6) | 3 |
| Nguyên liệu mới (7.1 + 7.2) | 7 + 3 = **10** |
| Công trình (8) | 5 |
| Property (9) | 2 |
| Chướng ngại (10) | 2 |
| UI icon (11) | 16 |
| **Tổng** | **97** |

**Ưu tiên sinh trước (thấy nhiều nhất trên bàn chơi):** mục 4 (54 ảnh) → mục 11
(coin/gem/energy/lock/star) → mục 10 (chướng ngại) → còn lại.

## 13. Mẹo chất lượng

- **Sinh theo lô 1 chuỗi**: đưa ảnh tier 1 làm *reference image* cho tier 2..N để
  giữ đồng nhất (nếu công cụ hỗ trợ image reference / seed cố định).
- Thêm `negative prompt`: `background, ground, shadow on floor, text, watermark, frame, photo-realistic, blurry, multiple objects, hands`.
- Kiểm tra độc lập trên **nền tối và nền sáng** — viền phải đủ đậm để không "chìm".
- Kiểm tra ở kích thước thật (60 px) — nếu chi tiết nhỏ mất hết thì đơn giản hoá
  prompt (bớt chi tiết phụ).
- Các tier "cùng emoji cũ" (🌴×3 ở dừa, 🐄×2 ở bò sữa, 🥬 ở rau thơm/rau củ) **bắt buộc** khác nhau rõ về kích thước/độ chín trong prompt (đã viết ở trên).
