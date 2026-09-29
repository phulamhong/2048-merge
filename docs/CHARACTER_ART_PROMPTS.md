# Character Art — Prompts & Pipeline

Prompt gốc dùng để tạo ảnh nhân vật cho SceneDialog (Mai, Ông Tư, Chú Bảy, Bé
Na, Dì Sáu — Hồi 1), cộng quy trình tách nền/crop đã dùng để đưa vào
`flutter/assets/characters/`. Giữ lại để tái sử dụng khi thêm NPC cho Hồi 2-8.

## Style chung (dán vào đầu mọi prompt để giữ đồng nhất phong cách)

```
Art style: warm semi-realistic mobile-game cartoon illustration, soft cel-shading,
clean bold outlines, gentle rim light, Vietnamese countryside (miền Tây) farmer
character, similar visual quality to Hay Day / Merge Dragons character art.
Color palette: earthy greens (#6A994E, #3A4A2C), warm mustard yellow (#E9C46A),
terracotta brown (#BC6C25), soft warm skin tones.
Proportions: slightly stylized (not chibi, not hyper-realistic), 7-head proportion,
expressive friendly face, appealing to casual mobile game players of all ages.

CRITICAL — no background, no scenery, no props on ground: transparent PNG /
plain flat white or solid green-screen (#00FF00) background only, so the
character can be cut out and placed into the game separately. No shadows cast
on ground. No watermark, no text, no logo, no frame/border.
```

## Các loại ảnh cần cho mỗi nhân vật

| # | Loại ảnh | Khung hình | Mục đích trong game |
|---|---|---|---|
| 1 | Portrait chính diện (đầu + vai) | vuông 1:1, nhìn thẳng, biểu cảm trung tính-thân thiện | avatar hội thoại (SceneDialog) |
| 2 | Portrait 3/4 nghiêng | vuông 1:1 | avatar phụ / màn hình chương |
| 3 | Full-body chính diện, tư thế idle | dọc 3:4 | popup giới thiệu NPC, farm map |
| 4 | Full-body 3/4, tư thế hành động đặc trưng | dọc 3:4 | scene cutscene, banner sự kiện |
| 5 | Bảng 4 biểu cảm (vui, ngạc nhiên, lo lắng, cười lớn) | vuông, lưới 2x2 | tái sử dụng cho nhiều dòng thoại |

Trong thực tế (Hồi 1) mới chỉ tạo dạng #3/#4 rồi crop lại thành portrait +
full-body (xem "Quy trình" bên dưới) — chưa làm riêng #1/#2/#5.

Yêu cầu bắt buộc lặp lại ở mọi prompt: "no background", "transparent
background", "isolated character only", "no environment, no props scattered
around except what character is holding/wearing".

## Prompt từng nhân vật (Hồi 1)

### Mai — nhân vật chính

```
[STYLE CHUNG ở trên]

Character: Mai, a young Vietnamese woman, mid-to-late 20s, the protagonist
returning to her late grandmother's abandoned farm to rebuild it.
Face: warm oval face, soft determined eyes, warm brown skin, natural light
makeup, gentle optimistic expression with a hint of nostalgia.
Hair: shoulder-length black hair, tied in a low loose ponytail or half-up bun,
a few loose strands framing the face.
Outfit: simplified modern-rustic "áo bà ba" (traditional southern Vietnamese
farmer blouse) in soft sage green or cream, sleeves rolled up to elbows,
comfortable rolled cropped pants, simple rubber sandals (dép lê). Practical,
not fancy — she just moved back to the countryside.
Accessory: carrying her grandmother's old worn leather-bound notebook (sổ tay
cũ) tucked under one arm or held in hand, for at least one full-body pose.
Build: slim, average height, approachable posture.

Pose for full-body idle: standing, weight on one leg, one hand on hip, relaxed
confident smile.
Pose for full-body action: kneeling or bending slightly, opening a chicken
coop gate / tending a plant, sleeves rolled, focused expression.
```

