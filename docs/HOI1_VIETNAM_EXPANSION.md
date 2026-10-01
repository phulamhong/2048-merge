# Hồi 1 — Bản "Việt hoá": 12 tháng nông lịch, trái cây/hoa đầy đủ, chuồng trước — con sau

> **Bổ sung:** cốt truyện xuyên suốt 48 Tập + hệ vật cản/tác nhân v2 (sâu, chuột, chim, ruồi, nấm, nước dâng, ao, gò…) nằm ở [`HOI1_STORY_AND_HAZARDS.md`](HOI1_STORY_AND_HAZARDS.md); bản đồ chương → Tập → vật cản ở [`hoi1_story_map.csv`](hoi1_story_map.csv).

> **Cập nhật (v5)** cho `HOI1_MASTER_DESIGN.md` và `HOI1_ASSET_CATALOG.md`. Khi mâu thuẫn, **file này thắng**.
> Dữ liệu gốc dạng máy đọc được: [`hoi1_assets.csv`](hoi1_assets.csv) (313 dòng, mọi số liệu dưới đây được tính
> từ file đó, không gõ tay). Các con số màn/`moveLimit` vẫn là thiết kế khởi điểm, **chưa sim**.

---

## 0. Thay đổi so với v4

| Hạng mục | v4 (Master) | v5 (file này) |
|---|---|---|
| Khung thời gian | 10 Phần, "mùa mưa → Tết" | **12 Phần = 12 tháng âm lịch**, từ Xuân này đến Xuân sau |
| Asset | 140 | **294** (+ 19 chương Phiên chợ/Lễ hội) |
| Trái cây | 25 | **52** (+ giống địa phương làm "skin" sưu tầm) |
| Hoa | 4 | **28** |
| Rau củ & gia vị | 22 | **44** |
| Ngũ cốc / lá gói bánh | 8 | **16** |
| Vật nuôi | 18 | **27** |
| Chế biến (mứt/bánh/khác) | 30 | **70** (20 mứt · 22 bánh · 28 khác) |
| Công trình | 29 | **51** + 6 chain vật liệu (thêm `bamboo`, `thatch`) |
| Tổng màn | 997 | **1.976** (bản Lõi **1.055**) |
| Quy tắc mới | — | **Chuồng/nhà xây trước, con vật/sản phẩm mở sau** (§6) |

**Làm sao vẫn giữ mục tiêu ~1.000 màn?** Mỗi asset được gắn **ưu tiên**:

- **S — Lõi** (167 dòng CSV = **1.055 màn**): toàn bộ nội dung v4 + các công trình bắt buộc theo
  quy tắc "chuồng trước" + 4 công trình đặc trưng Việt Nam (Sân phơi, Lò đường, Bến xuồng, **Chợ nổi**).
- **A — Mở rộng Việt hoá** (+**921 màn**): toàn bộ chương "mini" (trái cây/rau/hoa phụ), món chế biến mới…
  Phát hành thành **gói theo Phần** sau bản Lõi (§10).

---

## 1. Bốn nguyên tắc "Việt Nam hoá"

1. **Đi theo lịch âm.** Mỗi Phần = 1 tháng nông lịch, gắn 1 dịp lễ/tết thật (Nguyên Tiêu, Thanh Minh, Phật Đản,
   Đoan Ngọ, Vu Lan, Trung Thu, Cơm mới, Ông Táo, Tết…). Mùa nào thức nấy: rau, trái, hoa, món ăn ở mỗi Phần
   đúng mùa thật của nó.
2. **Nền miền Tây, có "giống vùng" khắp nước.** Nông trại ở đồng bằng sông Cửu Long (khớp nhân vật đã vẽ):
   xuồng, cầu khỉ, chợ nổi, mùa nước nổi. Những giống nổi tiếng vùng khác (vải thiều Lục Ngạn, bưởi Diễn, cam Cao
   Phong, hồng Đà Lạt…) xuất hiện như **skin sưu tầm** (§3.2), không cần thêm chương.
3. **Chuồng trước, con sau** (§6) — nhất quán cho mọi vật nuôi, đặc biệt **Nhà ong**.
4. **Ăn uống & nghi lễ là nội dung chơi**, không chỉ trang trí: mâm ngũ quả, bánh Hàn Thực, bánh tro Đoan Ngọ,
   cá chép ông Táo, bánh chưng/tét, mứt Tết đều là chương/màn thật.

---

## 2. Lịch 12 Phần

Số liệu tính từ CSV. "Lõi" = màn ưu tiên S, "Tổng" = S + A.

