# Hồi 1 — Danh mục Asset đầy đủ (140 asset → 997 màn)

> **⚠ Đã được cập nhật bởi [HOI1_VIETNAM_EXPANSION.md](HOI1_VIETNAM_EXPANSION.md) (v5):** 10 Phần → **12 Phần theo lịch âm**, 140 → **294 asset**, 997 → **1.976 màn** (Lõi 1.055), thêm quy tắc *chuồng trước, con sau*. Khi mâu thuẫn, file v5 thắng; dữ liệu gốc ở [hoi1_assets.csv](hoi1_assets.csv).

Đi kèm `HOI1_MASTER_DESIGN.md` (cốt truyện, cấu trúc, độ khó, kinh tế). File này chỉ là **kho dữ liệu**:
mỗi asset là 1 dòng → có thể chuyển thẳng thành `ChainDef` / `ChapterDef` / `DecorDef`.

**Định nghĩa "asset"** = 1 họ vật thể có chuỗi tiến hoá riêng (cây, con vật, món chế biến, vật liệu) hoặc
1 công trình. 1 asset = 1 chương; số màn/chương theo loại (bảng dưới).

| Loại | Số asset | Màn/chương | Tổng màn |
|---|---|---|---|
| Cây trồng (rau, củ, trái cây, ngũ cốc, hoa) | 59 | 7 | 413 |
| Vật nuôi | 18 | 8 | 144 |
| Chế biến (mứt, bánh, đồ chế biến khác) | 30 | 8 | 240 |
| Công trình | 29 | 4 | 116 |
| Phiên chợ (chương tổ hợp, không có asset riêng) | 14 chương | 6 | 84 |
| Vật liệu xây dựng (chain dùng trong màn công trình) | 4 | — (nằm trong màn công trình) | — |
| **Tổng** | **140 asset** (59+18+30+29+4) **· 150 chương** (59+18+30+29+14) | | **997** |

4 chain vật liệu không có chương riêng (nằm trong màn công trình), 14 Phiên chợ không có asset riêng.

Cột **Phần** = P1…P10 (xem Master §3). Cột **VC** = vật cản chủ đạo của chương (vòng Đá → Cỏ dại → Băng →
Lưới → Hư hao; chỉ dùng loại đã được giới thiệu tới Phần đó, xem Master §7.2).

---

## A. Template chuỗi tiến hoá (dùng chung để tiết kiệm art)

Mỗi asset chỉ cần nêu **tên tier chót (tier 5)** + tên riêng của tier 3–4 nếu khác template. Tier 1–2 của
template dùng chung 1 ảnh gốc, chỉ đổi màu (xem Master §9).

| Template | T1 | T2 | T3 | T4 | T5 (chót) |
|---|---|---|---|---|---|
| `LEAF` rau lá | Hạt | Mầm | Cây non | Luống | Bó rau |
| `VEGFRUIT` rau quả | Hạt | Mầm | Cây ra hoa | Quả xanh | Quả chín |
| `ROOT` củ | Giống | Mầm | Tán lá | Củ nhỏ | Củ to |
| `TREE` cây ăn quả gỗ | Hạt | Cây con | Cây lớn | Hoa/quả xanh | Quả chín |
| `VINE` dây/giàn | Hạt | Mầm | Dây leo | Hoa | Quả chín |
| `GRAIN` ngũ cốc | Hạt giống | Mạ | Cây | Trổ bông | Bao thu hoạch |
| `FLOWER` hoa | Hạt/cành | Mầm | Nụ | Hoa nở | Chậu/bó hoa |
| `LIVESTOCK` gia súc | Con non | Con tơ | Con trưởng thành | Sản phẩm | Đàn/kho sản phẩm |
| `POULTRY` gia cầm | Trứng | Con non | Con giò | Con trưởng thành | Đàn |
| `AQUA` thuỷ sản | Trứng/bột | Giống | Cá/tôm thương phẩm | Mẻ lưới | Thùng đầy |
| `JAM` mứt | *(t5 của cây gốc)* | — | — | — | — |

Chuỗi đặc biệt (không theo template) được ghi riêng ở các bảng dưới.

---

## B. Cây trồng — 59 asset (7 màn/chương)

### B1. Rau củ — 22