### Ông Tư — người hàng xóm lớn tuổi, cố vấn đầu tiên

```
[STYLE CHUNG ở trên]

Character: Ông Tư, an elderly Vietnamese farmer man, 65-70 years old, kind
neighbor and the player's first mentor.
Face: sun-weathered tan skin, deep friendly laugh-lines, warm crinkled eyes,
thin white/gray eyebrows, a few age spots, wide genuine smile showing warmth
and humor.
Hair: short white/gray hair, mostly hidden under a traditional conical hat
(nón lá) OR bare head with a khăn rằn (checkered scarf) around the neck —
produce one version with nón lá and one without, for variety.
Outfit: traditional brown "áo bà ba" farmer shirt, loose black or dark brown
trousers rolled at the ankle, barefoot or simple sandals. Slightly worn,
well-loved clothing.
Accessory: wooden walking cane OR a rake resting against shoulder in the
action pose.
Build: lean, slightly hunched with age but sturdy, weathered farmer hands.

Pose for full-body idle: standing relaxed, one hand resting on cane, gentle
welcoming smile, other hand gesturing as if explaining something.
Pose for full-body action: leaning on a fence rail gesture (hands only, no
actual fence drawn), pointing forward as if giving advice.
```

### Chú Bảy — chuyên gia trồng dừa

```
[STYLE CHUNG ở trên]

Character: Chú Bảy, a middle-aged Vietnamese farmer man, 45-55 years old,
coconut-growing expert, jovial and hearty.
Face: tanned rugged skin, thick dark eyebrows, short stubble/mustache,
big hearty laughing expression, sun-creased eyes.
Hair: short black hair with a few gray strands, mostly covered by a wide
conical hat (nón lá).
Outfit: faded blue or olive-green "áo bà ba" work shirt with rolled sleeves
showing strong forearms, dark brown work trousers rolled up, sturdy sandals.
Accessory: holding a traditional hoe (cái cuốc) or a small hand-sickle,
farmer's shoulder towel (khăn rằn) draped around neck.
Build: stocky, muscular, sturdy farmer physique.

Pose for full-body idle: standing with hoe resting on the ground/shoulder,
confident wide stance, one hand on hip, big warm laugh.
Pose for full-body action: crouching down, hand touching a coconut tree trunk
(hand + gesture only, no tree drawn), examining it with concern-turning-to-
relief expression.
```

### Bé Na — bé gái hàng xóm

```
[STYLE CHUNG ở trên]

Character: Bé Na, a cheerful Vietnamese little girl, about 7-9 years old,
mischievous and energetic neighbor kid.
Face: round chubby-cheeked face, big bright curious eyes, playful gap-tooth
or dimpled smile, light tan skin.
Hair: black hair in two small pigtail braids (bím tóc) with simple colorful
hair ties/ribbons.
Outfit: simple cheerful countryside outfit — a small patterned áo bà ba in
pink or light yellow, or a simple cotton dress, cropped pants, small rubber
sandals. Slightly dusty/dirty from playing outside.
Accessory: optional — small basket or a pet chick cupped in her hands for one
action pose.
Build: small child proportions, slightly stylized/rounder than adults for
cuteness.

Pose for full-body idle: standing, one foot slightly kicked back playfully,
hands behind back, mischievous grin.
Pose for full-body action: running or hopping, arms swinging, laughing
openly, hair mid-bounce.
```

### Dì Sáu — người phụ nữ lớn tuổi, phúc hậu