| Phần | Tháng âm — dịp | Tên Phần | Chương | Màn Lõi | Màn Tổng |
|---|---|---|---|---|---|
| **P1** | Giêng — Nguyên Tiêu (Rằm tháng Giêng) | Dọn Vườn Xưa | 12 | 61 | 75 |
| **P2** | Hai–Ba — Thanh Minh, Hàn Thực (3/3) | Vườn Rau Đầu Xuân | 30 | 119 | 191 |
| **P3** | Tư — Phật Đản (8/4) | Đàn Gia Súc & Sen | 21 | 113 | 141 |
| **P4** | Năm — Đoan Ngọ (5/5) | Vườn Cây Đầu Hè | 21 | 73 | 135 |
| **P5** | Sáu — mùa mưa, trái cây miền Tây rộ | Vườn Cây Miền Tây | 25 | 84 | 163 |
| **P6** | Bảy — Vu Lan (Rằm tháng Bảy) | Ruộng Đồng & Vu Lan | 27 | 103 | 165 |
| **P7** | Tám — Trung Thu (15/8) | Vườn Củ & Trung Thu | 38 | 114 | 249 |
| **P8** | Chín — mùa nước nổi | Mùa Nước Nổi | 33 | 54 | 215 |
| **P9** | Mười — Cơm mới (Tết Thường Tân 10/10) | Cơm Mới, Ong & Lò Bánh | 19 | 94 | 124 |
| **P10** | Mười Một — vào vụ cây Tết | Cây Tết & Vườn Hoa | 32 | 60 | 203 |
| **P11** | Chạp — Ông Công Ông Táo (23/12), gói bánh | Xưởng Mứt & Ông Táo | 38 | 146 | 257 |
| **P12** | Tết — 30 Tết → mùng 1 | Chợ Xuân & Chợ Nổi | 11 | 34 | 58 |
| | | **Tổng** | **307** | **1.055** | **1.976** |

*(Chương 307 = 313 dòng CSV − 6 chain vật liệu không có chương riêng.)*

**Lưu ý cân bằng:** P7 (249) và P11 (257) nặng nhất — nhưng phần lớn là mini/A nên bản Lõi vẫn đều (54–146 màn/
Phần). P1 và P12 nhẹ có chủ ý (mở đầu dễ thở, kết Hồi tập trung cảm xúc).

### 2.1 Nội dung chính từng Phần

| Phần | Trái cây | Rau / cây | Hoa | Vật nuôi | Chế biến | Công trình chính |
|---|---|---|---|---|---|---|
| P1 | — | rau muống, cải xanh, cà chua, dưa leo; mồng tơi, rau má | mai | gà | — | Chuồng gà, Giếng, **Sạp chợ** |
| P2 | — | bí đỏ/xanh, mướp, khổ qua, cà tím, ớt, cà rốt, củ cải, đậu bắp, xà lách; +6 mini | cúc; vạn thọ, thược dược | thỏ, vịt | **bánh trôi, bánh chay** (Hàn Thực) | Nhà kính, Máy bơm, **Kho nhỏ**, Chuồng thỏ, Ao vịt, Bếp củi |
| P3 | — | hạt sen | **sen**; nhài, ngọc lan, loa kèn | gà thịt, heo, bò sữa, dê, ngan, cút, ngỗng | sữa chua, phô mai, bơ | Chuồng heo/bò/dê, Trại gia cầm, **Kho thức ăn** |
| P4 | chuối, xoài, thơm, dưa hấu, đu đủ, ổi, mận, khế, mãng cầu + 5 mini | lúa nếp | — | — | **bánh tro, rượu nếp** (Đoan Ngọ) | Giàn tưới, Lò rượu, Nhà sấy trái cây |
| P5 | sầu riêng, chôm chôm, nhãn, vải, măng cụt, mít, **dừa**, thanh long + 6 mini | — | phượng vĩ, bằng lăng, dâm bụt | bồ câu | nước ép, nước cốt dừa | **Kho lạnh**, Nhà sơ chế, Chuồng bồ câu |
| P6 | — | **lúa**, ngô, đậu nành, đậu phộng, mía, trà, mè | hướng dương; hoa sứ, mười giờ, hoa giấy | trâu | đường mía, trà, tương, đậu hũ, sữa đậu nành, dầu lạc, bún tươi | Cối xay, **Kho lúa**, **Sân phơi**, Lò đường, Chuồng trâu, Xe trâu, Xưởng đậu hũ |
| P7 | bưởi, hồng xiêm, táo, lựu + 5 mini (hồng, thị, lê, sim, hồng bì) | khoai lang/tây, hành tây, tỏi, **gừng**, nghệ, bắp cải, đậu xanh, hạt điều, tiêu; +6 mini | hoa sữa, cúc họa mi, tam giác mạch | — | bánh dẻo, miến, tinh dầu sả | Xe tải (Anh Tài), Cầu khỉ, Chòi canh, Hầm ủ phân |
| P8 | 5 mini (cà na, trám, lê ki ma, bơ, chanh dây) | 7 mini (ngó súng, **điên điển**, rau lang, măng tre, cải thảo, dưa gang, su hào), thốt nốt | hoa súng, lục bình | cá rô phi, tôm, cua, lươn + cá lóc, **cá linh**, ếch, ốc bươu, cá tra | trứng muối, mắm cá linh, khô cá lóc, đường thốt nốt | Ao cá, **Bến xuồng**, Bè cá tra, Ao đặc sản |
| P9 | — | — | — | **ong mật**, tằm, ba ba | mật ong, giấm, **cốm**, bánh cốm/giầy + 6 bánh nướng | **Nhà ong**, Nhà tằm, **Lò bánh**, Kho bột |
| P10 | cam, quýt, chanh, nho + đào, mơ, dâu tây | lá dong, lá chuối, lá gai, lá dứa | đào, đồng tiền, lan hồ điệp, trạng nguyên, hồng, cẩm chướng, quất kiểng, lay ơn | chó giữ trại (**Mực**), chim yến | dưa cải, cà pháo muối, ô mai, yến sào | Vườn ươm, **Xưởng mứt**, Chuồng chó, Sân lu, Nhà yến |
| P11 | gấc, cau, sung | — | — | cá chép (ông Táo) | **20 loại mứt**, bánh chưng/tét/ú/da lợn/gai/phu thê, dầu dừa, kẹo dừa | Quầy Tết, Bếp ninh lớn, Gian trưng bày |
| P12 | — | — | — | — | bánh cam/in/pía/giò | **Chợ Xuân**, **Chợ nổi**, Kho tổng, Cổng chào |