| # | id | Tên | Tmpl | T5 | Phần | VC |
|---|---|---|---|---|---|---|
| 1 | `rauMuong` | Rau muống | LEAF | Bó rau muống | P1 | — |
| 2 | `caiXanh` | Cải xanh | LEAF | Bó cải xanh | P1 | — |
| 3 | `caChua` | Cà chua | VEGFRUIT | Cà chua chín | P1 | Đá (boss) |
| 4 | `duaLeo` | Dưa leo | VEGFRUIT | Dưa leo tươi | P1 | Đá |
| 5 | `biDo` | Bí đỏ | VEGFRUIT | Bí đỏ chín | P2 | Đá |
| 6 | `biXanh` | Bí xanh | VEGFRUIT | Bí xanh non | P2 | Cỏ dại |
| 7 | `muop` | Mướp | VINE | Mướp hương | P2 | Cỏ dại |
| 8 | `khoQua` | Khổ qua | VINE | Khổ qua chín | P2 | Đá |
| 9 | `caTim` | Cà tím | VEGFRUIT | Cà tím bóng | P2 | Cỏ dại |
| 10 | `ot` | Ớt | VEGFRUIT | Ớt đỏ | P2 | Đá |
| 11 | `caRot` | Cà rốt | ROOT | Cà rốt to | P2 | Cỏ dại |
| 12 | `cuCai` | Củ cải | ROOT | Củ cải trắng | P2 | Đá |
| 13 | `dauBap` | Đậu bắp | VEGFRUIT | Đậu bắp non | P2 | Cỏ dại |
| 14 | `xaLach` | Xà lách | LEAF | Xà lách cuộn | P2 | Đá |
| 15 | `khoaiLang` | Khoai lang | ROOT | Khoai lang tím | P4 | Băng |
| 16 | `khoaiTay` | Khoai tây | ROOT | Khoai tây vàng | P4 | Băng |
| 17 | `hanhTay` | Hành tây | ROOT | Hành tây tím | P4 | Cỏ dại |
| 18 | `toi` | Tỏi | ROOT | Tỏi tép | P4 | Băng |
| 19 | `gung` | Gừng | ROOT | Gừng già | P4 | Băng |
| 20 | `nghe` | Nghệ | ROOT | Nghệ vàng | P4 | Cỏ dại |
| 21 | `bapCai` | Bắp cải | LEAF | Bắp cải cuộn | P4 | Băng |
| 22 | `dauXanh` | Đậu xanh | GRAIN | Bao đậu xanh | P4 | Đá |

### B2. Ngũ cốc & cây công nghiệp — 8 (đều ở P4)

| # | id | Tên | Tmpl | T5 | VC |
|---|---|---|---|---|---|
| 23 | `lua` | Lúa | GRAIN | Bao gạo *(nối sang Hồi 2 `rice`)* | Băng |
| 24 | `ngo` | Ngô | GRAIN | Bắp ngô vàng | Cỏ dại |
| 25 | `mia` | Mía | GRAIN (T3 Cây mía non, T4 Cây mía cao) | Bó mía | Lưới |
| 26 | `dauPhong` | Đậu phộng | ROOT (T4 Cây có củ) | Bao đậu phộng | Đá |
| 27 | `dauNanh` | Đậu nành | GRAIN | Bao đậu nành | Cỏ dại |
| 28 | `tra` | Trà | LEAF (T4 Luống trà, T5 Búp trà) | Búp trà tươi | Lưới |
| 29 | `hatDieu` | Hạt điều | TREE | Hạt điều tách vỏ | Lưới |
| 30 | `tieu` | Tiêu | VINE (T4 Chùm tiêu xanh) | Tiêu đỏ phơi | Băng |

### B3. Trái cây — 25

