# Hồi 1 — "Nông trại bà Năm": Thiết kế toàn diện (v4, ~1.000 màn)

> **⚠ Đã được cập nhật bởi [HOI1_VIETNAM_EXPANSION.md](HOI1_VIETNAM_EXPANSION.md) (v5):** 10 Phần → **12 Phần theo lịch âm**, 140 → **294 asset**, 997 → **1.976 màn** (Lõi 1.055), thêm quy tắc *chuồng trước, con sau*. Khi mâu thuẫn, file v5 thắng; dữ liệu gốc ở [hoi1_assets.csv](hoi1_assets.csv).

> **Thay thế** `GAME_DESIGN_ACTS.md §3, §14, §17.1, §18, §19.0` (Hồi 1 v2: 22 chương ~185 màn). Các phần còn lại
> của `GAME_DESIGN_ACTS.md` (Hồi 2+, vật cản §13, chain sâu §8) và `GAME_DESIGN.md §3–§9` **giữ nguyên**.
> Kho dữ liệu 140 asset nằm ở [`HOI1_ASSET_CATALOG.md`](HOI1_ASSET_CATALOG.md). Prompt art: xem §9.
>
> Mọi con số màn/moveLimit/kinh tế dưới đây là **thiết kế khởi điểm, chưa sim** — phải chạy
> `flutter/tool/simulate.dart` trước khi đưa vào code (nguyên tắc chung của toàn bộ tài liệu thiết kế).

---

## 0. Tóm tắt quyết định

| Hạng mục | Quyết định |
|---|---|
| Quy mô | **140 asset → 150 chương → 997 màn** (1.003 nếu giữ nguyên chương cũ đã live) |
| 4 trụ cột | Cây trồng (59) · Vật nuôi (18) · Chế biến bánh/mứt/… (30) · Công trình hỗ trợ (29 + 4 chain vật liệu) |
| Cấu trúc | Hồi 1 = **10 Phần** (mỗi Phần ≈ 1 khu nông trại + 1 mốc cảm xúc), trong Phần chương mở theo **3 làn song song** |
| Cốt truyện | 1 năm ở nông trại, **từ mùa mưa đến Tết**; sợi chỉ đỏ = 10 trang sổ thất lạc của bà Năm + tờ giấy bán đất |
| Công trình | Không chỉ trang trí: mỗi công trình = 1 chương 4 màn (4 giai đoạn xây) + **buff meta** + mở khoá chương |
| Chợ & Kho | Là trục tiến trình: Kho giới hạn sức chứa, Chợ ra đơn hàng lấy từ Kho, nâng cấp qua 6 Kho + 4 Chợ |
| Cách làm 1.000 màn | **Sinh màn từ khuôn** (4 khuôn) + sim tự chỉnh `moveLimit`, không viết tay từng màn |
| Art | ≈ **480 ảnh** (thay vì ~700) nhờ chia sẻ ảnh tier 1–2 và mứt T6–T7 |

Các câu hỏi cần bạn chốt: xem §12; quan trọng nhất là **có chấp nhận sinh màn tự động** hay muốn viết tay.

---

## 1. Từ "100 asset" đến "500–1000 màn"

Tỉ lệ thực tế: **1 asset ≈ 7 màn** (cây 7, vật nuôi/chế biến 8, công trình 4, Phiên chợ 6/chương không tính asset).

| Loại | Asset | Màn/asset | Màn |
|---|---|---|---|
| Cây trồng | 59 | 7 | 413 |
| Vật nuôi | 18 | 8 | 144 |
| Chế biến | 30 | 8 | 240 |
| Công trình | 29 | 4 | 116 |
| Phiên chợ | 14 chương | 6 | 84 |
| **Tổng** | 136 asset có chương + 4 vật liệu | | **997** |

Muốn **~500 màn**: chỉ làm P1–P6 (615 màn, 87 asset có chương). Muốn **~1.000**: làm cả 10 Phần.
Vì vậy quy mô không cố định — xem lộ trình phát hành theo Phần ở §11.

---

## 2. Cốt truyện — "Sổ tay bà Năm" (tuyến truyện Hồi 1)

### 2.1 Tiền đề (giữ nguyên `GAME_DESIGN_ACTS.md §1`)

**Mai** (28 tuổi, cựu nhân viên văn phòng thành phố) về thừa kế nông trại bỏ hoang của **bà Năm** cùng cuốn
sổ tay cũ. Cô định dọn vài tuần rồi bán đất — và ở lại.

### 2.2 Chủ đề: "nợ nghĩa"

Bà Năm không để lại tiền, chỉ để lại **sổ nợ nghĩa**: bà cho cả xóm mượn hạt giống, con giống, cái cuốc; ai
cũng nợ bà một chút, và **bà chưa bao giờ đòi**. Mỗi NPC trong Hồi 1 là một người từng được bà giúp — họ giúp
Mai vì bà, rồi dần vì chính Mai. Không phản diện, không twist lớn (giữ nguyên tắc cũ) — chỉ có **áp lực nhẹ**:

- **Tờ giấy bán đất**: anh Long (môi giới, người lịch sự, không xấu) gửi thư đề nghị mua ở **P3, P6, P9**; hạn
  trả lời = **Tết**. Mai không trả lời, cất vào sổ. Cuối Hồi 1 cô xé đôi (§2.7).
- **Sổ thiếu 10 trang**: mỗi Phần Mai tìm được 1 "trang thất lạc" giấu trong 1 công trình (bà cất vào chỗ bà
  hay ngồi). Đọc đủ 10 trang → công thức cuối.

### 2.3 Dàn nhân vật

| NPC | Vai | Phần chính | Đã có ảnh? |
|---|---|---|---|
| **Mai** | Nhân vật chính | Tất cả | ✓ |
| **Ông Tư** | Hàng xóm, đầu mối Kho/Chợ | P1–P3, P10 | ✓ |
| **Chú Bảy** | Bạn ông Tư, chuyên cây ăn trái/ruộng | P2, P4, P6, P7 | ✓ |
| **Bé Na** | Cháu ngoại ông Tư, mê vật nuôi | P3, P5, P8 | ✓ |
| **Dì Sáu** | Chủ sạp chợ huyện, quen bà Năm | P1 (cameo), P2, P7–P10 | ✓ |
| **Cô Ba** *(mới)* | Thợ bánh mứt làng, từng là học trò của bà Năm | P8, P9 | ✗ cần vẽ |
| **Bác Hai** *(mới)* | Thợ mộc/xây, đội trưởng "đội công trình" | P1–P10 (mọi màn xây) | ✗ cần vẽ |
| **Anh Tài** *(mới)* | Lái xe tải giao hàng, vui tính | P7 → | ✗ cần vẽ |
| **Mực** *(mới)* | Chó đen lảng vảng từ P1 — chó cũ của bà Năm | P1 → P10 | ✗ cần vẽ |
| **Bà Năm** | Chỉ xuất hiện qua trang sổ + hồi tưởng nhạt màu | P1–P10 | ✗ cần vẽ (bản 1 màu sepia) |

### 2.4 Dòng thời gian & 10 Phần (mỗi Phần = 1 mốc cảm xúc)

| Phần | Tháng (âm) | Khu | Cảm xúc chính của Mai | Trang sổ thất lạc (giấu ở) |
|---|---|---|---|---|
| **P1 Dọn Vườn Xưa** | 7 | Sân + chuồng gà | *Ngợp*: "sao bà sống được ở đây?" | #1 "Bà về đây lúc 30 tuổi, một mình" (chuồng gà) |
| **P2 Vườn Rau Đầu Mùa** | 8 | Vườn rau | *Thành tựu đầu tiên*: cây lên xanh | #2 "Cách bà đếm hạt giống" (nhà kính) |
| **P3 Đàn Gia Súc** | 9 | Chuồng trại | *Trách nhiệm*: có sinh mạng phụ thuộc mình. Thư môi giới #1 | #3 "Con heo đầu tiên bà đặt tên" (chuồng heo) |
| **P4 Ruộng Đồng** | 10 | Ruộng, vườn củ | *Kiên nhẫn*: vụ mùa dài. Nhận ra nợ nghĩa | #4 "Sổ nợ nghĩa — trang đầu" (kho lúa) |
| **P5 Ao Hồ, Ong & Tằm** | 11 | Ao, tổ ong | *Ngạc nhiên*: bà biết những thứ mình chưa từng nghe | #5 "Bà học nuôi ong từ ai" (nhà ong) |
| **P6 Vườn Cây Ăn Trái** | 12 | Vườn cây | *Tự hào + hoài nghi*: thư môi giới #2, "hay bán rồi về?" | #6 "Cây đầu tiên bà trồng là cây dừa" (kho lạnh) |
| **P7 Cây Đặc Sản & Cây Tết** | 12 → giêng | Vườn ươm | *Nhớ nhà*: mùa hoa mai, nhớ Tết hồi nhỏ ở đây | #7 "Tết đầu Mai về thăm, bà chờ" (vườn ươm) |
| **P8 Xưởng Mứt** | giêng | Xưởng mứt | *Gần bà nhất*: cô Ba dạy công thức bà truyền. Mực có tên | #8 "Mứt gừng — bà viết dở" (xưởng mứt) |
| **P9 Lò Bánh** | giêng | Lò bánh | *Quyết định*: thư môi giới #3. Mai nhận ra mình muốn ở lại | #9 "Thư bà viết cho Mai, chưa gửi" (lò bánh) |
| **P10 Chợ Xuân** | 30 Tết | Chợ lớn | *Trọn vẹn*: xé tờ bán đất, hoàn thành công thức mứt gừng | #10 "Lời cuối" (cổng chào) |