---

## 3. Trái cây — 52 loại đầy đủ

### 3.1 Theo mùa & Phần

| Nhóm | Loại (Phần) |
|---|---|
| **Chương chính** (7 màn, 25 loại) | P4: chuối, xoài, thơm, dưa hấu, đu đủ, ổi, mận, khế, mãng cầu · P5: sầu riêng, chôm chôm, nhãn, vải, măng cụt, mít, dừa, thanh long · P7: bưởi, hồng xiêm, táo, lựu · P10: cam, quýt, chanh, nho |
| **Chương mini** (5 màn, 27 loại) | P4: roi, cóc, sơ ri, dâu da, me · P5: vú sữa, bòn bon, dâu tằm, nhót, mãng cầu xiêm, thanh trà · P7: hồng, thị, lê, sim, hồng bì · P8: cà na, trám, lê ki ma, bơ, chanh dây · P10: đào, mơ, dâu tây · P11: gấc, cau, sung |

Chương "mini": chain 4–5 tier, dùng ảnh template dùng chung cho tier 1–2, chỉ vẽ riêng tier chót (quả chín).
Cấu trúc màn: khuôn T5-mini (5 màn: T3×2 · T3×3 · T4×1+T3 · T4×2 · **boss T5×1+T4×1**) — nhẹ hơn khuôn 7 màn.

### 3.2 Giống địa phương — skin sưu tầm (không tốn chương)

Tier chót (quả chín) của 9 loại có nhiều **giống nổi tiếng** → mỗi lần thu hoạch xuất hiện ngẫu nhiên 1 giống.
Người chơi **sưu tầm đủ giống** trong "Album giống" để nhận thưởng.

| Trái | Giống (skin) | Vùng |
|---|---|---|
| Chuối | tiêu · sứ · cau | Bắc/Nam |
| Xoài | cát Hòa Lộc · cát chu · tượng | Tiền Giang/Đồng Tháp |
| Bưởi | Năm Roi · da xanh · Diễn | Vĩnh Long/Bến Tre/Hà Nội |
| Cam | sành · Cao Phong · Vinh | Miền Tây/Hoà Bình/Nghệ An |
| Nhãn | xuồng cơm vàng · lồng Hưng Yên · da bò | Bến Tre/Hưng Yên |
| Vải | thiều Lục Ngạn · u hồng | Bắc Giang/Hải Dương |
| Sầu riêng | Ri6 · Monthong · Dona | Tiền Giang/Đắk Lắk |
| Mít | Thái · ta · tố nữ | — |
| Dừa | xiêm · ta · sáp · dứa | Bến Tre/Trà Vinh |