```
[STYLE CHUNG ở trên]

Character: Dì Sáu, an elderly Vietnamese countrywoman, 55-65 years old,
warm-hearted and nurturing, a respected elder in the village.
Face: soft round face, warm gentle wrinkles, kind knowing eyes, soft warm
smile, slightly plump cheeks.
Hair: gray-streaked black hair pulled back into a low bun (búi tóc), no hat.
Outfit: traditional "áo bà ba" in warm terracotta or deep maroon color,
simple dark long pants, sandals. Optionally a light khăn rằn scarf resting
on shoulders.
Accessory: holding a small woven bamboo basket (thúng/rổ tre) in one hand for
the action pose.
Build: average height, softly built, warm nurturing posture (slightly
forward-leaning as if offering something).

Pose for full-body idle: standing, hands clasped in front, warm nurturing
smile, head tilted slightly.
Pose for full-body action: offering the basket forward with both hands,
welcoming gesture, gentle smile.
```

## Lưu ý khi generate

- Giữ nguyên block "Style chung" ở đầu mỗi prompt — cách duy nhất để nhiều
  nhân vật trông cùng một game thay vì rời rạc.
- Negative prompt (nếu công cụ hỗ trợ): `background, scenery, landscape,
  ground, floor, shadow, grass, sky, trees, farm buildings, watermark, text,
  logo, frame, multiple characters, cropped body`.
- Midjourney: thêm `--no background, scenery --ar 1:1` (portrait) hoặc
  `--ar 3:4` (full-body), và `--style raw` để tránh model tự vẽ nền phong cảnh.
- Ảnh Hồi 1 thực tế sinh ra là **2 pose gộp trong 1 ảnh** (idle + action cạnh
  nhau) cho Mai/Chú Bảy/Bé Na, và **1 pose duy nhất, canh giữa khung** cho
  Ông Tư/Dì Sáu — quy trình crop bên dưới xử lý cả 2 dạng.

## Quy trình tách nền + crop đã dùng (2026-09-29)

1. **Tách nền bằng AI (rembg)** — xử lý tốt cả khoảng hở kín bên trong nhân
   vật (giữa tay/hông, giữa nón lá và đầu) mà cách flood-fill từ viền không
   làm được.
   ```bash
   python3 -m venv scratchpad/venv   # venv riêng, KHÔNG cài vào Python hệ
   source scratchpad/venv/bin/activate  # thống (Homebrew Python chặn pip
   pip install rembg onnxruntime pillow # install trực tiếp — PEP 668)
   ```
   Gọi qua **Python API**, không qua CLI (`python3 -m rembg.commands` lỗi
   thiếu dependency `click` dù rembg cài thành công):
   ```python
   from rembg import remove
   output_bytes = remove(open("input.jpg", "rb").read())
   open("output.png", "wb").write(output_bytes)
   ```
2. **Crop từng pose riêng** bằng bounding-box của kênh alpha (Pillow
   `Image.getbbox()`), tách 2 pose cạnh nhau (Mai/Chú Bảy/Bé Na) bằng cách
   bổ đôi ảnh rồi tính bbox từng nửa; ảnh 1 pose (Ông Tư/Dì Sáu) tính bbox
   trực tiếp trên cả ảnh.
3. **Crop portrait** = phần trên cùng ~34% chiều cao của pose (đầu+vai),
   vuông, canh giữa theo chiều ngang của pose đó.
4. Output 2 file/nhân vật: `<tên>_portrait.png` (dùng cho avatar hội thoại)
   và `<tên>_full.png` (toàn thân, để dành cho farm map/popup NPC sau này —
   **chưa dùng ở đâu trong code tính đến 2026-09-29**).

## File đã tạo (Hồi 1)

Nằm ở `flutter/assets/characters/`, khai báo trong `pubspec.yaml`
(`assets: - assets/characters/`), dùng trong
`flutter/lib/widgets/scene_dialog.dart` (`_speakerLooks`):

- `mai_portrait.png`, `mai_full.png`
- `ong_tu_portrait.png`, `ong_tu_full.png`
- `chu_bay_portrait.png`, `chu_bay_full.png`
- `be_na_portrait.png`, `be_na_full.png`
- `di_sau_portrait.png`, `di_sau_full.png`

Nhân vật chưa có ảnh (không có trong `_speakerLooks`) tự fallback về emoji,
không vỡ layout.