### 2.5 Điểm nhấn cảm xúc từng Phần (mỗi Phần đúng 1 cảnh dài, còn lại là thoại ngắn)

- **P1 — Mực xuất hiện.** Cuối Chương gà: Mai thấy 1 con chó đen ngồi ngoài hàng rào nhìn vào chuồng, không
  vào. Ông Tư: "Chó của bà đó. Bà đi rồi nó vẫn ra đó ngồi." *(Mực chỉ xuất hiện ở viền màn hình từ đây tới P8.)*
- **P2 — Nhà kính.** Bác Hai xây xong, Mai tìm thấy trang #2: bà đếm hạt giống bằng cách hát đồng dao —
  Mai thử hát theo khi gieo (SFX gieo hạt có nhạc đồng dao).
- **P3 — Thư môi giới #1.** Mai đọc thư trước chuồng heo mới xây, do dự, gấp lại kẹp vào sổ. Bé Na hỏi:
  "Chị định đi hả?" — "Chưa biết."
- **P4 — Nợ nghĩa.** Mai lật ra trang đầu **sổ nợ nghĩa**: 30 dòng, tên cả xóm, mỗi dòng là 1 món bà cho
  mượn. Chú Bảy, ông Tư đều có tên. Ông Tư: "Không ai đòi bà hết. Bà bảo: ai nợ thì giúp lại người sau."
- **P6 — Hoài nghi.** Thư #2 hứa giá cao gấp đôi. Mai ngồi cả đêm bên gốc dừa (cây bà trồng đầu tiên).
  Chú Bảy đưa cho Mai 1 quả dừa: "Bà bảo cây này để chờ người về."
- **P7 — Mùa mai.** Cảnh hồi tưởng: Mai 8 tuổi ở đây, bà làm mứt. Chỉ hình bóng, không thoại — nhạc nền dịu.
- **P8 — Mứt gừng.** Cô Ba: "Bà làm mứt gừng mỗi Tết. Năm nào cũng để 1 hũ, bà nói 'để dành cho Mai'." Mai
  chết lặng. Bé Na đặt tên chó là **Mực**, Mai nhận ra đó là con chó của bà — cả hai cùng khóc/cười.