Cách làm: dùng đúng `SkinDef` đã có trong engine (như rau thơm/gia vị) → **+27 ảnh** (mỗi skin 1 ảnh), không đụng core.

### 3.3 Mâm ngũ quả — Phiên chợ đặc biệt (`fair16`, P11)

Đây là 1 màn "sưu tập": objective là **5 loại quả khác nhau × 1** trên bàn 8×8, nhiều chain cùng lúc.

| Vùng | 5 quả | Ghi chú |
|---|---|---|
| **Nam** *(mặc định — nền miền Tây)* | mãng cầu · sung · dừa · đu đủ · xoài | "cầu sung vừa đủ xài" |
| Bắc | chuối · bưởi · hồng · quýt · táo/lê | mở khoá khi sưu tầm đủ giống Bắc trong Album |

---

## 4. Hoa — 28 loại (4 chương chính 7 màn + 24 mini 4 màn)

Hoa là **cây trồng làm đẹp + nguyên liệu quà tặng**: chain 4–5 tier (hạt/cành → mầm → nụ → hoa nở → chậu/bó).
Hoa không tạo sản phẩm ăn được; công dụng là **trang trí bản đồ**, **đơn hàng chợ hoa Tết** và **tiếp nối Hồi 7**
("Quà tặng & hoa" — `GAME_DESIGN_ACTS.md §16.3`, dùng lại đúng chain đã vẽ).

| Nhóm | Loại (Phần) |
|---|---|
| **Hoa chính** (7 màn) | mai (P1 — cây bà trồng) · cúc (P2) · **sen** (P3 — Phật Đản) · hướng dương (P6) |
| **Xuân–Hè** | vạn thọ, thược dược (P2) · nhài, ngọc lan, loa kèn (P3) · phượng vĩ, bằng lăng, dâm bụt (P5) · hoa sứ, mười giờ, hoa giấy (P6) |
| **Thu** | hoa sữa, cúc họa mi, tam giác mạch (P7) |
| **Mùa nước nổi** | hoa súng, lục bình (P8) |
| **Tết** (P10) | đào, đồng tiền, lan hồ điệp, trạng nguyên, hoa hồng, cẩm chướng, **quất kiểng**, lay ơn |

Hoa có **buff nhẹ với Ong** (§6.3): mỗi chương hoa hoàn thành +% thưởng mật ong — lý do tự nhiên để trồng hoa.

---

## 5. Rau củ, gia vị, ngũ cốc, lá gói bánh

- **Rau củ 44** (22 chính + 22 mini): thêm rau đặc trưng Việt Nam — mồng tơi, rau đay, rau má, **điên điển**,
  **ngó súng**, bầu, su su, su hào, đậu đũa, đậu cove, dưa gang, cà pháo, cải thảo, rau lang, măng tre, khoai mì
  (sắn), khoai môn, củ năng, củ dền, **sả, riềng**, hạt sen.
- **Ngũ cốc & cây công nghiệp 16**: thêm **lúa nếp** (P4, cho bánh tro/rượu nếp/cốm), mè, ca cao (Bến Tre), thốt nốt
  (An Giang) và **4 loại lá gói bánh: lá dong, lá chuối, lá gai, lá dứa** (P10) — là *nguyên liệu bắt buộc* trước bánh
  chưng/tét/gai (§7).
- Cây thuộc P8 (mùa nước nổi) thể hiện đúng mùa: cá linh, điên điển, bông súng chỉ có ở Phần này.

---

## 6. Vật nuôi (27) & quy tắc **"Chuồng trước, con sau"**

### 6.1 Quy tắc

> Mỗi vật nuôi / sản phẩm vật nuôi có trường `canXay` (`requires` trong data). Chương chỉ **mở khoá khi công trình
> tương ứng đã xây xong** — người chơi phải hoàn thành chương công trình (4 màn) trước. Công trình vẫn cần xu, và
> mở sau khi xong 1 chương "khởi đầu" liên quan (cây/thức ăn).

Luồng chuẩn: **Chương công trình (4 màn) → Chương vật nuôi (6–8 màn) → Chương sản phẩm chế biến**.

### 6.2 Bảng chuồng ↔ con (đã thêm 10 chuồng còn thiếu ở v4)