| # | id | Tên | Tmpl | T5 | Phần | VC |
|---|---|---|---|---|---|---|
| 31 | `chuoi` | Chuối | TREE (T3 Buồng chuối non, T4 Buồng chuối xanh) | Nải chuối chín | P6 | Đá |
| 32 | `xoai` | Xoài | TREE | Xoài chín vàng | P6 | Lưới |
| 33 | `thom` | Thơm (dứa) | TREE (T3 Bụi thơm) | Thơm chín | P6 | Hư hao |
| 34 | `duaHau` | Dưa hấu | VINE | Dưa hấu chín | P6 | Cỏ dại |
| 35 | `duDu` | Đu đủ | TREE | Đu đủ chín | P6 | Đá |
| 36 | `oi` | Ổi | TREE | Ổi chín | P6 | Cỏ dại |
| 37 | `dua` | Dừa *(chain 8 tier đã có)* | — | Trái dừa | P6 | Băng |
| 38 | `mangCau` | Mãng cầu (na) | TREE | Na mở mắt | P6 | Lưới |
| 39 | `hongXiem` | Hồng xiêm (sapoche) | TREE | Sapoche chín | P6 | Hư hao |
| 40 | `khe` | Khế | TREE | Khế vàng | P6 | Đá |
| 41 | `cam` | Cam | TREE | Cam sành chín | P6 | Băng |
| 42 | `buoi` | Bưởi | TREE | Bưởi da xanh | P6 | Cỏ dại |
| 43 | `mit` | Mít | TREE (T4 Mít non) | Múi mít vàng | P6 | Lưới |
| 44 | `thanhLong` | Thanh long | VINE (T3 Trụ thanh long) | Thanh long ruột đỏ | P6 | Băng |
| 45 | `tao` | Táo | TREE | Táo chín | P6 | Đá |
| 46 | `sauRieng` | Sầu riêng | TREE | Sầu riêng chín | P7 | Hư hao |
| 47 | `chomChom` | Chôm chôm | TREE | Chùm chôm chôm | P7 | Lưới |
| 48 | `nhan` | Nhãn | TREE | Chùm nhãn | P7 | Băng |
| 49 | `vai` | Vải | TREE | Chùm vải đỏ | P7 | Cỏ dại |
| 50 | `mangCut` | Măng cụt | TREE | Măng cụt tím | P7 | Hư hao |
| 51 | `man` | Mận | TREE | Mận hậu đỏ | P7 | Băng |
| 52 | `luu` | Lựu | TREE | Lựu nứt hạt | P7 | Lưới |
| 53 | `chanh` | Chanh | TREE | Chanh xanh | P7 | Đá |
| 54 | `quyt` | Quýt | TREE | Quýt đường | P7 | Cỏ dại |
| 55 | `nho` | Nho | VINE | Chùm nho | P7 | Hư hao |

> Ghi chú: `dua` (dừa) đã có chain 8 tier; chuyển vào P6 nhưng **giữ nguyên id `coconut`/`ch_coconut`** để không
> hỏng save hiện tại. Dừa giữ 9 màn thay vì 7 (xem bảng đối chiếu ở mục H — chênh lệch được cộng vào tổng thực tế).

### B4. Hoa & cây Tết — 4 (P7)

| # | id | Tên | Tmpl | T5 | VC |
|---|---|---|---|---|---|
| 56 | `hoaMai` | Hoa mai | FLOWER | Chậu mai vàng | Hư hao |
| 57 | `hoaCuc` | Hoa cúc | FLOWER | Chậu cúc | Cỏ dại |
| 58 | `hoaSen` | Hoa sen | FLOWER (T3 Búp sen, T4 Sen nở) | Bó sen | Lưới |
| 59 | `huongDuong` | Hướng dương | FLOWER | Đầu hướng dương | Đá |

---

## C. Vật nuôi — 18 asset (8 màn/chương, chain 5–6 tier)

