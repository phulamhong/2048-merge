# Nông Trại & Ẩm Thực Việt — Thiết kế mở rộng dài hạn (v2)

> Tài liệu **thiết kế/định hướng**, khác với [SPECS.md](./SPECS.md) là tài liệu **mô tả đúng code hiện tại**.
> Mọi thứ ở đây là đề xuất cho các Phase tiếp theo — chưa implement, dùng để thống nhất hướng đi trước khi
> đụng code. Khi một phần được implement, chuyển mô tả tương ứng sang `SPECS.md`.

> ⚠️ **§2/§2.1/§2.1a/§2.1b/§11/§12/§13 ĐÃ ĐƯỢC THIẾT KẾ LẠI (2026-09-28)** — xem
> [docs/GAME_DESIGN_ACTS.md](./GAME_DESIGN_ACTS.md). Đã bỏ khung "5 Vùng theo miền Việt Nam" + "Sổ tay Bà
> Năm", thay bằng câu chuyện mới (cô gái thành thị thừa hưởng nông trại) + cấu trúc 3+ Hồi theo giai đoạn sự
> nghiệp (Nông trại → Ẩm thực Việt → Nhà hàng quốc tế → Thời trang → Cà phê...). `STORY_CONCEPTS.md` (4
> phương án cũ) cũng coi như đã thay thế. Các mục còn lại của tài liệu này (§1, §3-§10) **vẫn còn hiệu lực**
> — không phụ thuộc câu chuyện/vùng miền, dùng chung cho thiết kế mới.

---

## 0. Vì sao redesign

Bản MVP (Phase 1) đã chứng minh core loop (gộp/tách kiểu 2048 → thu hoạch nguyên liệu → nấu món → mở khoá
nông trại) vui và dạy được. Nhưng nó dừng ở quy mô "demo": 2 chương, 10 màn, không có vật cản, không có gì
giữ chân người chơi sau ~30 phút. Redesign này biến nó thành **một game dài hạn**, giữ nguyên toàn bộ luật
chơi lõi (không phá vỡ 37 test hiện có), chỉ mở rộng theo chiều rộng (chủ đề) và chiều sâu (độ khó, cấu trúc
màn).

Bốn yêu cầu gốc và cách tài liệu này đáp ứng:

| Yêu cầu | Đáp ứng ở mục |
|---|---|
| Chủ đề farm/ẩm thực/hoa quả/động vật, không giới hạn | §2 Bản đồ Vùng, §3 Chuỗi vật phẩm mới |
| Ghép cặp 2048 để tăng cấp dần | Giữ nguyên §3.6-3.7 SPECS.md, mở rộng độ sâu tier ở §3, §5 |
| Có thể chia nhỏ ở các level sau | §4.2 Màn nhiều giai đoạn (stage) |
| Level khó dần (vật cản giữa bàn), tăng số level để merge | §4.1 Vật cản, §4.3 Tăng lưới/tier, §7 Cân bằng độ khó |
| Game dài hạn | §2 lộ trình Vùng, §5 hệ tiến trình meta, §8 lộ trình phát hành |

---

## 1. Tầm nhìn sản phẩm

- **Thể loại:** merge-puzzle theo cấp (2048) + collector/farm-sim nhẹ, nội dung theo chủ đề ẩm thực & nông
  trại Việt Nam, mở rộng dần ra trái cây, hải sản, đặc sản vùng miền.
- **Vòng lặp dài hạn:** người chơi không "hết game" — mỗi Vùng mới mở ra chuỗi vật phẩm, vật cản, và công
  trình nông trại mới. Nội dung được thiết kế để phát hành theo đợt (giống level pack), không cần thiết kế
  lại engine mỗi lần thêm Vùng.
- **Phiên chơi:** 3-8 phút/màn, chơi rời rạc nhiều lần trong ngày (phù hợp mobile), không ép real-time.
- **Không đổi:** giữ nguyên bản chất "không phải game live-ops nặng" — không cần energy/life system, không
  cần PvP. Tính lâu dài đến từ **khối lượng nội dung + độ sâu chiến thuật**, không phải áp lực nhân tạo.

---

## 2. Cấu trúc ba tầng: Vùng → Chương → Màn

> ⚠️ **Đã thiết kế lại** — khung "Vùng theo miền Việt Nam" ở §2.1/§2.1a/§2.1b bên dưới không còn là hướng
> dùng nữa, xem [docs/GAME_DESIGN_ACTS.md](./GAME_DESIGN_ACTS.md) §2. Cấu trúc 3 tầng Hồi→Chương→Màn ở dưới
> đây vẫn đúng nguyên lý, chỉ đổi tên "Vùng" → "Hồi" và đổi nội dung nhét vào từng tầng.