| Con vật | Công trình cần xây | Phần |
|---|---|---|
| Gà (trứng), gà thịt | Chuồng gà | P1 |
| Thỏ | **Chuồng thỏ** *(mới)* | P2 |
| Vịt | **Ao vịt** *(mới)* | P2 |
| Heo | Chuồng heo | P3 |
| Bò sữa | Chuồng bò | P3 |
| Dê | **Chuồng dê** *(mới)* | P3 |
| Ngan, cút, ngỗng | **Trại gia cầm** *(mới)* | P3 |
| Bồ câu | **Chuồng bồ câu** *(mới)* | P5 |
| Trâu | **Chuồng trâu** *(mới)* | P6 |
| Cá rô phi, tôm càng, cua, lươn, cá lóc, cá chép | Ao cá | P8 (chép P11) |
| Cá linh | **Bến xuồng** *(mới)* | P8 |
| Cá tra | **Bè cá tra** *(mới)* | P8 |
| Ếch, ốc bươu, ba ba | **Ao đặc sản** *(mới)* | P8–P9 |
| **Ong mật** | **Nhà ong** | **P9** |
| Tằm | Nhà nuôi tằm | P9 |
| Chó giữ trại (Mực) | **Chuồng chó** *(mới)* | P10 |
| Chim yến | **Nhà yến** *(mới)* | P10 |

### 6.3 Ong mật — chuỗi Nhà ong → Ong → Mật ong (theo yêu cầu)

*(Tôi hiểu "chuông ong" là **chuồng/nhà ong** — thùng nuôi ong. Nếu ý bạn khác, báo tôi sửa.)*

1. **Xây Nhà ong** (P9, chương 4 màn, vật liệu `wood` + `bamboo`): Móng → Khung → Mái tre → Hoàn thiện.
   Bác Hai xây; trang sổ #9 giấu trong nhà ong ("bà học nuôi ong từ đâu", §8).
2. **Chương Ong mật** (8 màn, chain đặc biệt 5 tier): Ấu trùng → Ong thợ → Tổ ong → Khung mật → Thùng mật. Vật cản chủ đạo: Lưới.
3. **Chương Mật ong** (8 màn, sản phẩm): Khung mật → Ly tâm → Lọc → Rót → Thùng mật ong (mở sau chương Ong, **cần Nhà ong**).
4. **Liên kết hoa → ong:** mỗi chương **hoa** đã hoàn thành cộng +2% xu/mật thưởng ở chương Ong/Mật ong (tối đa +30%
   với 15 hoa) — hoa Tết, hoa sen, hoa súng… ai trồng nhiều hoa được nhiều mật.
5. **Buff công trình:** Nhà ong mở đơn hàng "mật ong" ở Chợ; sáp ong dùng sau ở Hồi 7 (nến thơm).

---

## 7. Chế biến — 70 chương

### 7.1 Quy tắc chung
- **Nguyên liệu gốc phải xong trước** (mứt: cây gốc; bánh: gạo/nếp + nhân + lá gói).
- **Bánh mộc mạc** (trôi, chay, tro, dẻo — luộc/hấp) cần **Bếp củi**; **bánh nướng/hấp lớn** cần **Lò bánh**.
- **Mứt** cần **Xưởng mứt**; **dưa muối/lu** cần **Sân lu**; **rượu nếp** cần **Lò rượu**; **yến sào** cần **Nhà yến**.

### 7.2 Mứt — 20 (P11, xưởng mứt xây ở P10)

10 mứt Lõi: táo · vỏ dưa hấu · xoài · thơm · dừa · **gừng (hero)** · bí · chuối · cà rốt · quýt(tắc).
10 mứt mở rộng: hạt sen · cóc · me · sung · **vỏ bưởi** · dâu tây · khoai môn · sơ ri · mận · cam.
Tier: T5 = quả gốc (tái dùng ảnh) → T6 thái → T7 ngâm đường → T8 thành phẩm (`initialTiles` từ T5).

### 7.3 Bánh — 22

| Dịp | Bánh | Phần | Cần |
|---|---|---|---|
| Hàn Thực 3/3 | bánh trôi · bánh chay | P2 | Bếp củi |
| Đoan Ngọ 5/5 | bánh tro | P4 | Bếp củi |
| Trung Thu | bánh dẻo | P7 | Bếp củi |
| Cơm mới | bánh cốm · bánh giầy | P9 | Lò bánh |
| Quanh năm | chuối nướng · bò · đậu xanh · khoai lang · tráng · ít | P9 | Lò bánh |
| **Tết** | **chưng · tét · ú · da lợn** · gai · phu thê | P11 | Lò bánh + lá gói (P10) |
| Sau Tết | cam · in · pía · giò | P12 | Lò bánh |

Bánh nhiều nguyên liệu (chưng/tét/ú): từ màn 4 dùng **chain phụ** (nếp + đậu xanh + heo) trên cùng bàn — cần engine đa chain.