| # | id | Tên | Tmpl | T5/T6 chót | Phần | Ghi chú sản phẩm |
|---|---|---|---|---|---|---|
| 60 | `poultry` | Gà (trứng) | POULTRY | Gà trống *(đã có: trứng→gà con→gà giò→gà mái→gà trống)* | P1 | Mở rộng 5→8 màn |
| 61 | `rabbit` | Thỏ | LIVESTOCK | Ổ thỏ | P2 | |
| 62 | `duck` | Vịt | POULTRY | Đàn vịt | P2 | Trứng vịt → nguyên liệu trứng muối |
| 63 | `chickenMeat` | Gà thịt | POULTRY (T4 Gà thịt) | Lồng gà xuất chuồng | P3 | |
| 64 | `pig` | Heo | LIVESTOCK | Heo xuất chuồng | P3 | |
| 65 | `dairyCow` | Bò sữa | LIVESTOCK (6 tier: Bê, Bò tơ, Bò sữa, Xô sữa, Bình sữa, Kho sữa) | Kho sữa đầy | P3 | *đã có* |
| 66 | `goat` | Dê | LIVESTOCK | Đàn dê | P3 | |
| 67 | `muscovy` | Ngan | POULTRY | Đàn ngan | P3 | |
| 68 | `quail` | Chim cút | POULTRY | Lồng cút | P3 | |
| 69 | `goose` | Ngỗng | POULTRY | Đàn ngỗng | P3 | |
| 70 | `buffalo` | Trâu | LIVESTOCK | Đôi trâu cày | P4 | Mở khoá "Xe trâu kéo" |
| 71 | `tilapia` | Cá rô phi | AQUA | Thùng cá đầy | P5 | |
| 72 | `shrimp` | Tôm càng | AQUA | Thùng tôm đầy | P5 | |
| 73 | `crab` | Cua đồng | AQUA | Rổ cua | P5 | |
| 74 | `eel` | Lươn | AQUA | Thùng lươn | P5 | |
| 75 | `bee` | Ong mật | Đặc biệt: Ấu trùng → Ong thợ → Tổ ong → Khung mật → Thùng mật | Thùng mật | P5 | |
| 76 | `silkworm` | Tằm | Đặc biệt: Trứng tằm → Tằm → Kén → Cuộn tơ → Súc lụa | Súc lụa | P5 | |
| 77 | `guardDog` | Chó giữ trại | Đặc biệt (4 tier): Chó con → Chó choai → Chó trưởng thành → Chó chăn trại | Chó chăn trại | P8 | Chương "bàn nhiễu" cùng `cat`, `mouse` |

(`cat` = 2 tier, `mouse` = 2 tier — chain nhiễu, không tính là asset chương, nhưng cần 4 ảnh.)

---

## D. Chế biến — 30 asset (8 màn/chương)

### D1. Mứt — 10 (P8) · dùng `initialTiles` từ tier chót của cây gốc

Mỗi mứt: T5 = quả chín của chương gốc (tái dùng ảnh) → **T6 Thái/sơ chế → T7 Ngâm đường → T8 Mứt thành phẩm**
(tổng 8 tier). Art dùng chung 2 ảnh mẫu T6/T7, chỉ đổi màu; T8 vẽ riêng.

| # | id | Tên mứt | Cây gốc (phải xong trước) | VC |
|---|---|---|---|---|
| 78 | `jamTao` | Mứt táo | `tao` | Đá |
| 79 | `jamDuaHau` | Mứt vỏ dưa hấu | `duaHau` | Cỏ dại |
| 80 | `jamXoai` | Mứt xoài | `xoai` | Lưới |
| 81 | `jamThom` | Mứt thơm | `thom` | Hư hao |
| 82 | `jamDua` | Mứt dừa | `dua` | Băng |
| 83 | `jamGung` | Mứt gừng | `gung` | Băng |
| 84 | `jamBi` | Mứt bí | `biDo` | Đá |
| 85 | `jamChuoi` | Mứt chuối | `chuoi` | Cỏ dại |
| 86 | `jamCaRot` | Mứt cà rốt | `caRot` | Lưới |
| 87 | `jamQuyt` | Mứt quýt (tắc) | `quyt` | Hư hao |

> **Mứt gừng = chương "hero" của Hồi 1** — công thức cuối cùng trong sổ tay bà Năm (Master §2.6).

### D2. Bánh — 10 (P9) · 5 tier, 2 chain trên bàn (chính + phụ) từ màn 4