Hiện tại chỉ có 2 tầng (Chương → Màn). Thêm tầng **Vùng (World)** ở trên để tổ chức nội dung dài hạn và để
UI bản đồ có chỗ nhóm nhiều chương lại (SPECS.md §14 đã ghi nhận giới hạn "màn hình bản đồ chỉ đủ chỗ 2 thẻ
chương" — đây là lúc giải quyết nó bằng cách paginate theo Vùng).

```
Vùng (World)                 — 1 chủ đề lớn, mở khoá tuần tự, 4-6 chương
  └─ Chương (Chapter)        — 1 công thức/công trình, 5 màn (giữ nguyên quy ước hiện tại)
       └─ Màn (Level)        — 1 nguyên liệu, có thể nhiều giai đoạn (§4.2)
```

### 2.1 Lộ trình Vùng đề xuất

Ba chương đã ghi trong roadmap Phase 2 của SPECS.md (Cơm gà Hội An/đá, Bánh mì/cỏ dại, Bún chả/băng) trở
thành **Vùng 2**, giữ nguyên ý tưởng vật cản đã chốt. Các Vùng sau là phần mở rộng mới của tài liệu này.

| Vùng | Chủ đề | Giới thiệu cơ chế mới | Chain mới |
|---|---|---|---|
| **1 — Trại nhỏ** *(đã có)* | Gà, phở bò | Gộp, tách, mixed | poultry, rice, herbs, beef, broth, spice |
| **2 — Miền Trung** | Cơm gà Hội An, Bánh mì, Bún chả | Vật cản: Đá, Cỏ dại, Băng (§4.1) | poultry biến thể, wheat (lúa mì), pork |
| **3 — Miệt vườn Nam Bộ** | Trái cây, hủ tiếu | Màn nhiều giai đoạn (§4.2); lưới 5×5 thành chuẩn | tropicalFruit (xoài, dứa, dừa, sầu riêng), riceNoodle |
| **4 — Biển đảo** | Hải sản, mắm | Vật cản mới: Lưới đánh cá (ô phải "kéo" mới lấy được, §4.1); multi-chain trong 1 màn | seafood (tôm, cá, mực, cua), fishSauce |
| **5 — Cao nguyên** | Cà phê, mật ong, hồ tiêu | Tier trần sâu hơn (7 tier) cho chain cao cấp; combo 2 chain ra 1 nguyên liệu (§4.4) | coffee, honey, pepper |
| **6 — Ngày Tết** *(sự kiện lặp lại hàng năm)* | Bánh chưng, mứt, hoa mai/đào | Giới hạn thời gian, bảng riêng, không chặn tiến trình chính | tet (mai/đào), banhChung |
| **7+ — mở dần theo nhu cầu** | Đặc sản khác (chả cá, bánh xèo, chè, …) | Tái dùng toàn bộ cơ chế đã có, chỉ thêm data | tuỳ chủ đề |

Vùng 6 (Tết) là **sự kiện theo mùa** chứ không phải Vùng tuần tự — dùng chung engine nhưng có bảng xếp hạng
nội dung riêng, mở lại mỗi năm với vật phẩm trang trí giới hạn. Đây là cơ chế chính giữ retention dài hạn
sau khi người chơi đã qua hết nội dung "cốt truyện".

### 2.1a Content chính & phạm vi v1.0 — chốt số Vùng/Chương/Màn

**Content chính (đã nhất quán từ đầu, chốt lại ở đây thay vì để ngỏ):** merge-puzzle kiểu 2048 lồng trong
**hành trình ẩm thực Việt Nam theo vùng miền** — mỗi Vùng = 1 miền địa lý + nhóm món ăn/nguyên liệu đặc
trưng thật của miền đó, chơi qua từng Chương (= 1 công thức) để sưu tập nguyên liệu, nấu món, mở khoá trang
trí. Đây là trục nội dung duy nhất của game (không rẽ nhánh sang chủ đề khác) — chiều sâu đến từ việc mỗi
Vùng **dạy đúng 1 cơ chế mới** (§4) trên nền luật lõi không đổi, không phải từ việc đổi thể loại.

Bảng Vùng ở §2.1 để "7+" mở vô hạn — phù hợp để *định hướng* nhưng không dùng để *lên kế hoạch sản xuất*
được vì không có điểm dừng. Chốt phạm vi **v1.0 (đủ nội dung để publish store lần đầu)** ở 5 Vùng tuần tự,
Vùng 6 (Tết) tách riêng làm nội dung hậu-launch, Vùng 7+ không lên kế hoạch trước — thêm theo nhu cầu sau
khi có dữ liệu người chơi thật:

| Vùng | Chương (5 màn/chương, quy ước hiện tại) | Số màn | Trạng thái |
|---|---|---|---|
| 1 — Trại nhỏ | Trại gà nhỏ · Tô phở bò (2) | 10 | ✅ Live — code + data đã có, đang polish |
| 2 — Miền Trung | Cơm gà Hội An · Bánh mì · Bún chả (3) | 15 | 📝 Nội dung đủ chi tiết ở §11 — chưa chuyển thành code (cần Đá/Cỏ dại/Băng ở core trước, §11.5) |
| 3 — Miệt vườn Nam Bộ | *(ước tính)* Trái cây miệt vườn · Hủ tiếu (2) | 10 | ⏳ Chưa thiết kế chi tiết — cần bản §11-style riêng trước khi code |
| 4 — Biển đảo | *(ước tính)* Hải sản · Mắm & combo (2) | 10 | ⏳ Chưa thiết kế chi tiết |
| 5 — Cao nguyên | *(ước tính)* Cà phê · Mật ong · Hồ tiêu (3) | 15 | ⏳ Chưa thiết kế chi tiết |
| **Tổng v1.0** | **12 chương** | **60 màn** | 10 xong, 15 đã lên nội dung, 35 còn lại chưa thiết kế |
| 6 — Tết *(hậu-launch)* | 2-3 chương sự kiện | 10-15 | Không tính vào v1.0 — làm sau khi 5 Vùng chính đã live, mở lại hàng năm |

Vì sao 60 màn: ở nhịp 3-8 phút/màn (SPECS.md §1) là ~3-6 giờ nội dung "cốt truyện" cho v1.0 — đủ dày để
không cảm thấy ngắn khi mới publish, nhưng không dàn quá mỏng cho một sản phẩm làm một mình (so với Vùng 2:
riêng 15 màn đó đã cần 1 tài liệu §11 đầy đủ chain/objective/vật cản mới xong phần *thiết kế*, chưa kể
code+sim). Số chương ước tính cho Vùng 3-5 suy từ số chain mới liệt kê ở bảng §2.1 (mỗi nhóm nguyên liệu
lớn ≈ 1 chương, theo đúng cách Vùng 1/2 đang chia), **chưa phải quyết định cuối** — cần làm bản chi tiết
kiểu §11 cho từng Vùng đó trước khi số chương/màn này được xem là chốt.

Thứ tự thực hiện để đạt v1.0: theo đúng lộ trình Phase 2a→4 đã có ở §9 (vật cản Đá trước, rồi Vùng 2 xong
cả 3 chương, rồi mới thiết kế+code Vùng 3-5). Không nhảy cóc thiết kế Vùng 3-5 trước khi Vùng 2 chạy được
thật trên engine, vì mỗi Vùng mới phải xác nhận lại bằng bot sim (§7) — làm tuần tự tránh phải tune lại từ
đầu nếu core đổi.

### 2.1b Kho đề tài cho Vùng 7+ / nội dung phụ — tìm thêm bằng nghiên cứu

§2.1 mới ghi "Vùng 7+: đặc sản khác (chả cá, bánh xèo, chè, mì Quảng, cao lầu…)" — quá sơ sài để dùng làm kế
hoạch. Nhờ cấu trúc **tuyển tập** vừa chốt ở §13 (mỗi phần độc lập, không mạch nối tiếp), giờ có thể liệt kê
thoải mái nhiều ứng viên cùng lúc mà không cần quyết định thứ tự — phần nào có tư liệu tốt/dễ làm thì làm
trước, không phần nào "chặn đường" phần khác. Nghiên cứu dưới đây bổ sung ứng viên cụ thể theo 3 cỡ:

- **Vùng đầy đủ** (10-15 màn, cỡ như Vùng 1-5) — cần đủ nhiều món/chain để chia 2-3 chương.
- **Nội dung phụ / trang lẻ** (1 chương lẻ, không cần "Vùng" bao quanh) — hợp khi chỉ có 1 món đặc trưng,
  hoặc muốn lấp thời gian giữa 2 Vùng lớn mà không cam kết cả 1 miền mới.
- **Sự kiện mùa** (như Vùng 6 Tết — mở theo lịch, không chặn tiến trình chính).

**Lưu ý tránh trùng** với món/chain đã dùng ở Vùng 1-5: gà, phở bò (rice/beef/broth/herbs/spice), cơm gà Hội
An, bánh mì, bún chả, trái cây (xoài/dứa/dừa/sầu riêng), hủ tiếu, hải sản (tôm/cá/mực/cua), mắm, cà phê, mật
ong, hồ tiêu, bánh chưng/mứt/hoa mai-đào (Tết) — các món dưới đây đều **khác** danh sách này.

#### Ứng viên Vùng đầy đủ

| Miền/khu vực | Món/chủ đề gộp thành 1 Vùng | Vì sao đủ chất liệu |
|---|---|---|
| Huế – Đà Nẵng (khác Hội An đã dùng ở Vùng 2) | Bún bò Huế, bánh tráng cuốn thịt heo, bánh bèo/nậm/lọc | 3 nhóm món rõ rệt, đủ chia 2-3 chương; bún bò Huế nằm trong top món ăn sáng được quốc tế xếp hạng cao ([Traveloka][8]) |
| Bắc Bộ (ngoài Hà Nội đã dùng phở/bún chả) | Bánh cuốn, cốm làng Vòng, bánh đa cua Hải Phòng, bún cá rô đồng Hải Dương | Mỗi món gắn 1 địa danh cụ thể (làng Vòng, Hải Phòng, Hải Dương) — dễ tách chain theo địa danh như Vùng 2 đang làm |
| Miền Tây sông nước (khác "Miệt vườn" Vùng 3 vốn thiên về trái cây) | Lẩu cá linh bông điên điển, gỏi sầu đâu, cá lóc nướng trui, bánh xèo | Đặc trưng mùa nước nổi — có thể gắn thêm cơ chế "mùa" nếu sau này muốn (không bắt buộc) ([Jamlos][9]) |
| Tây Bắc/Tây Nguyên (dân tộc thiểu số) | Cơm lam, thịt trâu gác bếp, rượu cần | **Cẩn trọng:** đây là văn hoá của các dân tộc thiểu số cụ thể (Thái, Ê Đê, Tây Nguyên…) — nếu làm, nên ghi rõ tên dân tộc thay vì gộp chung chung, và tham khảo thêm nguồn trước khi viết NPC/lời thoại, tránh rập khuôn |

#### Ứng viên nội dung phụ / trang lẻ (1 chương, không cần Vùng riêng)

Đây chính là "kho đề tài" đã nhắc ở Phương án C (STORY_CONCEPTS.md) — có thể mượn thẳng danh sách 32 Di sản
Văn hoá Phi vật thể **Quốc gia** (không phải UNESCO — xem lưu ý thuật ngữ ở STORY_CONCEPTS.md) làm nguồn xác
thực, dùng được **bất kể chọn phương án story nào** vì mỗi trang giờ độc lập:

| Món/nghề | Địa phương | Nguồn |
|---|---|---|
| Mì Quảng | Quảng Nam | Di sản quốc gia 8/2024, cùng đợt với phở Hà Nội ([Báo Hà Tĩnh][5]) |
| Cao lầu | Hội An | Đặc sản riêng của Hội An, có thể làm trang phụ ngay trong Vùng 2 đã có thay vì chờ Vùng mới |
| Chả cá (kiểu Lã Vọng) | Hà Nội | Món có gốc tích nhà hàng cụ thể — dễ viết 1 NPC "hậu duệ nghề gia truyền" |
| Nghề làm nem Lai Vung | Đồng Tháp | Di sản quốc gia đầu 2024 ([VietnamPlus][4]) |
| Bánh phồng Sơn Đốc, kẹo dừa | Bến Tre | Nghề thủ công, hợp làm "trang nghề" nhỏ hơn là món ăn |
| Tôm khô Cà Mau | Cà Mau | Nghề chế biến, hợp bổ sung cho Vùng 4 Biển đảo mà không cần Vùng mới |

#### Ứng viên sự kiện mùa (như Vùng 6 Tết)

| Sự kiện | Gắn với | Ghi chú |
|---|---|---|
| Tết Trung Thu | Bánh nướng, bánh dẻo — biểu tượng đoàn viên ([Badinh.quangngai.gov.vn][10]) | Mạnh ngang Tết — đề xuất ứng viên Vùng-sự-kiện thứ 2 rõ nhất |
| Giỗ Tổ Hùng Vương (10/3 âm lịch) | Mâm cúng bánh chưng/bánh dày tại Đền Hùng, Phú Thọ ([Wikipedia tiếng Việt][11]) | Nếu chọn Phương án B (Con Rồng cháu Tiên) ở STORY_CONCEPTS.md, đây là dịp **đúng nghĩa đen** để Cụ Từ xuất hiện — không cần bịa bối cảnh riêng |
| Tết Đoan Ngọ (5/5 âm lịch) | Bánh tro, rượu nếp cái | Sự kiện nhỏ hơn Tết/Trung Thu, hợp làm sự kiện ngắn ngày giữa năm |

---

### 2.2 Quy tắc mở khoá (mở rộng từ SPECS.md §7)

- Vùng mở khi **quá nửa số chương** của Vùng trước đã nấu xong (không cần 100%, để tránh ép chơi lại màn dở
  ghét).
- Trong 1 Vùng, các chương vẫn mở tuần tự như hiện tại.
- Vùng sự kiện (Tết…) mở độc lập theo lịch, không phụ thuộc tiến trình Vùng chính.

---

## 3. Mở rộng chuỗi vật phẩm (chains)

Giữ nguyên `ChainDef`/`TierDef`/`SkinDef` (SPECS.md §11.3) — đây là chỗ mạnh nhất của kiến trúc hiện tại vì
**không cần sửa core** để thêm nội dung. Chỉ mở rộng theo 2 trục:

### 3.1 Trục rộng — chủ đề mới cho từng Vùng

| Nhóm | Ví dụ chain | Vùng |
|---|---|---|
| Trái cây nhiệt đới | Xoài, Dứa, Dừa, Sầu riêng (skin theo tier trần như `herbs`/`spice` hiện tại) | 3 |
| Hải sản | Tôm, Cá, Mực, Cua | 4 |
| Chăn nuôi mở rộng | Heo, Bò sữa, Dê, Ong (mật) | 2, 5 |
| Nông sản cao cấp | Cà phê, Hồ tiêu, Trà | 5 |
| Bánh & bột | Lúa mì → bột mì → bánh mì / bánh chưng | 2, 6 |

### 3.2 Trục sâu — tier trần tăng dần theo Vùng

Vùng 1 dùng tier trần 4-5. Đề xuất tăng dần để mỗi Vùng mới **cần nhiều lượt gộp hơn cho cùng 1 nguyên
liệu**, tự nhiên kéo dài thời lượng chơi mà không cần thêm cơ chế:

| Vùng | Tier trần điển hình | Số ô tier-1 cần cho 1 ô tier trần |
|---|---|---|
| 1 | 4-5 | 8-16 |
| 2-3 | 5-6 | 16-32 |
| 4-5 | 6-7 | 32-64 |

Không tăng vô hạn — quá 7 tier thì lưới 5×5/6×6 không đủ chỗ thao tác (đã thấy ở mô phỏng: màn 2-5 tier 4
trên lưới 5×5 tỉ lệ thắng bot ngẫu nhiên chỉ 21%). Tier 7 là **trần kỹ thuật** đề xuất cho toàn game; sau đó
tăng độ khó bằng vật cản (§4.1) và nhiều mục tiêu hơn, không tăng tier nữa.

### 3.3 Skin và biến thể — dùng nhiều hơn ở Vùng sau

`skins` (đã có ở `herbs`, `spice`) là cách rẻ nhất để tăng biến thiên mà không tăng tier. Từ Vùng 3 trở đi,
**mặc định mọi tier trần đều có 2-3 skin** thay vì là ngoại lệ — tăng cảm giác "đổ xúc xắc" ở cuối màn.

---

## 4. Cơ chế mở rộng theo thời gian

Giữ nguyên toàn bộ luật lõi ở SPECS.md §3 (swipe, tap, split, spawn, overflow, thắng/thua, sao). Bốn cơ chế
dưới đây là lớp phủ thêm, bật dần theo Vùng — **mỗi Vùng chỉ giới thiệu đúng 1 cơ chế mới**, theo đúng
nguyên tắc "1 chương = 1 bài học" đã áp dụng ở Vùng 1.

### 4.1 Vật cản (obstacles) — ô ở giữa bàn

Đây là câu trả lời trực tiếp cho yêu cầu "thêm 1-2 ô ngăn ở giữa". Vật cản là **ô đặc biệt trên lưới, không
phải Tile thường** — không tier, không gộp được bằng luật thường.

| Vật cản | Vùng giới thiệu | Hành vi | Cách dọn |
|---|---|---|---|
| **Đá** | 2 (Cơm gà Hội An) | Chặn hoàn toàn 1 ô: Tile trượt tới sẽ dừng lại trước đá thay vì đi xuyên qua. Cắt line thành 2 đoạn khi resolve. | Không tự mất; số lượng đá là tham số độ khó của màn (thường 1-2 ô, đặt gần giữa bàn). |
| **Cỏ dại** | 2 (Bánh mì) | Sau mỗi N lượt, lan sang 1 ô trống liền kề (ưu tiên theo thứ tự cố định để test được). | Gộp/tách xảy ra *tại* ô cỏ sẽ dọn cỏ ở ô đó (ô trở thành ô thường + nhận Tile kết quả). |
| **Băng** | 2 (Bún chả) | Ô bị đóng băng: Tile trên ô đó không trượt đi được (đứng yên khi vuốt), nhưng vẫn tham gia gộp nếu ô liền kề trượt tới nó. | Sau khi Tile trên ô băng tham gia 1 phép gộp thành công, băng tan. |
| **Lưới đánh cá** | 4 (Biển đảo) | Ô chỉ thu hoạch được khi tap **2 lần liên tiếp** (lần 1 "kéo lưới", lần 2 mới thu hoạch thật) — mô phỏng việc phải kéo lưới lên. | Tự động dọn sau khi thu hoạch xong. |

**Nguyên tắc thiết kế vật cản (áp dụng cho mọi loại tương lai):**
1. Vật cản không bao giờ làm màn **bất khả thi** — luôn phải còn ít nhất 1 đường giải (kiểm bằng bot tham
   lam trong `sim/simulate.ts`, y như cách đang tune `moveLimit`).
2. Vật cản là **dữ liệu màn** (`initialObstacles` trong `LevelConfig`), không phải luật chain — cùng 1 loại
   vật cản dùng lại được ở mọi Vùng sau khi đã giới thiệu.
3. Số lượng vật cản tăng dần trong 1 Vùng (màn 1 của Vùng: 0 vật cản để làm quen barrier mới xuất hiện ở UI;
   màn boss: 2-3 vật cản), rồi **giữ ở mức nhẹ** khi sang Vùng kế — không cộng dồn tất cả loại vật cản cùng
   lúc trừ phi đó là màn boss "tổng ôn" cuối Vùng.

### 4.2 Màn nhiều giai đoạn (stage) — "chia nhỏ level"

Đáp ứng yêu cầu "có thể chia nhỏ ở các level sau". Từ Vùng 3, một màn có thể gồm **2-3 giai đoạn tuần tự**
trong cùng một lượt chơi, thay vì 1 bộ mục tiêu cố định từ đầu tới cuối:

```
Giai đoạn 1: mục tiêu nhỏ (vd 2 Xoài t3) → đạt xong →
  board cập nhật (thêm vật cản mới / đổi objective / thêm ô trống) →
Giai đoạn 2: mục tiêu tiếp theo, bàn cờ hiện tại được giữ nguyên (không reset) →
  ... → Giai đoạn cuối = điều kiện thắng màn (như hiện tại)
```

Lợi ích:
- Màn dài (nhiều lượt) không còn cảm giác "1 danh sách mục tiêu dài dằng dặc" — chia nhịp nghỉ, mỗi giai
  đoạn có cảm giác hoàn thành riêng (giống "hồi" trong 1 màn).
- Cho phép **mở khoá vật cản giữa chừng màn** (vd giai đoạn 1 dọn sạch bàn, giai đoạn 2 xuất hiện đá) mà
  không cần thêm màn mới trong danh sách level.
- Sao (§3.7 SPECS.md) vẫn tính trên tổng lượt cả màn — không đổi cách chấm sao.

Về dữ liệu: `LevelConfig` thêm trường tuỳ chọn `stages?: StageDef[]`, mỗi `StageDef` có `objectives` riêng
và `boardPatch` tuỳ chọn (thêm obstacle/ô trống). Khi không có `stages`, hành vi y hệt hiện tại (1 giai đoạn
ngầm) — **không phá vỡ level cũ**.

### 4.3 Lưới & tier tăng dần

| Vùng | Lưới mặc định | Lưới màn boss |
|---|---|---|
| 1 | 4×4 | 4×4-5×5 |
| 2-3 | 5×5 | 5×5 |
| 4-5 | 5×5-6×6 | 6×6 |

Lưới lớn hơn cần **spawn chậm hơn tương đối** (perTurn/diện tích) để không bù đắp hết lợi thế chỗ trống —
tiếp tục dùng `sim/simulate.ts` để tune thay vì đoán số.

### 4.4 Kết hợp nhiều chain trong 1 màn (multi-chain, Vùng 4+)

Màn `mixed` hiện tại đã trộn 1 chain (gộp + tách). Mở rộng thêm kiểu **`combo`**: bàn có 2 chain riêng biệt
cùng lúc (mỗi ô Tile gắn `chainId` của chính nó, gộp chỉ xảy ra giữa 2 ô **cùng chain và cùng tier**), mục
tiêu yêu cầu tổ hợp từ cả hai (vd 2 Tôm t3 + 1 Sả t2 → nguyên liệu "Tôm rang sả"). Đây là bước tăng độ khó
tư duy mà không cần thêm luật gộp mới — chỉ thêm điều kiện `canMerge` phải so cả `chainId` lẫn `tier`.

---

## 5. Hệ tiến trình meta — giữ chân dài hạn

Ngoài nội dung màn, cần lý do để người chơi quay lại giữa các đợt cập nhật Vùng mới:

| Hệ thống | Mô tả | Ghi chú kỹ thuật |
|---|---|---|
| **Nông trại mở rộng dần** | Farm hiện tại (SaveManager `decor[]`) chỉ hiện công trình đã mở. Thêm: đất phải **mua** bằng xu để đặt công trình mới, tự sắp xếp (đã ghi ở Phase 3 SPECS.md) — biến Farm thành nơi "khoe" tiến trình, không chỉ là màn hình liệt kê. | Mở rộng `SaveData.decor` thành có toạ độ; không đổi `cook()` flow. |
| **Sổ công thức (cookbook)** | Danh sách toàn bộ món/chain đã và chưa khám phá, kiểu "album sưu tập" — tăng cảm giác "còn nhiều thứ để làm" mỗi khi mở Vùng mới. | Thuần UI, đọc từ `CHAINS`/`CHAPTERS`, không cần state mới ngoài save hiện có. |
| **NPC vùng miền** | Mỗi Vùng có 1 nhân vật dẫn chuyện, xuất hiện ở đầu/cuối Vùng và trên Farm — xem §12.1. | Thuần data (`npcs.ts` + `npcId` trên `WorldDef`), UI chỉ chèn avatar/lời thoại vào dialog đã có. |
| **Bảng đơn hàng (order board)** | NPC vùng giao "đơn hàng" đổi thưởng — thay cho mô tả chung chung trước đây ("qua 3 màn đạt 2★"). Chia 2 tầng, xem §12.2. | Tầng A (đọc `SaveData.levels[id].stars` có sẵn, thêm `claimedOrders`) làm trước; tầng B mới cần `SaveData.dailyProgress`, reset theo ngày (client-side, chấp nhận gian lận đổi giờ máy ở bản không server). |
| **Sự kiện theo mùa (Vùng 6 Tết, và tương lai Trung Thu…)** | Nội dung giới hạn thời gian, thưởng trang trí độc quyền. | Vùng độc lập như đã nói ở §2.1. |
| **Vật phẩm hỗ trợ (đã ghi Phase 2 SPECS.md)** | Hoàn tác, Xẻng xoá 1 ô, +5 lượt — mua bằng xu. | Không đổi core, chỉ thêm hành động trong `GameSession` (undo cần lưu snapshot trước lượt). |

---

## 6. Kinh tế — mở rộng từ SPECS.md §8

Giữ nguyên 3 nguồn thu hiện tại (tự thu hoạch dư, sao, nguyên liệu lần đầu). Thêm:

- **Xu vẫn là đồng tiền chính**, dùng cho vật phẩm hỗ trợ + mua đất Farm.
- Không đề xuất thêm đồng tiền cứng (gems/kim cương) hay IAP ở giai đoạn này — sản phẩm chưa có server,
  thêm tiền tệ thứ 2 chỉ tăng phức tạp mà chưa rõ cần thiết. Để ngỏ cho Phase sau nếu quyết định monetize.

---

## 7. Cân bằng độ khó dài hạn

Mở rộng công thức ở SPECS.md §10.1, cộng thêm chi phí vật cản vào ước lượng ban đầu trước khi chạy sim:

```
minMoves ≈ Σ(target × 2^(tier−1)) ÷ p          # như hiện tại
         + rockPenalty(số ô đá)                 # ô đá loại bỏ khỏi diện tích khả dụng
         + weedPenalty(số ô cỏ, chu kỳ lan)     # mỗi ô cỏ chưa dọn ăn bớt ~1 ô trống/N lượt
         + stageOverhead(số giai đoạn)          # mỗi giai đoạn mới cộng thêm vài lượt "dọn bàn"
```

Quy trình tune **không đổi**: sửa số liệu → `npm run sim` → so bot tham lam với mục tiêu thắng theo Vùng
(gợi ý: Vùng 1 ~100%, các Vùng giữa ~75-80%, mọi màn boss ~65-70% — giữ đúng "hình răng cưa" đã quan sát ở
§10.3 SPECS.md, chỉ dịch chuẩn theo Vùng thay vì chương).

Việc cần làm ở `sim/simulate.ts`: bot cần biết xử lý vật cản (đá = ô không hợp lệ khi tính move; cỏ/băng cần
state riêng) trước khi có thể mô phỏng Vùng 2 trở đi — đây là **điều kiện tiên quyết kỹ thuật** trước khi
thiết kế màn có vật cản, nếu không sẽ tune độ khó bằng cảm tính và dễ sai như đã từng thấy với công thức
skin (SPECS.md §10.1 nhận xét công thức ước lượng dư so với thực tế khi có skin).

---

## 8. Thay đổi kiến trúc cần thiết (tóm tắt, chưa code)

Theo đúng nguyên tắc "core thuần, nội dung là data" (SPECS.md §11.1), các mở rộng dưới đây **có** đụng core
(khác với thêm chain/màn/chương là thuần data):

| Thay đổi | Vùng cần | Ảnh hưởng core |
|---|---|---|
| Ô vật cản (đá/cỏ/băng/lưới cá) | 2, 4 | `Board`: thêm khái niệm ô không phải Tile thường; `resolveLine` cần biết dừng line tại đá; `GameEvent` thêm sự kiện obstacle thay đổi trạng thái |
| `stages` trong `LevelConfig` | 3 | `GameSession`: theo dõi stage hiện tại, áp `boardPatch` khi chuyển stage; `ObjectiveTracker` reset theo stage |
| `combo` mode (multi-chain) | 4 | `Tile` thêm `chainId`; điều kiện gộp so thêm `chainId` |
| Undo / xẻng / +lượt | Phase 2 (đã ghi) | `GameSession` cần snapshot trước lượt cho undo |
| Farm đặt công trình tự do | Phase 3 (đã ghi) | `SaveData.decor` thêm toạ độ |

Đề xuất thứ tự implement: **vật cản đá trước** (đơn giản nhất, đã có 3 test-case tự nhiên từ resolveLine),
sau đó băng, cỏ dại, rồi mới tới `stages` (phức tạp hơn vì đụng vòng đời thắng/thua).

---

## 9. Lộ trình phát hành

| Giai đoạn | Nội dung | Tiền đề |
|---|---|---|
| **Phase 2a** | Vật cản Đá + Vùng 2 chương "Cơm gà Hội An" (3-5 màn) | Cần bot sim hỗ trợ đá trước (§7) |
| **Phase 2b** | Cỏ dại + Băng, hoàn thiện Vùng 2 (Bánh mì, Bún chả) | 2a |
| **Phase 2c** | Vật phẩm hỗ trợ (hoàn tác/xẻng/+lượt), bản đồ cuộn được (đã ghi SPECS.md) | Không phụ thuộc obstacle |
| **Phase 3a** | Vùng 3 Miệt vườn Nam Bộ + cơ chế `stages` | 2a, 2b |
| **Phase 3b** | Vùng 4 Biển đảo (Lưới đánh cá + `combo` mode) | 3a |
| **Phase 3c** | Sổ công thức; NPC vùng miền + Bảng đơn hàng tầng A (§12); nhiệm vụ ngày/tuần tầng B (§12.2) | Không phụ thuộc — làm song song bất kỳ lúc nào |
| **Phase 4** | Vùng 5 Cao nguyên, art thật thay emoji (đã ghi SPECS.md Phase 3) | — |
| **Phase 5+** | Vùng sự kiện Tết, các Vùng đặc sản mở thêm theo nhu cầu | Chỉ cần data mới nếu không thêm cơ chế |

---

## 10. Câu hỏi còn mở

1. **Undo/vật phẩm hỗ trợ dùng xu hay giới hạn số lần/ngày?** Ảnh hưởng cảm giác khó — chưa quyết.
2. **Sự kiện Tết có cần chặn bằng thời gian thực (ngày hệ thống) hay chỉ là 1 Vùng thường mở vĩnh viễn sau
   khi ra mắt lần đầu?** Đơn giản hơn là làm vĩnh viễn trước, thêm giới hạn thời gian sau nếu cần.
3. **Có cần thêm tiền tệ cứng (gems) khi bắt đầu tính đến monetize không, hay giữ chỉ 1 loại xu xuyên suốt?**
   Đề xuất giữ 1 loại tới khi có quyết định kinh doanh rõ ràng.
4. ~~Unity POC có kế thừa thiết kế này hay là nhánh thử nghiệm riêng?~~ **Đã chốt (2026-09-27):** bỏ hẳn
   Unity, nhánh `unity-poc` đã xoá. Chuyển hẳn sang Flutter+Flame (nhánh `flutter-app`), chỉ publish store
   (không web). Thiết kế ở tài liệu này áp dụng cho bản Flutter.

---

## 11. Nội dung chi tiết Vùng 2, Chương 3-5 — sẵn sàng chuyển thành data

> ⚠️ **Nhãn "Vùng 2" đã lỗi thời** (xem banner đầu file) nhưng **nội dung chain/màn/vật cản bên dưới vẫn tái
> dùng được nguyên vẹn** — chuyển sang làm 3 Chương trong "Hồi 2 — Ẩm thực Việt Nam", xem
> [docs/GAME_DESIGN_ACTS.md](./GAME_DESIGN_ACTS.md) §4.1. Không cần thiết kế lại phần này.

Cụ thể hoá §2.1/§4.1/§7 cho đúng 3 chương đã chốt ở `SPECS.md` (Đá → Ch.3 Cơm gà Hội An, Cỏ dại → Ch.4 Bánh
mì, Băng → Ch.5 Bún chả). Giữ đúng khuôn `ChainDef`/`ChapterDef`/`LevelConfig` hiện có (`src/core/types.ts`) +
phần schema mới còn thiếu (nêu ở §11.5). Theo đúng nguyên tắc "1 chương = 1 bài học": mỗi chương chỉ dùng
**một chain chính duy nhất** xuyên suốt 5 màn (như Chương 1), để toàn bộ độ khó tăng thêm đến từ đúng 1 cơ
chế vật cản mới — không trộn thêm biến thể mode/multi-chain ở đây.

Toàn bộ số `moveLimit`/số lượng vật cản dưới đây là **điểm khởi đầu theo công thức §7**, chưa chạy qua
`sim/simulate.ts` (bot cần biết xử lý vật cản trước — xem §11.6) — không đưa thẳng vào `levels.ts` khi chưa
tune.

### 11.1 Chương 3 · "Cơm gà Hội An" (giới thiệu Đá)

**Chain mới `shreddedChicken` (Gà xé)** — lưới 5×5, mode `merge` cả 5 màn.

| Tier | id | Tên | Emoji | Màu (placeholder) |
|---|---|---|---|---|
| 1 | raw | Ức gà tươi | 🍗 | `0xffe0c2` |
| 2 | poached | Gà luộc | 🥘 | `0xffc98b` |
| 3 | shredded | Gà xé | 🍽️ | `0xf4a259` |
| 4 | mixed | Đĩa gà trộn | 🥗 | `0xe76f51` |
| 5 | plate | Cơm gà đầy đủ | 🍛 | `0xbc6c25` |

`ChapterDef`: id `ch3`, tên "Chương 3 · Cơm gà Hội An", recipe `hoianchicken` (verb "Trộn", station 🍽️),
5 ingredient = đúng 5 tier trên, unlock decor "Xe cơm gà" 🛺.

| Màn | Tên | Objectives | Đá (số·vị trí) | moveLimit* | Ghi chú |
|---|---|---|---|---|---|
| 3-1 | Ức gà đầu mùa | t3×2 | 0 | ~16 | Giới thiệu chain, chưa có Đá — chỉ nhá UI tên cơ chế |
| 3-2 | Đá lấp đường mòn | t3×3 | 1 · (2,2) | ~22 | Đá đầu tiên đặt giữa bàn đúng nguyên tắc §4.1 |
| 3-3 | Gà trộn đầu tay | t3×2 + t4×1 | 2 · (1,2),(3,2) | ~30 | Cột giữa bị chẹn 2 đầu → ép trượt vòng |
| 3-4 | Ruộng đá Hội An | t4×2 | 2 · (2,1),(2,3) | ~30 | Đổi trục chẹn (hàng giữa) để không lặp pattern 3-3 |
| 3-5 | Cơm gà Hội An (Boss) | t5×1 + t3×2 | 4 · (1,1),(1,3),(3,1),(3,3) | ~46 | `boss:true`, 4 góc trong tạo ô "an toàn" hình chữ thập ở giữa |

\* Công thức: `Σ(target×2^(tier−1)) × 1.5~1.8 + rockPenalty(≈2/ô đá)` (§7).

### 11.2 Chương 4 · "Bánh mì" (giới thiệu Cỏ dại)

**Chain mới `wheat` (Lúa mì)** — lưới 5×5, mode `merge`.

| Tier | id | Tên | Emoji | Màu |
|---|---|---|---|---|
| 1 | grain | Hạt lúa mì | 🌾 | `0xf1e3c6` |
| 2 | dough | Bột mì | 🫓 | `0xe9c9a3` |
| 3 | crust | Vỏ bánh mì | 🥐 | `0xd8a973` |
| 4 | loaf | Ổ bánh mì | 🥖 | `0xc08552` |
| 5 | banhmi | Bánh mì thịt đầy đủ | 🥪 | `0x8a5a34` |

`ChapterDef`: id `ch4`, recipe `banhmi` (verb "Kẹp", station 🥪), unlock decor "Xe bánh mì" 🥖.

Cỏ dại: mỗi ô có toạ độ gốc, sau mỗi `spreadEvery` lượt lan sang 1 ô trống liền kề (thứ tự cố định
ưu, tiên phải→dưới→trái→trên, để test được như đề xuất §4.1). Dọn bằng gộp/tách **tại đúng ô đang có cỏ**.

| Màn | Tên | Objectives | Cỏ dại (gốc·spreadEvery) | moveLimit* | Ghi chú |
|---|---|---|---|---|---|
| 4-1 | Gieo lúa mì | t3×2 | 0 | ~18 | Giới thiệu chain, chưa có cỏ |
| 4-2 | Cỏ dại ven đường | t3×3 | 1 · (0,0) · N=4 | ~26 | Cỏ mọc góc, ít cản đường ban đầu |
| 4-3 | Bột mì đầu lò | t3×2 + t4×1 | 2 · (0,0),(4,4) · N=4 | ~34 | Cỏ mọc chéo 2 góc đối nhau |
| 4-4 | Ruộng cỏ um tùm | t4×2 | 2 · (0,4),(4,0) · N=3 | ~34 | Lan nhanh hơn (N=3) thay vì thêm số lượng |
| 4-5 | Bánh mì Sài Gòn (Boss) | t5×1 + t3×2 | 3 · (0,0),(4,4),(2,2) · N=3 | ~50 | `boss:true`, phủ cả 2 góc chéo + tâm |

\* Cùng công thức §7, `weedPenalty ≈ 1 ô trống/N lượt` (§7).

### 11.3 Chương 5 · "Bún chả" (giới thiệu Băng, chốt Vùng 2)

**Chain mới `pork` (Heo)** — lưới 5×5, mode `merge`.

| Tier | id | Tên | Emoji | Màu |
|---|---|---|---|---|
| 1 | belly | Ba chỉ heo | 🐖 | `0xffd9c4` |
| 2 | paste | Chả sống | 🧈 | `0xf0b48c` |
| 3 | ball | Chả viên | 🍡 | `0xd9895f` |
| 4 | grilled | Chả nướng | 🍢 | `0xb5622f` |
| 5 | bowl | Bún chả đầy đủ | 🍜 | `0x8a3f1e` |

`ChapterDef`: id `ch5`, recipe `buncha` (verb "Nướng", station 🍢), unlock decor "Quán bún chả" 🍜.

Băng: đặt tại 1 ô cụ thể ngay từ đầu màn (chồng lên `initialTiles` nếu ô đó có Tile, hoặc "chờ" Tile đầu
tiên trôi tới rồi đóng băng luôn Tile đó). Tile trên ô băng đứng yên khi vuốt nhưng vẫn được gộp nếu ô kề
trượt tới nó; băng tan ngay sau 1 phép gộp thành công tại ô đó.

| Màn | Tên | Objectives | Băng (vị trí) | moveLimit* | Ghi chú |
|---|---|---|---|---|---|
| 5-1 | Heo nhà nuôi | t3×2 | 0 | ~18 | Giới thiệu chain, chưa có băng |
| 5-2 | Sương giá sớm mai | t3×3 | 1 · (2,2) | ~24 | Băng đầu tiên, đặt giữa bàn |
| 5-3 | Chả viên đầu tay | t3×2 + t4×1 | 2 · (1,1),(3,3) | ~32 | 2 ô băng chéo nhau |
| 5-4 | Đêm đông lạnh giá | t4×2 | 2 · (1,3),(3,1) | ~32 | Đổi trục chéo còn lại |
| 5-5 | Bún chả Hà Nội (Đại boss Vùng 2) | t5×1 + t4×1 + t3×1 | **tổng hợp:** 2 Đá (1,1)(3,3) + 1 Cỏ dại (2,2)·N=3 + 2 Băng (1,3)(3,1) | ~58 | `boss:true` — màn "tổng ôn" cuối Vùng dùng cả 3 vật cản đã học, đúng ngoại lệ §4.1 mục 3 |

\* `icePenalty` chưa có công thức riêng trong §7 — tạm cộng như `rockPenalty` (ô băng cũng loại bỏ tạm thời
1 ô khỏi diện tích khả dụng cho tới khi gộp), cần bot sim xác nhận lại.

### 11.4 Cấu trúc Vùng (World) cần thêm

Chưa có tầng Vùng trong data (`ChapterDef` hiện không có trường world). Đề xuất thêm file `worlds.ts`:

```ts
export interface WorldDef {
  id: string;
  name: string;
  chapterIds: string[];
}
export const WORLDS: WorldDef[] = [
  { id: 'world1', name: 'Vùng 1 · Trại nhỏ', chapterIds: ['ch1', 'ch2'] },
  { id: 'world2', name: 'Vùng 2 · Miền Trung', chapterIds: ['ch3', 'ch4', 'ch5'] },
];
```

Quy tắc mở khoá §2.2 ("quá nửa số chương Vùng trước xong"): Vùng 1 chỉ có 2 chương nên quá nửa = cả 2 —
Vùng 2 mở đúng lúc người chơi nấu xong Tô phở bò (ch2), không đổi hành vi hiện tại.

### 11.5 Schema còn thiếu (đụng core, khác việc chỉ thêm data)

| Trường mới | Ở đâu | Việc cần |
|---|---|---|
| `ObstacleDef { type: 'rock' \| 'weed' \| 'ice'; row: number; col: number; spreadEvery?: number }` | `core/types.ts` | Kiểu dữ liệu obstacle |
| `initialObstacles?: ObstacleDef[]` | `LevelConfig` | Gắn obstacle vào màn, đúng như bảng trên |
| Board biết ô "rock" chặn line, `resolveLine` dừng tại đó | `core/board.ts`, `core/resolve_line.ts` | Đá |
| State cỏ dại (đếm lượt, vị trí lan) + state băng (đã tan chưa) | `core/game_session.ts` | Cỏ dại, Băng |
| `GameEvent` thêm `weedSpread`, `iceMelt` | `core/types.ts` | UI phản hồi khi vật cản đổi trạng thái |

Đúng thứ tự implement đã đề xuất ở §8: **Đá trước** (đơn giản nhất), rồi Băng, rồi Cỏ dại.

### 11.6 Việc cần làm trước khi đưa số liệu trên vào code thật

1. `sim/simulate.ts`: bot tham lam cần hiểu ô đá là bất hợp lệ khi tính nước đi, và có state riêng cho
   cỏ/băng (đúng như đã ghi ở §7) — **chưa làm được thì không tune được `moveLimit` ở trên, chỉ là số đoán**.
2. Sau khi bot chạy được, lặp: sửa `moveLimit`/vị trí vật cản → `npm run sim` → so tỉ lệ thắng bot với mục
   tiêu Vùng 2 (~75-80% màn thường, ~65-70% màn boss, theo §7).
3. Asset thật: emoji/màu ở trên là placeholder giống 6 chain hiện có — thay khi có art thật (đã ghi trong
   task `flutter-app-5`).

---

## 12. NPC vùng miền & Bảng đơn hàng — cụ thể hoá §5

> ⚠️ **Bảng 5 NPC "theo Vùng" ở §12.1 đã lỗi thời** (không còn 5 Vùng theo miền) — nhưng **cơ chế `NpcDef`/
> `NpcLines` và Bảng đơn hàng (order board) 2 tầng bên dưới vẫn dùng nguyên**, chỉ đổi gắn NPC theo Hồi thay
> vì theo Vùng, và Order Board Tầng A đổi thành "Chợ" ở Hồi 1 — xem
> [docs/GAME_DESIGN_ACTS.md](./GAME_DESIGN_ACTS.md) §3.2.

Hai ý tưởng rút từ soi các game merge/farm-sim tương tự (Merge Mansion/Gardenscapes cho lớp nhân vật dẫn
chuyện, Hay Day/Township cho bảng đơn hàng), chọn lọc lại cho khớp kiến trúc hiện tại. Cả hai đúng nguyên
tắc "core thuần, nội dung là data" (§11.1 SPECS.md): không sửa `src/core`, chỉ thêm data + chèn thêm vào UI
dialog đã có (`LevelIntroDialog`, `LevelResultDialog`, HomeScreen/Farm).

### 12.1 NPC theo Vùng

Mỗi **Vùng** (không phải mỗi Chương, để giữ chi phí asset thấp — 5 avatar cho v1.0 thay vì 12 theo số
chương) có đúng 1 nhân vật gắn với vùng miền, xuất hiện ở đầu/cuối Vùng và đứng ở Farm cạnh công trình vùng
đó đã mở khoá:

| Vùng | NPC | Vai trò gợi ý |
|---|---|---|
| 1 — Trại nhỏ | Bà Năm | Chủ quán ăn nhỏ trong làng, dạy nấu gà/phở |
| 2 — Miền Trung | Chú Sáu | Người gốc Hội An/Huế, biết cả 3 món (cơm gà, bánh mì, bún chả) |
| 3 — Miệt vườn Nam Bộ | Dì Ba | Chủ vườn trái cây, mối quen bán hủ tiếu |
| 4 — Biển đảo | Anh Hải | Ngư dân, biết nghề làm mắm |
| 5 — Cao nguyên | Ông Bảy | Chủ rẫy cà phê/hồ tiêu, nuôi ong lấy mật |

Data model, file mới `npcs.ts` (giữ đúng khuôn `ChainDef`/`ChapterDef` — tách data khỏi core):

```ts
interface NpcLines {
  onWorldEnter: string;        // hiện ở LevelIntroDialog, màn đầu tiên của World
  onChainFirstUnlock?: string; // hiện khi lần đầu thấy 1 chain mới của World (tuỳ chọn, có thể bỏ ở v1.0)
  onWorldComplete: string;     // hiện ở LevelResultDialog, màn cuối cùng của World
}
interface NpcDef { id: string; name: string; avatarEmoji: string; worldId: string; lines: NpcLines }
```

`WorldDef` (đã đề xuất ở §11.4) thêm 1 trường `npcId: string` để nối World ↔ NPC — không cần bảng tra cứu
riêng.

Hiển thị: `LevelIntroDialog`/`LevelResultDialog` chèn thêm 1 dòng avatar+thoại tuỳ chọn (`npcLine?: string`
truyền vào constructor) khi màn đang vào/vừa qua là màn đầu/cuối của 1 World — logic chọn `npcLine` nằm ở
tầng gọi dialog (HomeScreen/GameScreen), dialog tự thân không cần biết gì về World. Farm: NPC đứng cạnh
decor World đó, tap vào hiện 1 dòng flavor ngẫu nhiên (rút từ mảng `lines` cố định, không cần thêm state) —
phần này là "làm cho thêm" (nice-to-have), có thể bỏ qua ở v1.0 nếu thiếu thời gian mà không ảnh hưởng phần
còn lại.

### 12.2 Bảng đơn hàng (order board)

**Ràng buộc từ kiến trúc hiện tại** (khác giả định ban đầu khi so với Hay Day): `cook()` trừ mỗi nguyên
liệu đúng 1 đơn vị và mỗi Chương chỉ nấu **một lần** (SPECS.md §7); `SaveData.inventory`/`recordWin` chỉ
cộng +1 mỗi nguyên liệu **ở lần qua màn đầu tiên** (SPECS.md §8, `save_manager.dart` giữ y nguyên hành vi
này) — chơi lại không tích thêm nguyên liệu vào kho. Vì vậy **không thể** làm đơn hàng kiểu "giao nộp N
nguyên liệu từ kho dư" mà không thêm hẳn 1 cơ chế tích trữ dư mới (đụng core). Chia làm 2 tầng để tầng rẻ
làm được ngay:

**Tầng A — không đụng core, làm được ngay cùng đợt với §12.1:**
Đơn hàng đọc thẳng dữ liệu **đã có sẵn** trong `SaveData.levels[id].stars`, không cần state chơi mới ngoài
1 danh sách nhỏ để tránh phát thưởng trùng:

- Mỗi Vùng có 3-5 đơn **cố định, không refresh** do NPC vùng đó giao, kiểu: "Đạt 3★ ở màn 2-2", "Tổng ≥ 8
  sao trong cả Vùng 2", "Nấu xong Chương Bún chả".
- Hoàn thành → thưởng xu 1 lần (không lặp lại).
- State mới tối thiểu: `claimedOrders: Set<string>` (id đơn đã nhận thưởng) trong `SaveData` — không phải
  luật chơi, chỉ là cờ chống phát thưởng 2 lần.
- Vì đọc dữ liệu đã lưu sẵn, đơn hàng Tầng A **hoạt động ngay cả với save cũ** đã chơi trước khi tính năng
  ra mắt (không cần migrate dữ liệu).

**Tầng B — bản lặp lại hàng ngày, cần `dailyProgress` đã phác ở §5 (làm sau, đúng lịch Phase 3c):**
Đơn dựa trên đếm hành động trong ngày (số màn ≥2★ trong ngày, số ô tier≥3 đã gộp, số lần thu hoạch) — cần
`GameSession` phát thêm sự kiện đếm được và `SaveManager` cộng dồn vào `dailyProgress`, reset theo ngày. Đây
mới là phần thật sự đụng `core/` như đã cảnh báo ở §5, khác hẳn Tầng A.

**Thứ tự đề xuất:** làm NPC (§12.1) + Order Tầng A (§12.2) cùng lúc — dùng chung 1 màn hình "Bảng đơn hàng"
mới (liệt kê đơn theo Vùng, giao diện tương tự `LevelResultDialog` hiện có), text do NPC vùng "nói". Order
Tầng B gộp chung lịch với `dailyProgress`/nhiệm vụ ngày ở Phase 3c (§9) — không làm trước khi Tầng A đã có
người chơi thật xác nhận là đủ vui, tránh tốn công cho state phức tạp hơn nếu chưa cần.

---

## 13. Cốt truyện xuyên suốt — "Sổ tay của Bà Năm" *(đã thay thế)*

> ⚠️ **Đã thay thế (2026-09-28).** User chọn thiết kế lại từ đầu thay vì chọn giữa 4 phương án ở
> `STORY_CONCEPTS.md` — xem cốt truyện mới ("cô gái thành thị thừa hưởng nông trại") ở
> [docs/GAME_DESIGN_ACTS.md](./GAME_DESIGN_ACTS.md) §1. `STORY_CONCEPTS.md` cũng coi như lỗi thời. Giữ lại
> nội dung cũ bên dưới để tham khảo (1 NPC — Bà Năm — vẫn tái dùng được trong bản mới, làm người để lại
> nông trại đã mất thay vì còn sống dẫn dắt trực tiếp).

Trả lời trực tiếp yêu cầu "cần 1 story concept để kéo dài nội dung": §12.1 đã có 5 NPC theo Vùng nhưng họ
đang là 5 người xa lạ không liên quan nhau — không có lý do trong-truyện để người chơi lần lượt đi gặp từng
người, và không có khung để "Vùng 7+" luôn có chỗ đứng tự nhiên. Mục này thêm đúng 1 khung chung nối họ lại,
**không thêm field dữ liệu mới nào** — chỉ là nội dung đổ vào `NpcLines.onWorldEnter`/`onWorldComplete` đã
có sẵn ở §12.1.

**Cấu trúc tuyển tập, không phải mạch nối tiếp:** ban đầu mỗi Vùng được nối bằng cách NPC trước nhắc tên NPC
sau (kiểu "chú Sáu kể có dì Ba ở miệt vườn") — nhưng vậy tạo ra 1 chuỗi phụ thuộc: nếu sau này 1 Vùng bị trì
hoãn, đổi thứ tự, hoặc tư liệu/nội dung cho Vùng đó yếu hơn dự kiến, cả chuỗi phía sau nó bị treo (Vùng đã
xong rồi mà lại nhắc tên 1 người chưa tồn tại). Bảng ở §13.2 dưới đây đã sửa lại: **mỗi Vùng là 1 mục độc
lập trong sổ**, chỉ liên hệ với Bà Năm/cuốn sổ (khung chung), không liên hệ với Vùng khác — thêm, bớt, đổi
thứ tự, hay để 1 Vùng "yếu" nằm im chưa làm đều không ảnh hưởng phần còn lại.

### 13.1 Tiền đề

Bà Năm (NPC Vùng 1, đã có) không chỉ là chủ quán ăn nhỏ trong làng — hồi trẻ bà từng đi khắp ba miền học
nghề nấu ăn, quen biết một người ở mỗi vùng, rồi ngừng lại để mở quán nhỏ nuôi cháu. Bà có 1 cuốn **sổ tay
cũ**, ghi chép công thức + tên/nơi ở của từng người bạn đó, nhưng bỏ dở — nhiều trang còn trống, nhiều cái
tên còn chưa có công thức đi kèm. Người chơi là cháu của bà, về quê phụ dựng lại chuồng gà/quán phở (Vùng 1,
đúng nội dung đang có). Sau khi xong Vùng 1, bà đưa cuốn sổ cho cháu, nhờ đi tiếp giúp bà — vì chân bà không
còn đi xa được nữa.

Không có phản diện, không có twist — mạch cảm xúc là **hoài niệm + gìn giữ**: mỗi công thức không ghi lại
kịp coi như mất luôn. Đủ nhẹ cho 1 game casual, nhưng đủ lý do để "đi tiếp" và đủ ấm để giữ chân.

### 13.2 Vòng cung mỗi Vùng — dùng đúng 2 hook đã có sẵn ở NpcDef

Mỗi Vùng chỉ cần 2-3 câu, đổ vào đúng 2 trường đã thiết kế ở §12.1 (`onWorldEnter`, `onWorldComplete`) —
không cần thêm UI hay state mới. Ngay từ Vùng 1, bà Năm đưa cháu cuốn sổ đã ghi sẵn **tên + nơi ở** của cả 4
người còn lại (không phải nghe kể dần) — mỗi Vùng sau chỉ lật đúng 1 trang đã có sẵn tên, không có Vùng nào
cần biết tới Vùng khác:

| Vùng | NPC | `onWorldEnter` (khi vào Vùng) | `onWorldComplete` (khi nấu xong Chương cuối Vùng) |
|---|---|---|---|
| 1 | Bà Năm | (giữ nguyên phần mở đầu game hiện có) | Bà đưa cuốn sổ cũ, nhờ cháu đi tiếp — sổ đã có sẵn vài cái tên/địa danh, chưa có công thức |
| 2 | Chú Sáu | Cháu lật đúng trang ghi "Chú Sáu, Hội An" — chú nhận ra ngay "cháu bà Năm à" | Chú Sáu viết thêm công thức vào đúng trang đó — xong 1 trang |
| 3 | Dì Ba | Trang khác trong sổ: "Dì Ba, miệt vườn" | Dì Ba viết thêm công thức vào trang của mình — xong 1 trang |
| 4 | Anh Hải | Trang khác: "Anh Hải, biển đảo" | Anh Hải viết thêm công thức vào trang của mình — xong 1 trang |
| 5 | Ông Bảy | Trang cuối cùng có sẵn tên: "Ông Bảy, cao nguyên" | Ông Bảy viết thêm công thức — hết những trang bà Năm đã ghi tên sẵn từ trước |

Mỗi Vùng chỉ cần đúng 3 chi tiết cố định — **tên NPC, địa danh, món ăn** — không cần biết gì về NPC khác.
Không cây hội thoại, không lựa chọn, không tốn công localize nhiều hơn hiện tại. Người chơi không có tên/
thoại riêng (nhân vật câm, gọi là "cháu" — chuẩn thể loại casual, khỏi tốn chi phí giọng nói/bản dịch theo
ngôi).

### 13.3 Mốc kết Vùng 5 (hết v1.0) — không phải kết thúc game

Sau Vùng 5 (§2.1a), quay lại Bà Năm: mở lễ khai trương **"Quán Ba Miền"** — 1 công trình Farm mới, to nhất,
chỉ mở khi cả 5 Chương chính đã nấu xong (đúng cơ chế `decor`/`cook()` hiện có, không cần state mới). Câu
thoại đóng: cuốn sổ **vẫn còn vài trang trống cuối cùng** — bà Năm nói "chắc còn ai đó bà quên mất tên". Đây
là lý do trong truyện cho Vùng 6 (Tết — trang riêng của sổ, "trang nào cũng có 1 cái Tết") và Vùng 7+ (mỗi
trang trống là 1 vùng/món mở rộng sau này) **không cần viết lại cốt truyện mỗi lần thêm Vùng** — khung
"cuốn sổ chưa đầy" tự nhiên chừa chỗ vô hạn, đúng yêu cầu "kéo dài nội dung".

### 13.4 Vì sao khung này kéo dài được mà không tốn công tuyến tính

- **Không phụ thuộc Vùng khác** — mỗi Vùng chỉ cần biết tên/địa danh/món của chính nó (đã có sẵn trong sổ từ
  Vùng 1), không cần biết gì về Vùng trước hay Vùng sau — viết độc lập, làm theo thứ tự nào cũng được, đúng
  nguyên tắc "Vùng là level pack" ở §1 và đúng lo ngại "nguồn content có thể yếu nếu chạy 1 mạch thẳng".
- **Nguồn đề tài không giới hạn trước** — Việt Nam còn rất nhiều đặc sản chưa dùng (đã liệt kê sẵn ở "Vùng
  7+" trong §2.1: chả cá, bánh xèo, chè, mì Quảng, cao lầu…), mỗi cái là 1 "cái tên trong sổ" hợp lý, không
  cần bịa lý do mới.
- **Chi phí viết cố định mỗi Vùng mới**: đúng 2 câu (`onWorldEnter` + `onWorldComplete`) + tên NPC mới trong
  bảng §12.1 — không tăng theo số Vùng đã có trước đó.
- **Sổ công thức (cookbook, đã ghi ở §5)** trở thành đúng nghĩa đen "cuốn sổ của bà Năm" trong UI thay vì 1
  màn hình liệt kê chung chung — không cần xây thêm màn hình mới cho story, chỉ đổi khung/tên gọi màn hình
  đã có trong kế hoạch.

### 13.5 Việc cần làm khi implement (thuần data, không đụng core)

1. `npcs.ts`/`NpcDef` (§12.1): điền `lines` theo bảng §13.2 cho 5 NPC hiện có.
2. Farm: thêm 1 `DecorDef` "Quán Ba Miền", `unlocks` khi *cả 5* Chương chính (không tính Vùng 6 Tết) đã
   `cooked` — kiểm tra ở tầng gọi `cook()`, không sửa `SaveManager.cook()`.
3. Màn hình "Sổ công thức" (§5, chưa code): đổi khung hiển thị thành trang sổ tay (mỗi Vùng = vài trang),
   NPC + `onWorldComplete` hiện lại khi lật tới trang Vùng đó đã xong — thuần UI, đọc dữ liệu đã lưu sẵn.
4. Không cần đổi `LevelIntroDialog`/`LevelResultDialog` ngay — có thể chèn `npcLine` vào 2 dialog này sau,
   đúng như đã ghi ở §12.1, khi nào rảnh tay.

---

### Nguồn tham khảo (§2.1b)

- [4] [Tìm hiểu về 32 Di sản Phi vật thể Quốc gia liên quan đến ẩm thực của Việt Nam – VietnamPlus](https://www.vietnamplus.vn/tim-hieu-ve-32-di-san-phi-vat-the-quoc-gia-lien-quan-den-am-thuc-cua-viet-nam-post971858.vnp)
- [5] [Toàn bộ 32 di sản phi vật thể Quốc gia về ẩm thực Việt Nam – Báo Hà Tĩnh](https://baohatinh.vn/toan-bo-32-di-san-phi-vat-the-quoc-gia-ve-am-thuc-viet-nam-post274765.html)
- [8] [Khám phá thế giới đặc sản Việt Nam khắp 3 miền – Traveloka](https://www.traveloka.com/vi-vn/explore/culinary/dac-san-viet-nam/146236)
- [9] [Top 9 các món ăn Việt Nam đặc sản 3 miền – Jamlos](https://www.jamlos.com/blogs/bat-trend/mon-an-viet-nam)
- [10] [Ý nghĩa Tết Trung thu ở Việt Nam – Cổng TTĐT xã Ba Đình, Quảng Ngãi](https://badinh.quangngai.gov.vn/gioi-thieu/tin-chi-dao-dieu-hanh/tuyen-truyen/y-nghia-tet-trung-thu-o-viet-nam.html)
- [11] [Giỗ Tổ Hùng Vương – Wikipedia tiếng Việt](https://vi.wikipedia.org/wiki/Gi%E1%BB%97_T%E1%BB%95_H%C3%B9ng_V%C6%B0%C6%A1ng)

---

*Tài liệu này không thay thế SPECS.md. Khi 1 mục ở đây được code xong, dời phần mô tả "as-built" sang
SPECS.md và xoá/rút gọn ở đây.*