### 7.4 Đồ chế biến khác — 28

Sữa chua, phô mai, bơ · nước ép, nước cốt dừa · đường mía, trà · **đậu hũ, sữa đậu nành, tương** · dầu lạc, bún tươi, miến ·
tinh dầu sả · trứng muối · mật ong · giấm · **cốm** · **mắm cá linh, khô cá lóc** · đường thốt nốt · rượu nếp · dưa cải muối,
cà pháo muối · ô mai mơ · yến sào · dầu dừa, kẹo dừa.

---

## 8. Cốt truyện điều chỉnh — 12 tháng, 12 trang sổ

Giữ nguyên chủ đề "nợ nghĩa", Mực, mứt gừng, thư môi giới (`HOI1_MASTER_DESIGN.md §2`), chỉ **dời mốc theo lịch âm**
và tăng lên **12 trang sổ thất lạc** (1 trang/Phần). Thư môi giới: **P3, P7, P11**.

| Phần | Dịp | Cảnh chính | Trang sổ (giấu ở) |
|---|---|---|---|
| P1 Giêng | Nguyên Tiêu | Mai về đúng đầu xuân, nông trại hoang, cây mai của bà còn 1 cành nụ. Thấy chó đen ngoài hàng rào (Mực). | #1 "Bà về đây một mình" (Chuồng gà) |
| P2 Ba | **Thanh Minh** | **Mai đi tảo mộ bà**, cùng ông Tư. Hàn Thực: cả xóm gói bánh trôi bánh chay — Mai lần đầu thấy xóm còn nhớ bà. | #2 "Cách bà đếm hạt giống" (Nhà kính) |
| P3 Tư | Phật Đản | Hoa sen. Thư môi giới #1. Bé Na xuất hiện với đàn vật nuôi. | #3 "Con heo đầu tiên bà đặt tên" (Chuồng heo) |
| P4 Năm | **Đoan Ngọ** | Cả xóm ăn trái cây "diệt sâu bọ", bánh tro, rượu nếp. Chú Bảy dạy ghép cây. | #4 "Vườn bà trồng vì ai" (Giàn tưới) |
| P5 Sáu | Mùa trái cây | Mai lần đầu có nhiều trái để bán ở chợ. Tự hào. | #5 "Bà cất mùa trái vào kho lạnh cho ai?" (Kho lạnh) |
| P6 Bảy | **Vu Lan** | Mai cúng bà lần đầu. **Sổ nợ nghĩa** hé lộ: cả xóm từng được bà giúp. Xúc động lớn nhất nửa đầu. | #6 "Sổ nợ nghĩa — trang đầu" (Kho lúa) |
| P7 Tám | **Trung Thu** | Bé Na rước đèn. Mai trồng gừng bà dặn. Thư môi giới #2. | #7 "Bà đi chợ bằng xuồng" (Xe tải) |
| P8 Chín | **Mùa nước nổi** | Cả xóm chèo xuồng chở cá linh, điên điển đến — hoá ra bà từng chèo xuồng đưa hạt giống cho họ. | #8 "Hạt giống bà cho mượn" (Bến xuồng) |
| P9 Mười | **Cơm mới** | Cúng cơm mới, làm cốm. **Nhà ong xong** → trang sổ #9. | #9 "Bà học nuôi ong từ đâu" (Nhà ong) |
| P10 Mười Một | Vào vụ Tết | Bé Na đặt tên **Mực**; Mai nhận ra đó là chó của bà. Hoa Tết nở. | #10 "Cây mai bà trồng để chờ Mai" (Xưởng mứt) |
| P11 Chạp | **Ông Táo 23/12** | Cả làng gói bánh chưng đêm. **Mứt gừng thiếu vị**. Thư môi giới #3 → Mai xé (sáng 30). | #11 "Mứt gừng — bà viết dở" (Bếp ninh lớn) |
| P12 Tết | **Giao thừa → mùng 1** | **Chợ nổi Tết + Chợ Xuân.** Mứt gừng + lát quýt hoàn thành. Kết Hồi 1 (kịch bản cảnh cuối ở Master §2.7 vẫn dùng). | #12 "Lời cuối" (Cổng chào) |

**Mứt gừng (hero):** gừng (P7) → mứt gừng (P11, thiếu vị) → quýt (P10) → boss `fair19` (P12) = mứt gừng + mứt quýt + mứt dừa trên bàn 8×8.

---

## 9. Công trình — 51 (thêm 22) & 6 chain vật liệu

### 9.1 22 công trình mới