| # | id | Tên bánh | Chain chính (T1→T5) | Chain phụ (nhiễu/nguyên liệu) | VC |
|---|---|---|---|---|---|
| 88 | `banhChuoi` | Bánh chuối nướng | Chuối lát → Ướp đường → Xếp khuôn → Nướng → **Bánh chuối** | Nếp (`lua`) | Đá |
| 89 | `banhBo` | Bánh bò | Bột → Trộn men → Ủ → Hấp → **Bánh bò** | Dừa (`dua`) | Cỏ dại |
| 90 | `banhTet` | Bánh tét | Nếp → Lá chuối → Gói → Luộc → **Bánh tét** | Đậu xanh (`dauXanh`) | Băng |
| 91 | `banhChung` | Bánh chưng | Nếp → Lá dong → Gói → Luộc đêm → **Bánh chưng** | Đậu xanh + thịt heo (`pig`) | Lưới |
| 92 | `banhIt` | Bánh ít nhân dừa | Nếp → Nhào → Nhân dừa → Gói lá → **Bánh ít** | Dừa (`dua`) | Đá |
| 93 | `banhDauXanh` | Bánh đậu xanh | Đậu → Hấp → Xay → Nén khuôn → **Bánh đậu xanh** | Đường (`mia`) | Cỏ dại |
| 94 | `banhTrang` | Bánh tráng | Gạo → Xay → Tráng → Phơi → **Bánh tráng** | Mè | Băng |
| 95 | `banhKhoai` | Bánh khoai lang | Khoai → Hấp → Nghiền → Tạo hình → **Bánh khoai** | Bột gạo | Lưới |
| 96 | `banhU` | Bánh ú | Nếp → Lá tre → Gói chóp → Luộc → **Bánh ú** | Đậu xanh | Hư hao |
| 97 | `banhDaLon` | Bánh da lợn | Bột → Trộn màu → Lớp lớp → Hấp → **Bánh da lợn** | Đậu xanh + sầu riêng (`sauRieng`) | Hư hao |

### D3. Đồ chế biến khác — 10

| # | id | Tên | Chuỗi (T1→T5) | Phần | VC |
|---|---|---|---|---|---|
| 98 | `yogurt` | Sữa chua | Sữa → Ủ men → Hũ → Khay → **Lốc sữa chua** | P3 | Đá |
| 99 | `cheese` | Phô mai | Sữa → Đông tụ → Ép khuôn → Ủ → **Bánh phô mai** | P3 | Cỏ dại |
| 100 | `butter` | Bơ | Kem sữa → Đánh → Nén → Gói → **Bơ tươi** | P3 | Đá |
| 101 | `sugar` | Đường mía | Bó mía → Ép nước → Nấu → Kết tinh → **Bao đường** | P4 | Lưới |
| 102 | `teaLeaf` | Trà thành phẩm | Búp trà → Héo → Sao → Ủ → **Hộp trà** | P4 | Băng |
| 103 | `honey` | Mật ong | Khung mật → Ly tâm → Lọc → Rót → **Thùng mật ong** | P5 | Lưới |
| 104 | `saltEgg` | Trứng muối | Trứng vịt → Bọc tro muối → Ủ → Rửa → **Hộp trứng muối** | P5 | Hư hao |
| 105 | `juice` | Nước ép | Trái → Rửa → Ép → Lọc → **Thùng nước ép** | P7 | Cỏ dại |
| 106 | `coconutOil` | Dầu dừa | Cơm dừa → Nạo → Ép sữa → Nấu → **Chai dầu dừa** | P8 | Băng |
| 107 | `coconutCandy` | Kẹo dừa | Cơm dừa → Nấu đường → Đổ khuôn → Cắt → **Hộp kẹo dừa** | P8 | Lưới |

---

## E. Vật liệu xây dựng — 4 chain (5 tier), dùng trong màn công trình

| id | Tên | T1 → T5 |
|---|---|---|
| `wood` | Gỗ | Cành khô → Khúc gỗ → Tấm ván → Khung gỗ → Vì kèo |
| `brick` | Gạch | Đất sét → Viên mộc → Gạch nung → Xếp gạch → Bức tường |
| `tool` | Dụng cụ | Đinh → Thanh sắt → Bản lề → Dụng cụ → Máy nhỏ |
| `canvas` | Vải bạt | Sợi → Cuộn vải → Tấm bạt → Mái che → Mái vòm |

Mỗi công trình dùng **1–2 chain vật liệu** (cột "Vật liệu" bên dưới). Tier chót của mỗi chain xuất hiện ở màn 4
(boss) của công trình đó.

---

## F. Công trình — 29 asset (4 màn/chương = 4 giai đoạn xây: Móng → Khung → Mái → Hoàn thiện)

