# Nông Trại & Ẩm Thực Việt — Thiết kế mở rộng dài hạn (v2)

> Tài liệu **thiết kế/định hướng**, khác với [SPECS.md](./SPECS.md) là tài liệu **mô tả đúng code hiện tại**.
> Mọi thứ ở đây là đề xuất cho các Phase tiếp theo — chưa implement, dùng để thống nhất hướng đi trước khi
> đụng code. Khi một phần được implement, chuyển mô tả tương ứng sang `SPECS.md`.

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
| **Nhiệm vụ ngày/tuần** | Vd "Qua 3 màn bất kỳ đạt 2★", "Thu hoạch 20 ô tier ≥3" — thưởng xu, không ép chơi màn cụ thể. | State mới: `SaveData.dailyProgress`, reset theo ngày (client-side, chấp nhận gian lận đổi giờ máy ở bản không server). |
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
| **Phase 3c** | Sổ công thức, nhiệm vụ ngày/tuần | Không phụ thuộc — làm song song bất kỳ lúc nào |
| **Phase 4** | Vùng 5 Cao nguyên, art thật thay emoji (đã ghi SPECS.md Phase 3) | — |
| **Phase 5+** | Vùng sự kiện Tết, các Vùng đặc sản mở thêm theo nhu cầu | Chỉ cần data mới nếu không thêm cơ chế |

---

## 10. Câu hỏi còn mở

1. **Undo/vật phẩm hỗ trợ dùng xu hay giới hạn số lần/ngày?** Ảnh hưởng cảm giác khó — chưa quyết.
2. **Sự kiện Tết có cần chặn bằng thời gian thực (ngày hệ thống) hay chỉ là 1 Vùng thường mở vĩnh viễn sau
   khi ra mắt lần đầu?** Đơn giản hơn là làm vĩnh viễn trước, thêm giới hạn thời gian sau nếu cần.
3. **Có cần thêm tiền tệ cứng (gems) khi bắt đầu tính đến monetize không, hay giữ chỉ 1 loại xu xuyên suốt?**
   Đề xuất giữ 1 loại tới khi có quyết định kinh doanh rõ ràng.
4. **Unity POC (nhánh `unity-poc`) có kế thừa thiết kế này hay là nhánh thử nghiệm riêng, độc lập với bản
   web?** Cần chốt trước khi đầu tư thêm vào Unity port.

---

*Tài liệu này không thay thế SPECS.md. Khi 1 mục ở đây được code xong, dời phần mô tả "as-built" sang
SPECS.md và xoá/rút gọn ở đây.*