| Công trình | Phần | Ưu tiên | Vai trò |
|---|---|---|---|
| Chuồng thỏ · Ao vịt | P2 | S | Chuồng trước, con sau (§6) |
| **Bếp củi** | P2 | A | Bánh mộc mạc (trôi/chay/tro/dẻo) |
| Chuồng dê · Trại gia cầm | P3 | S | Chuồng cho dê / ngan-cút-ngỗng |
| Lò nấu rượu · Nhà sấy trái cây | P4 | A | Rượu nếp · ô mai, trái sấy |
| Chuồng bồ câu | P5 | A | Bồ câu |
| **Sân phơi lúa** | P6 | S | Đặc trưng làng quê; cốm, khô cá |
| **Lò đường thủ công** | P6 | S | Đường mía, thốt nốt |
| Chuồng trâu | P6 | S | Trâu |
| Xưởng đậu hũ | P6 | A | Đậu hũ, sữa đậu nành, tương |
| **Cầu khỉ** | P7 | A | Biểu tượng miền Tây (trang trí, buff nhẹ) |
| Chòi canh ruộng · Hầm ủ phân | P7 | A | +xu nhẹ |
| **Bè cá tra** · Ao đặc sản | P8 | A | Cá tra · ếch/ốc/ba ba |
| **Bến xuồng** | P8 | S | Cá linh mùa nước nổi; nối Chợ nổi |
| Sân lu muối dưa · Nhà yến | P10 | A | Dưa muối · yến sào |
| Chuồng chó | P10 | S | Chó giữ trại (Mực) |
| **Chợ nổi** | P12 | S | Chợ cấp 5 — xuồng bán hàng |

### 9.2 Chợ 5 cấp, Kho 6 cấp

| Chợ | Công trình | Slot đơn |
|---|---|---|
| 1 | Sạp chợ làng (P1) | 2 |
| 2 | Quầy hàng Tết (P11) | 3 |
| 3 | Gian trưng bày (P11) | 4 |
| 4 | Chợ Xuân (P12) | 6 |
| 5 | **Chợ nổi** (P12) | +1 đơn "xuồng" đặc biệt |

Kho: Kho nhỏ 100 (P2) → Kho thức ăn 250 (P3) → **Kho lạnh 500 (P5)** → **Kho lúa 1.000 (P6)** → Kho bột 1.500 (P9) → Kho tổng 3.000 (P12).
(Thứ tự này thay Master §5.3, vì Kho lạnh nay xây ở P5 trước Kho lúa ở P6.)

### 9.3 Vật liệu mới
`bamboo` (Tre nứa: Tre → Nứa → Lóng → Liếp → Giàn/sàn) và `thatch` (Lá dừa nước: Lá → Bó → Tấm lợp → Mái lá → Mái ngói). Dùng cho Nhà ong,
Chòi canh, Cầu khỉ, Bếp củi, Chuồng trâu…

---

## 10. Lễ hội & Phiên chợ — 19 chương (6 màn, bàn 6×6 → 8×8)

| Phần | Chương | Chủ đề / cơ chế |
|---|---|---|
| P1 | Lễ hội Xuân (Nguyên Tiêu) | Gà + cà chua |
| P2 | Thanh Minh — Hàn Thực | Rau + bánh trôi/chay |
| P3 | Phật Đản — phiên chợ chay | Hoa sen + rau + hạt sen |
| P4 | Đoan Ngọ — chợ trái cây | 3 loại trái + bánh tro |
| P5 | Hội chợ trái cây miền Tây I–II | 3 chain trái cây; bàn 7×7 |
| P6 | Vu Lan | Lúa + đậu + trà |
| P7 | Trung Thu — chợ đèn · mâm quả | Bưởi + hồng + bánh dẻo |
| P8 | Chợ mùa nước nổi | Cá + rau nước nổi |
| P9 | Cơm mới — Thường Tân | Cốm + mật ong + bánh |
| P10 | Chợ hoa Tết I–II | Hoa Tết + quất kiểng |
| P11 | **Ông Công Ông Táo** (cá chép) · Chợ mứt Tết · **Mâm ngũ quả** | Boss-nhóm: 5 quả khác nhau |
| P12 | Chợ Xuân I · **Chợ nổi Tết** · **Đại đơn hàng** (boss Hồi 1) | 8×8, 3 chain, mứt gừng + quýt + dừa |

S (Lõi): 17 chương (fair01–fair14 + 3 chương kết Hồi ở P12). A (mở rộng): Chợ mứt Tết, Mâm ngũ quả.

---

## 11. Quy mô & phân bổ