Cột **Hiệu ứng** là buff meta (chi tiết cơ chế ở Master §5). Cột **Mở khoá** = chương/tính năng cần công trình
này mới chơi được.

| # | id | Công trình | Phần | Vật liệu | Hiệu ứng | Mở khoá |
|---|---|---|---|---|---|---|
| 108 | `coop` | Chuồng gà | P1 | wood | +1 slot đơn hàng | Chương gà thịt (P3) |
| 109 | `well` | Giếng nước | P1 | brick | Năng lượng hồi nhanh +20% | — |
| 110 | `stall` | **Sạp chợ làng** | P1 | wood+canvas | Mở **Phiên chợ** + Đơn hàng chợ | Phiên chợ I |
| 111 | `greenhouse` | Nhà kính | P2 | wood+canvas | +2 màn thử lại miễn năng lượng/ngày | Rau P2 (ớt, cà tím…) |
| 112 | `pump` | Máy bơm nước | P2 | tool | Năng lượng tối đa +2 | — |
| 113 | `shed` | **Kho nhỏ** | P2 | wood | Sức chứa Kho 100 | Đơn hàng Kho |
| 114 | `pigpen` | Chuồng heo | P3 | brick | Xu thưởng chương vật nuôi +10% | Heo |
| 115 | `barn` | Chuồng bò | P3 | wood+brick | — | Bò sữa, Phô mai |
| 116 | `feedStore` | **Kho thức ăn** | P3 | wood | Kho 250 | Chế biến sữa |
| 117 | `mill` | Cối xay lúa | P4 | tool+brick | +10% xu chương ngũ cốc | Bột/bánh (P9) |
| 118 | `granary` | **Kho lúa** | P4 | brick | Kho 500 | — |
| 119 | `buffaloCart` | Xe trâu kéo | P4 | wood+tool | Hoàn thành nhanh đơn chợ +1 lượt | — |
| 120 | `fishPond` | Ao cá | P5 | brick | — | Thuỷ sản |
| 121 | `beehive` | Nhà ong | P5 | wood | — | Ong mật, Mật ong |
| 122 | `silkHouse` | Nhà nuôi tằm | P5 | wood+canvas | — | Tằm |
| 123 | `irrigation` | Giàn tưới | P6 | tool | Năng lượng tối đa +3 | — |
| 124 | `coldStore` | **Kho lạnh** | P6 | brick+tool | Kho 1.000, giữ đồ tươi | Mứt (P8) |
| 125 | `prepHouse` | Nhà sơ chế | P6 | wood+tool | Mở 2 trạm chế biến | — |
| 126 | `nursery` | Vườn ươm | P7 | wood+canvas | Booster "Xáo bàn" rẻ hơn 20% | Cây Tết |
| 127 | `truck` | Xe tải nhỏ | P7 | tool | Đơn hàng chợ thưởng +25% | Anh Tài xuất hiện |
| 128 | `tetStall` | Quầy hàng Tết | P7 | wood+canvas | Mở đơn hàng đặc biệt Tết | — |
| 129 | `jamFactory` | **Xưởng mứt** | P8 | brick+tool | Mở toàn bộ chương mứt | Mứt |
| 130 | `bigKitchen` | Bếp ninh lớn | P8 | brick+tool | +10% xu chương chế biến | Dầu/kẹo dừa |
| 131 | `oven` | **Lò bánh** | P9 | brick+tool | Mở toàn bộ chương bánh | Bánh |
| 132 | `flourShed` | Kho bột & bao bì | P9 | wood | Kho 1.500 | — |
| 133 | `showcase` | Gian trưng bày | P9 | wood+canvas | +1 slot đơn hàng + thưởng sao | — |
| 134 | `bigMarket` | **Chợ Xuân (Chợ lớn)** | P10 | wood+brick+canvas | Đơn hàng chợ 6 slot | Phiên chợ cuối |
| 135 | `mainStore` | **Kho tổng** | P10 | brick+tool | Kho 3.000 | — |
| 136 | `gate` | Cổng chào | P10 | wood | Cảnh cuối Hồi 1 | Hồi 2 |