- **P9 — Thư chưa gửi (trang #9).** Bà viết cho Mai: *"Con không cần nông trại. Con chỉ cần biết có chỗ để
  về."* → Mai quyết định ở lại (cảnh xé giấy dời sang P10 để có cao trào).
- **P10 — Chợ Xuân.** Xem §2.7.

### 2.6 Mứt gừng — chương "hero"

- Chain `jamGung` (T8), gốc là `gung` (P4). Bà chỉ viết dở: "Gừng già ngâm đường, nhớ…" (đứt).
- P8: Mai làm được **mứt gừng nhưng thiếu vị** — cô Ba nói "thiếu 1 thứ bà hay thêm".
- P10: trang #10 nói thứ đó là **1 lát quýt** (từ `quyt` P7) — công thức hoàn thiện; màn boss Hồi 1 là
  `jamGung` + `jamQuyt` + `jamDua` trên bàn 8×8 (boss `fair14`).

### 2.7 Kết Hồi 1 — kịch bản cảnh cuối (mẫu, ~12 dòng)

> Chợ Xuân, sáng 30 Tết. Cả xóm bày sạp; Mai đặt hũ mứt gừng cuối cùng trước bàn thờ bà.

**ÔNG TƯ**: Con nhìn kìa. Cả xóm ra đây vì con đó.
**MAI**: Con tưởng… con chỉ về vài tuần.
**DÌ SÁU** *(đặt xuống hũ mứt)*: Bà Năm nợ dì cái cuốc hồi đó. Dì trả bằng cái sạp này, đừng có cãi.
**BÉ NA**: Chị ơi, Mực đây nè!
*(Mực bước vào cổng chào, ngồi xuống cạnh Mai)*
**MAI** *(lấy tờ thư bán đất ra, xé đôi)*: Anh Long ơi, cảm ơn nhưng… đất này con giữ.
**MAI** *(đọc trang #10, nội tâm)*: *"Mai à, nếu con đọc được dòng này thì bà không mất đâu. Bà ở trong mỗi hũ
mứt con làm."*
**DÌ SÁU**: Con làm được mứt, giờ tính sao? Nấu món luôn đi. Khách ngoài chợ hỏi hoài.
**MAI** *(mỉm cười, gấp sổ)*: Dạ, con thử.

`→ mở khoá Hồi 2 "Ẩm thực Việt Nam"`

### 2.8 Giọng thoại các NPC mới (mẫu 1 câu)

- **Cô Ba**: "Con làm đúng rồi đó, chỉ là tay con chưa nhớ — tay bà Năm nhớ cả nghìn lần."
- **Bác Hai** *(mỗi màn xây)*: "Móng chắc thì nhà đứng, cô Mai. Gạch xếp tiếp đi!"
- **Anh Tài**: "Đơn hôm nay nhiều quá trời! Cô Mai đóng lẹ, xe tui chờ ở cổng."

---

## 3. Cấu trúc Hồi 1 — 10 Phần

| Phần | Chương (cây/vật/chế biến/công trình/chợ) | Số chương | Số màn | Ghi chú |
|---|---|---|---|---|
| P1 Dọn Vườn Xưa | 4 / 1 / 0 / 3 / 1 | 9 | 54 | Dạy luật lõi. Vật cản: chỉ Đá ở boss |
| P2 Vườn Rau Đầu Mùa | 10 / 2 / 0 / 3 / 1 | 16 | 104 | Thêm Cỏ dại |
| P3 Đàn Gia Súc | 0 / 7 / 3 / 3 / 1 | 14 | 98 | Thêm Băng. Chế biến sữa (sữa chua, phô mai, bơ) |
| P4 Ruộng Đồng | 16 / 1 / 2 / 3 / 1 | 23 | 154 | Thêm Lưới. Lớn nhất — chia 2 làn (ngũ cốc / củ) |
| P5 Ao Hồ, Ong & Tằm | 0 / 6 / 2 / 3 / 1 | 12 | 82 | Thêm Hư hao. Thuỷ sản |
| P6 Vườn Cây Ăn Trái | 15 / 0 / 0 / 3 / 1 | 19 | 123 | Đủ 5 vật cản, chưa ghép |
| P7 Cây Đặc Sản & Tết | 14 / 0 / 1 / 3 / 1 | 19 | 124 | Bắt đầu 2 vật cản/màn |
| P8 Xưởng Mứt | 0 / 1 / 12 / 2 / 2 | 17 | 124 | Mứt dùng `initialTiles`; chó giữ trại |
| P9 Lò Bánh | 0 / 0 / 10 / 3 / 2 | 15 | 104 | 2 chain/bàn từ màn 4 |
| P10 Chợ Xuân | 0 / 0 / 0 / 3 / 3 | 6 | 30 | Đại đơn hàng, kết Hồi |
| **Tổng** | 59 / 18 / 30 / 29 / 14 | **150** | **997** | |

### 3.1 Mở khoá — "3 làn song song" (thay chuỗi tuyến tính 150 chương)

150 chương xếp hàng dài là chán. Trong mỗi Phần chia 3 làn, người chơi tự chọn thứ tự:

```
Làn 1 — Đất:   cây trồng          (mở tuần tự trong làn)
Làn 2 — Chuồng: vật nuôi + chế biến (mở tuần tự trong làn)
Làn 3 — Xây:   công trình         (mở khi đủ điều kiện, xem dưới)
Phiên chợ của Phần: mở khi hoàn thành ≥ 60% chương của Phần đó
```

- **Chương mở tuần tự trong làn** (chương k+1 mở khi hoàn thành chương k, giữ luật `GAME_DESIGN.md §2.2`).
- **Công trình mở** khi hoàn thành *chương cây/vật nuôi liên quan* (vd: Chuồng heo cần xong `pig` màn 4)
  **và đủ xu**. Xây xong công trình có thể mở chương mới (cột "Mở khoá" ở catalog F).
- **Phần k+1 mở** khi hoàn thành **≥ 60% chương** của Phần k **và** xây xong công trình anchor của Phần k
  (Giếng P1, Kho nhỏ P2, Kho thức ăn P3, Kho lúa P4, Nhà ong P5, Kho lạnh P6, Vườn ươm P7, Xưởng mứt P8,
  Lò bánh P9). Buộc người chơi đụng tới công trình → tiến trình meta có ý nghĩa.

---

## 4. Bản đồ nông trại — 4 trụ cột

Màn "Tài sản/Nông trại" (đã có `properties_screen`) đổi thành **bản đồ các khu**, mở dần theo Phần:

```
        [Chợ Xuân]  [Kho tổng]  [Cổng chào]      ← P10
[Xưởng mứt]  [Lò bánh]  [Bếp lớn]                ← P8–P9  (chế biến)
[Vườn cây ăn trái] [Vườn ươm] [Quầy Tết]         ← P6–P7  (cây)
[Ruộng lúa/ngô] [Vườn củ] [Cối xay] [Kho lúa]    ← P4     (cây + kho)
[Chuồng heo][Chuồng bò][Ao cá][Nhà ong][Nhà tằm] ← P3–P5  (vật nuôi)
[Nhà kính][Vườn rau][Sạp chợ][Giếng][Chuồng gà]  ← P1–P2  (khởi đầu)
```

- Mỗi khu là 1 ô lưới; ô khoá hiển thị "đất hoang" (cỏ dại) → xây xong hiện công trình. Tận dụng art
  công trình (catalog F, prompt ở `OBJECT_ART_PROMPTS.md §8` — cần mở rộng).
- **Hoàn thành chương → "vật phẩm" hiện trên bản đồ** (vd: hoàn thành `caChua` → luống cà chua mọc ở vườn rau).
  Vậy bản đồ = "album" nhìn thấy thành quả sau ~1.000 màn.

---

## 5. Công trình: buff meta, Kho, Chợ

### 5.1 Mỗi công trình = 1 chương 4 màn "Xây dựng" (khuôn T4, §6.3)

4 màn = 4 giai đoạn hiển thị trên bản đồ: **Móng → Khung → Mái → Hoàn thiện**. Mục tiêu dùng chain **vật
liệu** (`wood`/`brick`/`tool`/`canvas`, catalog E). Bác Hai xuất hiện: 1 câu/màn.

### 5.2 Buff meta — 4 loại (không phá cân bằng màn chơi)

| Loại | Ví dụ | Đặt ở |
|---|---|---|
| Năng lượng | Giếng +20% hồi, Máy bơm +2 max, Giàn tưới +3 max | `SaveManager.energyMax/regen` |
| Xu | Chuồng heo +10% xu chương vật nuôi, Cối xay +10% ngũ cốc | công thức thưởng xu |
| Booster | Vườn ươm: Xáo bàn rẻ 20% | giá `shuffleCost` |
| Kho/Đơn | Kho các cấp; slot đơn hàng chợ | §5.3–5.4 |

Tổng buff tối đa được khoá để **không dễ hơn quá 15%** win-rate so với không có (kiểm bằng sim).

### 5.3 Kho — sức chứa tăng theo 6 nấc

`Kho nhỏ 100 → Kho thức ăn 250 → Kho lúa 500 → Kho lạnh 1.000 → Kho bột 1.500 → Kho tổng 3.000`.

- **Vật phẩm vào Kho khi thắng màn**: mỗi màn thưởng "sản phẩm" tương ứng objective (thắng `caChua` màn 5 →
  +3 cà chua chín). Sao cao hơn → nhiều hơn.
- **Đầy Kho** → sản phẩm dư đổi thành xu (tỉ lệ nhỏ, không mất trắng). Tránh chặn người chơi.
- **Cần Kho** để làm Đơn hàng chợ (5.4). Nâng Kho là lý do xây nhiều Kho.

### 5.4 Chợ — đơn hàng lấy từ Kho

| Cấp | Công trình | Slot đơn | Thưởng |
|---|---|---|---|
| 1 | Sạp chợ làng (P1) | 2 | xu |
| 2 | Quầy hàng Tết (P7) | 3 | xu + gem nhỏ |
| 3 | Gian trưng bày (P9) | 4 | xu + gem + booster |
| 4 | Chợ Xuân (P10) | 6 | + vật phẩm trang trí hiếm |

- Mỗi đơn: "Giao 5 táo chín + 2 hũ mứt táo" (lấy từ Kho). Đơn làm mới theo giờ thật (chu kỳ 4h) hoặc khi thắng
  màn — **lý do chơi lại màn cũ** (giữ chân dài hạn mà không cần thêm nội dung).
- **Phiên chợ** (chương tổ hợp, catalog G) mở nhờ Sạp chợ, là "boss" của mỗi Phần.

---

## 6. Khuôn màn — 4 khuôn để sinh ~1.000 màn

Công thức `moveLimit` thô (giữ đúng `GAME_DESIGN.md §7`): `ML ≈ Σ target × 2^(tier−1) × hệ số`, làm tròn lên
bội số 2. **Chỉ là điểm khởi đầu** — tool sim tự chỉnh tới khi win-rate đạt mục tiêu §7.3.

### 6.1 Khuôn T7 — cây trồng (7 màn, chain 5 tier)

| Màn | Objective | Vật cản | Hệ số | ML thô |
|---|---|---|---|---|
| 1 | T3×2 | 0 | 1.8 | ~16 |
| 2 | T3×3 | 0 | 1.7 | ~22 |
| 3 | T4×1 + T3×1 | 1 | 1.7 | ~24 |
| 4 | T4×2 | 1 | 1.6 | ~28 |
| 5 | T5×1 + T3×1 | 2 | 1.5 | ~34 |
| 6 | T5×1 + T4×1 | 2 | 1.5 | ~40 |
| 7 (boss) | T5×2 | 3–4 | 1.4 | ~50 |

### 6.2 Khuôn T8 — vật nuôi & chế biến (8 màn, chain 5–6 tier; mứt 8 tier dùng `initialTiles` như `§18.2` cũ)

| Màn | Objective | Vật cản | Hệ số | ML thô |
|---|---|---|---|---|
| 1 | T3×2 | 0 | 1.8 | ~16 |
| 2 | T3×3 | 0 | 1.7 | ~22 |
| 3 | T4×1 + T3×2 | 1 | 1.7 | ~30 |
| 4 | T4×2 | 1 | 1.6 | ~28 |
| 5 | T5×1 + T3×2 | 2 | 1.55 | ~40 |
| 6 | T5×1 + T4×1 | 2 | 1.5 | ~40 |
| 7 | T5×2 | 3 | 1.4 | ~50 |
| 8 (boss) | T6×1 + T4×1 *(chain 6 tier)* / T5×2 + T4×1 *(chain 5 tier)* | 3–4 | 1.4 | ~60 |

**Chế biến bánh (P9):** từ màn 4, thêm **chain phụ** trên bàn (cột "Chain phụ" catalog D2): chain phụ spawn ~25%
(nhiễu vừa phải, khác "chó giữ trại" ở chỗ chain phụ *cũng* có objective nhỏ ở màn 6–8).

### 6.3 Khuôn T4 — công trình (4 màn = 4 giai đoạn xây)

| Màn | Giai đoạn | Objective (chain vật liệu, 5 tier) | Vật cản | Hệ số | ML thô |
|---|---|---|---|---|---|
| 1 | Móng | T3×2 | 0 | 1.8 | ~16 |
| 2 | Khung | T3×2 + T4×1 | 1 | 1.7 | ~26 |
| 3 | Mái | T4×2 | 1 | 1.6 | ~28 |
| 4 (boss) | Hoàn thiện | T5×1 + T4×1 | 2 | 1.5 | ~40 |

Công trình dùng 2 vật liệu (vd `wood+canvas`): màn 1–2 chain 1, màn 3–4 chain 2 (bàn 2 chain, mục tiêu cả 2).

### 6.4 Khuôn F6 — Phiên chợ (6 màn, bàn lớn, 2–3 chain)

Giữ nguyên bảng `§18.4` cũ, tổng quát hoá:

| Màn | Bàn | Objective | ML thô |
|---|---|---|---|
| 1 | 6×6 / 7×7 | 2 chain, T-cao×1 mỗi chain | ~30 |
| 2 | như trên | 2 chain, T-cao×1 + T-thấp×2 | ~34 |
| 3 | như trên | 2 chain, nặng hơn | ~38 |
| 4 | 7×7 / 8×8 | 3 chain, T-cao×1 | ~44 |
| 5 | 8×8 | 3 chain, hỗn hợp | ~52 |
| 6 (boss) | 8×8 | "Đơn hàng lớn" 3 chain × T-cao | ~68 |

### 6.5 Ví dụ hoàn chỉnh — `caChua` (Chương 3 của P1, T7)

Chain `caChua` (VEGFRUIT): Hạt cà chua → Mầm cà chua → Cây cà chua ra hoa → Cà chua xanh → **Cà chua chín**.
Bàn 5×5. Vật cản duy nhất ở boss (P1 chỉ có Đá).

| Màn | Objective | Đá | ML |
|---|---|---|---|
| 1 | T3×2 | — | ~16 |
| 2 | T3×3 | — | ~22 |
| 3 | T4×1 + T3×1 | — | ~24 |
| 4 | T4×2 | — | ~28 |
| 5 | T5×1 + T3×1 | — | ~34 |
| 6 | T5×1 + T4×1 | — | ~40 |
| 7 (boss) | T5×2 | 1·tâm (2,2) | ~50 |

**Thoại mở đầu (Chú Bảy, thoại ngắn):** "Cà chua đó con, ăn sống cũng được, nấu cũng được — bà Năm trồng nó
quanh năm."
**Thưởng hoàn thành:** +3 cà chua chín vào Kho (mỗi màn boss); luống cà chua hiện trên bản đồ.

### 6.6 Sinh màn tự động

Không viết tay 1.000 màn. Dữ liệu **1 dòng mỗi chương**, sinh ra từ khuôn:

```yaml
- id: caChua
  template: T7
  chain: caChua
  board: 5x5
  obstacleKind: rock         # theo Phần (§7.2)
  obstacleFrom: 7            # boss mới có vật cản (P1)
  npc: chuBay
  introLine: "Cà chua đó con..."
  rewardItem: caChua_t5
```

`tool/gen_levels.dart` (mới) đọc YAML/JSON → sinh `LevelConfig` với `moveLimit` thô từ công thức → chạy
`tool/simulate.dart` → **ghi ML đã chỉnh** vào `levels_generated.dart` (không sửa tay). Chỉ những màn boss/
màn kể chuyện cần thiết kế tay (≈ 10% tổng số).

---

## 7. Độ khó xuyên Hồi 1

### 7.1 Đường cong theo Phần

| Phần | Bàn | Chain/màn | Tier cần | Vật cản/màn | Hệ số cuối | Cảm giác |
|---|---|---|---|---|---|---|
| P1 | 5×5 | 1 | T3–T5 | 0–1 | 1.4 | Dạy luật, gần như không thua |
| P2 | 5×5 | 1 | T3–T5 | 0–2 | 1.4 | Quen tay |
| P3 | 5×5 / 6×6 | 1 (+2 ở Phiên chợ) | T3–T5 | 0–3 | 1.35 | Bắt đầu cần nghĩ |
| P4 | 6×6 | 1 | T3–T5 | 0–3 | 1.35 | Vật cản đa dạng |
| P5 | 6×6 | 1–2 | T3–T6 | 1–3 | 1.3 | Chuỗi dài hơn |
| P6 | 6×6 | 1–2 | T3–T5 | 1–4 | 1.3 | Đỉnh 1 (nhiều asset giống nhau, boss khó) |
| P7 | 6×6 / 7×7 | 1–2 | T3–T5 | 2 loại vật cản | 1.3 | Tết: xen màn "dễ, đẹp" |
| P8 | 6×6 | 1 (mứt 8 tier) + `initialTiles` | T6–T8 | 1–4 | 1.25 | Tier cao, mứt là "món khó" |
| P9 | 6×6 / 7×7 | 2 | T4–T5 | 2–4, 2–3 loại | 1.25 | Bàn nhiễu chain phụ |
| P10 | 8×8 | 3 | T5–T8 | tổng hợp | 1.2 | Đỉnh Hồi 1 |

### 7.2 Lịch giới thiệu vật cản (chỉ dùng loại đã học)

| Phần | Vật cản mới | Ghi chú giới thiệu |
|---|---|---|
| P1 | Đá (chỉ boss) | Tutorial 1 câu (Ông Tư) |
| P2 | Cỏ dại | Chú Bảy giải thích |
| P3 | Băng | Bé Na "sương muối đóng băng chuồng" |
| P4 | Lưới đánh cá (đã có `obstacle_component` "🕸️") | Ao/đồng: lưới che nắng |
| P5 | Hư hao | Dì Sáu: "để lâu là hỏng" |
| P6–P10 | Không thêm loại; **kết hợp 2–3 loại** từ P7 | Độ khó từ số lượng + vị trí |

### 7.3 Mục tiêu win-rate (sim bot, ghi nhận từng màn)

| Loại màn | Win-rate mục tiêu (bot "khá") |
|---|---|
| Màn 1–2 mỗi chương | ≥ 90% |
| Màn 3–5 | 70–85% |
| Màn 6 | 55–70% |
| Boss | 40–55% |
| Công trình (T4) | 80–90% (đừng chặn tiến trình) |
| Phiên chợ boss | 35–50% |

**Nhịp răng cưa:** mỗi 3 chương có 1 chương "thở" (chương nhẹ, ML rộng). Tuyệt đối không 2 boss liên tiếp
không có màn dễ chen giữa. Kiểm tra bằng script đọc win-rate sim theo thứ tự.

---

## 8. Kinh tế Hồi 1

| Thành phần | Mức khởi điểm |
|---|---|
| Xu / màn thắng | 15 + 5 × số sao (1–3), +50 boss chương |
| Xu / màn thắng trung bình | ≈ 25 → ~25.000 xu cả Hồi (997 màn) |
| Gem | 1 / boss chương, 5 / boss Phiên chợ, thưởng đơn Chợ; ≈ 1.000 gem cả Hồi |
| Giá công trình | Xu = `120 × (số Phần) × (1 + số công trình đã xây / 10)`, gem chỉ dùng công trình "anchor" |
| Booster | giữ nguyên: Xáo bàn 30 xu, +5 lượt 60 xu, Sửa chữa 3 gem (theo code hiện tại) |
| Năng lượng | giữ nguyên hệ thống hiện có; buff công trình §5.2 |
| Sao | 3 sao/màn → ~3.000 sao. Không khoá bằng sao (chỉ hiển thị + thưởng đơn) |

Sink chính: **công trình** (29 lần) + **booster**. Xu dư đổ vào **trang trí bản đồ** (phụ, không bắt buộc).

---

## 9. Kế hoạch art (≈ 480 ảnh)

Tận dụng chia sẻ để giảm từ ~700 xuống ~480:

| Nhóm | Ảnh | Cách tiết kiệm |
|---|---|---|
| Cây trồng (59) | 59×3 = 177 (T3–T5 vẽ riêng) + 18 (tier 1–2 của 9 template, đổi màu) = **195** | Tier 1–2 dùng chung ảnh + tô màu |
| Vật nuôi (18) + `cat`/`mouse` (4) | 18×5 + 4 = **94** | — |
| Mứt (10) | 10 (T8 riêng) + 2 (T6, T7 dùng chung, tô màu) = **12** | T5 = ảnh quả chín có sẵn |
| Bánh (10) | 10×3 (T3–T5) + 4 (T1–T2 dùng chung) = **34** | Nguyên liệu chung |
| Đồ chế biến khác (10) | 10×5 = **50** | — |
| Vật liệu (4) | 4×5 = **20** | — |
| Công trình (29) | 29×2 (đang xây / hoàn thành) + 4 giai đoạn xây dùng chung = **62** | 4 overlay giàn giáo dùng chung |
| Nhân vật mới (Cô Ba, Bác Hai, Anh Tài, Mực, Bà Năm) | 5×2 = **10** (chân dung + toàn thân) | Theo `CHARACTER_ART_PROMPTS.md` |
| **Tổng** | **≈ 477** | |

**Việc art kế tiếp:** mở rộng `OBJECT_ART_PROMPTS.md` cho 136 asset còn lại (hiện mới có 54 tier của 9 chain
Hồi 1 cũ + Hồi 2). Đề xuất viết prompt **theo template** (Style chung + `Object: {tên}, template {TPL}, stage
N/5`) và sinh hàng loạt bằng 1 script ghép chuỗi — không viết tay 480 prompt.

**Thứ tự vẽ theo lộ trình phát hành (§11):** P1–P2 (≈ 90 ảnh) → P3–P6 → P7–P10.

---

## 10. Thay đổi kỹ thuật (đối chiếu code `flutter/lib/`)

| # | Việc | File liên quan | Ghi chú |
|---|---|---|---|
| 1 | `TierDef/SkinDef/IngredientDef` đọc ảnh (`assetPath`) thay `emoji` | `core/types.dart`, `game/tile_component.dart`, widget | Xem `OBJECT_ART_PROMPTS.md §3` |
| 2 | `LevelConfig` nhiều chain / spawn-weight trong 1 màn | `core/types.dart`, `core/board.dart` | Cần cho chó giữ trại, Phiên chợ, bánh (chain phụ) |
| 3 | **Kho** (`inventory`) + sức chứa + đổi xu khi đầy | `core/save_manager.dart` | Thắng màn cộng vật phẩm |
| 4 | **Đơn hàng chợ** + làm mới theo giờ | `core/save_manager.dart`, màn hình mới | `claimedOrders` (đã phác ở `GAME_DESIGN.md §12.2`) |
| 5 | **Công trình** (`buildings`): trạng thái/giai đoạn xây, buff | `data/`, `core/save_manager.dart` | Buff §5.2 |
| 6 | Bản đồ nông trại theo khu | `screens/properties_screen.dart`, `property_grid_screen.dart` | Thay grid hiện tại |
| 7 | Hệ thống "làn" mở khoá chương | `data/chapters.dart`, `core/save_manager.dart` | §3.1 |
| 8 | **`tool/gen_levels.dart`** + chạy `tool/simulate.dart` hàng loạt | `flutter/tool/` | §6.6 — thay công việc viết tay |
| 9 | Trang sổ thất lạc (10 trang) + hộp thoại tường thuật | `data/scenes.dart`, `widgets/scene_dialog.dart` | Đã có `SceneDialog` |
| 10 | Migration save (giữ `ch1`, `ch_coconut`, `ch_dairy`, `ch_vegetable`) | `core/save_manager.dart` | Catalog mục H |

Không cần cơ chế lõi mới nào ngoài #2 — phần còn lại là dữ liệu + meta.

---

## 11. Lộ trình sản xuất

| Bản | Phần | Màn | Asset có chương | Nội dung player thấy |
|---|---|---|---|---|
| **A (~615 màn)** | P1–P6 | 615 | 87 | Đất → Chuồng → Ruộng → Ao → Vườn cây; Chợ/Kho nấc 1–4 |
| **B (+248 màn)** | P7–P8 | 248 | 33 | Cây Tết + Xưởng mứt + mứt gừng |
| **C (+134 màn)** | P9–P10 | 134 | 16 | Lò bánh + Chợ Xuân (kết Hồi 1) |

Ưu tiên trong mỗi bản: (1) engine #2–#7 → (2) `gen_levels` + sim → (3) sinh màn → (4) art theo Phần →
(5) thoại/cảnh. Nên **ship Bản A rồi mới đo retention** (bạn có 615 màn trước khi làm tiếp).

### 11.4 Sai số tổng
Tổng 997 (bảng §1) + 6 (giữ chương cũ đã live, catalog H) = **1.003 màn**.

---

## 12. Câu hỏi mở (cần bạn chốt)

1. **Sinh màn tự động (§6.6)**: đồng ý sinh từ khuôn + sim, chỉ viết tay boss/màn kể chuyện? *(Khuyến nghị: có.
   Nếu viết tay hết 1.000 màn sẽ mất nhiều tháng.)*
2. **Quy mô ship đầu**: làm Bản A (~615 màn) rồi dừng đo, hay làm liền cả 997?
3. **Tên nhân vật mới** (Cô Ba, Bác Hai, Anh Tài, Mực) — giữ hay đổi? Có muốn thêm NPC nào khác?
4. **Đơn hàng chợ làm mới theo giờ thật** (§5.4): chấp nhận cơ chế "giữ chân theo thời gian" hay chỉ làm mới khi
   thắng màn?
5. **Có cần khoá bằng sao** (ví dụ mở công trình cần N sao)? Mặc định: **không**.
6. **Hồi 2 nối tiếp**: đã đặt `lua` Hồi 1 kết ở "Bao gạo" và Hồi 2 bắt đầu từ đó — cần đồng bộ với `rice` chain hiện tại.