| Loại | Asset | Tổng màn | Ghi chú màn/chương |
|---|---|---|---|
| Trái cây | 52 | 364 | chính 25×7 + mini 27×5 |
| Rau củ | 44 | 308 | chính 22×7 + mini 22×5 |
| Ngũ cốc & lá gói | 16 | 112 | chính 9×7 + mini 7×4 |
| Hoa | 28 | 196 | chính 4×7 + mini 24×4 |
| Vật nuôi | 27 | 198 | cũ 18×8 + mới 9×6 |
| Mứt | 20 | 140 | cũ 10×8 + mới 10×6 |
| Bánh | 22 | 152 | cũ 10×8 + mới 12×6 |
| Chế biến khác | 28 | 188 | cũ 10×8 + mới 18×6 |
| Công trình | 51 | 204 | 4 màn (4 giai đoạn xây) |
| Vật liệu | 6 chain | 0 | nằm trong màn công trình |
| Lễ hội / Phiên chợ | 19 chương | 114 | 6 màn |
| **Tổng** | **294 asset + 19 chương** | **1.976** | (+2 vì dừa giữ 9 màn) |

**Lõi (S):** 1.055 màn · **Mở rộng (A):** 921 màn.

---

## 12. Art (ước tính)

| Nhóm | Ảnh | Ghi chú |
|---|---|---|
| Cây trồng 140 | ≈ 360 | T3–T5 riêng cho 60 chương chính; 80 mini chỉ vẽ tier chót + 2 riêng; tier 1–2 dùng template tô màu |
| Skin giống địa phương | 27 | §3.2 |
| Vật nuôi 27 + `cat`/`mouse` | ≈ 139 | |
| Chế biến 70 | ≈ 230 | Mứt: T8 riêng + 2 ảnh T6/T7 dùng chung |
| Vật liệu 6 | 30 | |
| Công trình 51 | ≈ 106 | 2 ảnh/công trình + 4 overlay giàn giáo |
| Nhân vật mới (Cô Ba, Bác Hai, Anh Tài, Mực, Bà Năm) | 10 | |
| **Tổng** | **≈ 900** | (Bản Lõi ≈ 520) |

Bước tiếp: mở rộng `OBJECT_ART_PROMPTS.md` **bằng script sinh từ `hoi1_assets.csv`** (template prompt theo `loai`/`tmpl`),
không viết tay 900 prompt.

---

## 13. Lộ trình phát hành đề xuất

| Bản | Nội dung | Màn (cộng dồn) |
|---|---|---|
| **Lõi** | Toàn bộ ưu tiên S, 12 Phần, kết Hồi 1 | **1.055** |
| **Gói 1 — Vườn cây & Hoa** | Mini trái cây/rau/hoa P4–P8, P10 + hoa Tết | +≈ 400 |
| **Gói 2 — Bếp Việt** | 60 chương chế biến mới (bánh, đồ chế biến, mứt mở rộng) | +≈ 380 |
| **Gói 3 — Thuỷ sản & đặc sản** | Ao đặc sản, bè cá tra, nhà yến, ba ba… | +≈ 140 |

---

## 14. Việc kỹ thuật thêm so với Master §10

1. `ChapterDef.requires: List<String>` (id công trình) — thực thi quy tắc §6.
2. Trường `season` / `lunarMonth` trên Phần (chỉ dùng cho thoại/nhãn, chưa cần lịch thật).
3. **Album giống** (sưu tầm skin) — lưu trong `SaveData`, hiển thị ở màn Tài sản.
4. Đọc `hoi1_assets.csv` → `tool/gen_levels.dart` sinh chương/màn (các cột `hang`/`loai` quyết định khuôn: T7, T5-mini, T8, T6-mini, T4, F6).
5. Khuôn **T5-mini**, **T6-mini** (giảm số màn) cần thêm vào §6 của Master.

---

## 15. Câu hỏi mở

1. **Ưu tiên phát hành:** đồng ý bản **Lõi 1.055 màn** ra trước, mở rộng bằng gói? Hay muốn làm liền cả 1.976?
2. **Lịch âm chỉ để dựng truyện**, hay bạn muốn **sự kiện theo ngày thật** (Tết thật, Trung Thu thật mở gói chợ đặc biệt)?
3. **Mâm ngũ quả**: giữ "Nam" mặc định (nền miền Tây) và mở "Bắc" qua Album giống — có ổn?
4. **"Chuông ong"** = nhà/chuồng ong như tôi hiểu?
5. Hồi 2 nối tiếp: `lua` Hồi 1 kết ở Bao gạo, `rice` Hồi 2 bắt đầu từ đó (đã nêu ở catalog H) — giữ.