> **Đếm lại:** bảng F ghi 29 dòng nhưng đánh số 108–136 = **29** ✓ (P1: 3, P2: 3, P3: 3, P4: 3, P5: 3, P6: 3, P7: 3,
> P8: 2, P9: 3, P10: 3). Công trình **đậm** là đường "chợ + kho" (chợ: `stall` → `tetStall` → `showcase` → `bigMarket`;
> kho: `shed` → `feedStore` → `granary` → `coldStore` → `flourShed` → `mainStore`).

(Đánh số toàn cục: cây 1–59, vật nuôi 60–77, chế biến 78–107, công trình 108–136, vật liệu = 4 chain → 59+18+30+29+4
= **140** asset.)

---

## G. Phiên chợ — 14 chương tổ hợp (6 màn, bàn 7×7–8×8, 2–3 chain cùng lúc)

Không có chain riêng; dùng lại chain đã học. Mỗi Phiên chợ đòi hỏi công trình **Sạp chợ** (hoặc bản nâng cấp).

| # | id | Phần | Bàn | Chain phối |
|---|---|---|---|---|
| 1 | `fair01` | P1 | 6×6 | gà + cà chua |
| 2 | `fair02` | P2 | 6×6 | rau lá + rau quả |
| 3 | `fair03` | P3 | 7×7 | heo + bò sữa + sữa chua |
| 4 | `fair04` | P4 | 7×7 | lúa + ngô + khoai |
| 5 | `fair05` | P5 | 7×7 | cá + tôm + mật ong |
| 6 | `fair06` | P6 | 7×7 | 3 loại trái cây |
| 7 | `fair07` | P7 | 8×8 | trái cây Tết + hoa |
| 8 | `fair08` | P8 | 8×8 | mứt táo + mứt xoài + mứt dừa |
| 9 | `fair09` | P8 | 8×8 | mứt gừng + mứt bí + mứt quýt |
| 10 | `fair10` | P9 | 8×8 | bánh tét + bánh chưng + bánh ít |
| 11 | `fair11` | P9 | 8×8 | bánh bò + bánh da lợn + bánh đậu xanh |
| 12 | `fair12` | P10 | 8×8 | rau + trái cây + vật nuôi tổng hợp |
| 13 | `fair13` | P10 | 8×8 | mứt + bánh + nước ép |
| 14 | `fair14` | P10 | 8×8 | **Chợ Xuân — đơn hàng lớn nhất** (boss Hồi 1) |

---

## H. Đối chiếu với nội dung đã có trong code (`flutter/lib/data/chapters.dart`)

| Chương hiện tại | Chuyển thành |
|---|---|
| `ch1` Trại gà nhỏ (5 màn) | `poultry` (P1), mở rộng thành 8 màn |
| `ch_coconut` Vườn dừa (9 màn) | `dua` (P6), giữ nguyên id + 9 màn |
| `ch_dairy` Bò sữa (9 màn) | `dairyCow` (P3), giữ nguyên id + 9 màn (bù +1 so với chuẩn 8) |
| `ch_vegetable` Vườn rau củ (9 màn) | **Tách** thành từng loại rau (P1/P2/P4); giữ `ch_vegetable` làm chương tổng hợp `fair02` để không hỏng save |
| `ch2` (Hồi 2 phở) | Không đổi — thuộc Hồi 2 |
| Chain `beef`, `broth`, `spice`, `herbs` | Không đổi — thuộc Hồi 2 |
| Chain `rice` (Hạt gạo → Bánh phở) | Hồi 1 `lua` kết thúc ở "Bao gạo"; Hồi 2 `rice` bắt đầu từ tier Bao gạo (dùng `initialTiles`) |

Chênh lệch số màn thực tế do giữ nguyên chương cũ đã live:

| Chương giữ nguyên | Màn giữ | Màn chuẩn trong bảng | Chênh |
|---|---|---|---|
| Vườn dừa | 9 | 7 | +2 |
| Bò sữa | 9 | 8 | +1 |
| Vườn rau củ (thành `fair02`) | 9 | 6 | +3 |
| Trại gà (mở rộng 5→8) | 8 | 8 | 0 |

Tổng thực tế = 997 + 6 = **1.003 màn**. Nếu muốn đúng ≤ 1.000, cắt 3 màn khỏi dừa/rau (bỏ màn giữa) khi
migrate — không ảnh hưởng chuẩn khuôn màn.

