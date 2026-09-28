# Thiết kế lại (v3) — Hành trình khởi nghiệp: Nông trại → Ẩm thực Việt → Nhà hàng quốc tế

> **Thay thế** `GAME_DESIGN.md §2, §2.1, §2.1a, §2.1b, §11, §12, §13` và toàn bộ `STORY_CONCEPTS.md` — theo
> quyết định của user (2026-09-28): bỏ khung "5 Vùng theo miền Việt Nam" + "Sổ tay Bà Năm/4 phương án story",
> thiết kế lại từ đầu theo đúng ý tưởng mới. Các mục đó trong `GAME_DESIGN.md` đã gắn banner trỏ sang đây.
>
> **Vẫn giữ nguyên, không đổi** (không phụ thuộc câu chuyện/vùng miền): `GAME_DESIGN.md §3` (mở rộng chain:
> tier/skin), `§4` (vật cản, `stages`, lưới/tier, `combo`), `§5` (hệ tiến trình meta: farm/cookbook/order
> board/booster), `§6` (kinh tế), `§7` (công thức cân bằng độ khó), `§8` (thay đổi kiến trúc core cần), `§9`
> (lộ trình phát hành — thứ tự Phase vẫn áp dụng, chỉ đổi *nội dung* nhét vào từng Phase). Toàn bộ đây là
> công cụ kỹ thuật dùng chung, tài liệu này chỉ định lại nội dung/câu chuyện chạy trên nền công cụ đó.

---

## 1. Cốt truyện

**Mai** (tên tạm, đổi được) lớn lên ở thành phố, xa quê từ nhỏ. Bà Năm — người duy nhất ở quê cô còn giữ
liên lạc — vừa mất, để lại 1 nông trại bỏ hoang đã lâu và 1 cuốn sổ tay cũ ghi vài công thức dang dở, nét
chữ nguệch ngoạc theo tuổi già. Mai xin nghỉ việc, định về dọn dẹp/bán đất trong vài tuần — rồi ở lại, bắt
đầu gieo trồng lại từ đầu.

Không phản diện, không twist — mạch cảm xúc là **hành trình cá nhân + gây dựng sự nghiệp**: từ 1 nông trại
hoang, qua từng vụ mùa cô hiểu thêm về Bà Năm và mảnh đất, dần mở rộng ra nấu ăn, rồi ra thành phố mở nhà
hàng. Cuốn sổ tay của bà đi theo suốt — không phải "chỉ đường tới người khác" (đã bỏ khung mắt xích notebook
cũ) mà là **nhật ký cá nhân của Mai**, cô tự viết tiếp mỗi khi học được món mới. Đây là lý do trong-truyện
tự nhiên nhất cho việc "sổ luôn còn trang trống" — **không có giới hạn trên**, vì đơn giản là Mai vẫn đang
sống và học nấu ăn tiếp, không cần cớ nào khác để mở nội dung mới.

### 1.1 Vì sao khung này kéo dài vô hạn được

Khác các phương án cũ (cần 1 huyền thoại/mạng lưới có sẵn để "hết" hoặc "chưa hết"), khung này không cần cớ
gì cả: **1 người đang xây sự nghiệp thì luôn còn việc để làm tiếp** — thêm 1 món mới, 1 nước mới cho nhà
hàng quốc tế, đều hợp lý mà không cần giải thích thêm. Đây chính là điều tài liệu cũ gọi là "cấu trúc tuyển
tập" (mỗi Chương độc lập, không mạch nối tiếp) — **vẫn giữ nguyên tắc đó ở đây**: mỗi Chương mới trong Hồi 2
hoặc món mới trong Hồi 3 không cần biết gì về Chương/món khác, chỉ cần khớp với đúng giai đoạn sự nghiệp
(Hồi) mà nó thuộc về.

---

## 2. Cấu trúc: Hồi → Chương → Màn

Đổi tên tầng trên cùng từ **Vùng** (world, gắn với 1 miền địa lý cụ thể — không còn đúng nữa vì Hồi 3 không
phải đất Việt) thành **Hồi** (act — gắn với 1 giai đoạn sự nghiệp của Mai). Cơ chế kỹ thuật bên dưới **không
đổi gì** — vẫn dùng đúng `WorldDef`/`npcId` đã phác ở `GAME_DESIGN.md §11.4/§12.1`, chỉ đổi tên gọi và nội
dung nhét vào:

```
Hồi (Act)                    — 1 giai đoạn sự nghiệp, 4-8+ chương, không giới hạn số chương trước
  └─ Chương (Chapter)        — 1 công thức/công trình, 5 màn (giữ nguyên quy ước hiện tại)
       └─ Màn (Level)        — 1 nguyên liệu/công đoạn, có thể nhiều giai đoạn (§4.2 GAME_DESIGN.md)
```

| Hồi | Giai đoạn sự nghiệp | Nội dung | Trạng thái |
|---|---|---|---|
| **1 — Nông trại** | Mai mới về, dọn lại đất, nuôi con gì trồng cây gì cũng phải học lại từ đầu | Gom thú + trái cây thô, bán qua Chợ (chưa nấu món) | Tái dùng phần lớn nội dung đã có (§3) |
| **2 — Ẩm thực Việt Nam** | Mai bắt đầu nấu bán — món Việt quen thuộc, dần thêm đặc sản vùng miền | Món Việt + đặc sản (nước mắm, khô, mứt...) | Tái dùng gần hết nội dung Vùng 2 cũ (§4), mở thêm |
| **3 — Nhà hàng quốc tế** | Quán đủ tiếng, Mai chuyển lên thành phố, mở nhà hàng phục vụ món quốc tế | Món theo nước: Trung, Nhật, Hàn, mở dần thêm | Hoàn toàn mới (§5) |
| **4 — Cửa hàng thời trang** | Mai lấn sang ngành khác ngoài ăn uống — mở thêm 1 cửa hàng quần áo | Trang phục, nón, giày dép | Mới, ý tưởng ban đầu (§6) |
| **5 — Tiệm cà phê** | Mở thêm 1 tụ điểm đồ uống, tách riêng khỏi nhà hàng chính | Món uống (cà phê, trà sữa, sinh tố...) | Mới, ý tưởng ban đầu (§7) |

**Khác biệt quan trọng với bản cũ:** không Hồi nào giới hạn số Chương trước (bản cũ mỗi Vùng chốt cứng 2-3
chương) — vì không còn phải hết "miền" nào cả, chỉ cần Mai còn mở rộng kinh doanh là còn Hồi/Chương mới được
(§1.1). Số Chương ở các bảng dưới chỉ là **điểm khởi đầu v1.0**, không phải trần. Hồi 4-5 cũng cho thấy rõ
nhất nguyên tắc này: **không nhất thiết phải là đồ ăn** — bất kỳ ngành kinh doanh nào Mai mở thêm đều hợp lệ
trong khung "hành trình khởi nghiệp", đúng chất "cửa hàng nào cũng có thể gộp-tách theo tier" của core game.

### 2.1 Quy tắc mở khoá (không đổi so với `GAME_DESIGN.md §2.2`)

- Hồi mở khi **quá nửa số chương** của Hồi trước đã nấu xong.
- Trong 1 Hồi, các chương vẫn mở tuần tự.
- Không có "Hồi sự kiện" kiểu Tết ở bản này — Tết trở thành **1 Chương trong Hồi 2** (mứt, bánh chưng — vẫn
  là món Việt), không cần tầng riêng nữa vì đã bỏ khung "Vùng 6 sự kiện lặp lại hàng năm" của bản cũ. Có thể
  thêm lại sau nếu vẫn muốn giữ hành vi "mở theo lịch âm" — ghi vào câu hỏi mở ở §7.

---

## 3. Hồi 1 — Nông trại

**Tiền đề trong-game:** đất bỏ hoang, Mai dọn lại từng khoảnh — dạy người chơi đúng luật lõi (gộp/tách) mà
không có áp lực "nấu ăn" gì cả. **Chưa có `cook()`/recipe** ở Hồi này — mỗi Chương chỉ thu hoạch nguyên liệu
thô, bán qua **Chợ** (xem §3.2) thay vì ghép thành món.

### 3.1 Chương đề xuất

| Chương | Chain | Ghi chú |
|---|---|---|
| 1. Trại gà nhỏ *(đã có)* | `poultry` — Trứng→Gà con→Gà giò→Gà mái→Gà trống | Tái dùng y nguyên, đổi khung câu chuyện: không phải "chuồng gà của bà dạy cháu" mà "Mai tự học nuôi lại đàn gà bà để lại" |
| 2. Vườn dừa *(mới)* | `coconut` — 8 tier, xem ví dụ đầy đủ ở §6 | Chain trái cây đầu tiên, minh hoạ đúng công thức user đưa (hạt 2 → trái 256) |
| 3+. Thú/cây khác *(mở dần)* | Heo, bò sữa, rau củ... | Không giới hạn trước — thêm khi cần, đúng nguyên tắc §1.1 |

**"Tô phở bò" (Chương 2 cũ) không còn ở Hồi 1** — đó là 1 MÓN đã nấu, thuộc về Hồi 2. Chỉ còn `poultry` (thu
hoạch gà sống, chưa chế biến) hợp với Hồi 1.

### 3.2 Chợ — đơn đặt hàng (thay Order Board cũ)

Đúng ý "có đơn đặt hàng từ chợ để làm" — tái dùng nguyên khung **Tầng A** đã thiết kế ở `GAME_DESIGN.md
§12.2` (đọc `SaveData.levels[id].stars`/inventory có sẵn, thêm `claimedOrders`), chỉ đổi người giao đơn từ
"NPC vùng" thành **Chợ** — 1 màn hình/thực thể trừu tượng, không cần nhân vật cụ thể:

- 3-5 đơn cố định mỗi Chương, kiểu "Bán 5 quả dừa tier ≥3", "Đủ 1 đàn gà mái" — thưởng xu.
- Không cần NPC ở Hồi 1 nếu muốn tối giản; có thể thêm 1 "cô bán hàng ở Chợ" cho ấm (tuỳ chọn, không bắt
  buộc — xem câu hỏi mở §7).

---

## 4. Hồi 2 — Ẩm thực Việt Nam

**Tiền đề trong-game:** Mai bắt đầu nấu bán — từ món quen thuộc (phở, cơm gà) tới đặc sản mang tính vùng
miền (nước mắm, khô, mứt) khi khách đặt hàng nhiều hơn. Từ Hồi này, `cook()`/`RecipeDef` chính thức xuất
hiện (đã có sẵn trong engine) — mỗi Chương = 1 món hoàn chỉnh, nấu xong mở khoá trang trí quán/farm.

### 4.1 Tái dùng gần như toàn bộ nội dung đã thiết kế

| Chương | Nguồn | Đổi gì |
|---|---|---|
| Tô phở bò | Chương 2 cũ (đã có, live) | Không đổi — chuyển nhãn từ "Vùng 1" sang "Hồi 2, chương đầu" |
| Cơm gà Hội An (Đá) | `GAME_DESIGN.md §11.1`, 5 màn đã thiết kế đủ | Không đổi nội dung — chỉ bỏ khung "Chú Sáu bạn của bà, ở Hội An", đổi thành "Mai học được công thức này khi..." (tự chọn lý do nhẹ, không cần nhân vật) |
| Bánh mì (Cỏ dại) | `GAME_DESIGN.md §11.2` | Tương tự — tái dùng nguyên chain/màn/vật cản |
| Bún chả (Băng) | `GAME_DESIGN.md §11.3` | Tương tự |
| Mứt dừa *(mới)* | Nối dài chain `coconut` từ Hồi 1, xem §6 | Minh hoạ cơ chế chain sâu (tới tier 2048) |
| Nước mắm, khô *(mới, đặc sản)* | `GAME_DESIGN.md §2.1b` đã nghiên cứu sẵn (mắm, tôm khô Cà Mau...) | Dữ liệu nghiên cứu vẫn dùng được — chỉ đổi khung "Vùng 4 Biển đảo" thành "1 Chương trong Hồi 2" |

**Kết quả:** gần như toàn bộ công đã làm ở Vùng 2/§2.1b (chain, tier, obstacle, nghiên cứu món/đặc sản Việt)
đều **tái dùng được 100%** trong Hồi 2 — chỉ đổi lớp vỏ câu chuyện, không phải làm lại từ đầu phần nội dung
món ăn. Đây là lý do nên đọc lại `GAME_DESIGN.md §11` và `§2.1b` trước khi thiết kế Chương mới cho Hồi 2,
thay vì nghiên cứu lại từ đầu.

### 4.2 Vật cản, tier, cơ chế — không đổi

Toàn bộ Đá/Cỏ dại/Băng/Lưới đánh cá (`GAME_DESIGN.md §4.1`), `stages` (§4.2), combo (§4.4) vẫn dùng đúng như
cũ — Hồi 2 chỉ là nơi các cơ chế đó tiếp tục xuất hiện, không cần thiết kế lại.

---

## 5. Hồi 3 — Nhà hàng quốc tế

**Tiền đề trong-game:** quán của Mai đủ tiếng, cô chuyển lên thành phố, mở nhà hàng phục vụ khách đa dạng
hơn — mỗi Chương = 1 món đại diện 1 nước, học từ đầu bếp/tài liệu/đi học thêm (chưa cần nhân vật cụ thể, có
thể bổ sung sau). Đây là nội dung **hoàn toàn mới**, chưa có gì tái dùng được từ bản cũ (bản cũ chỉ có Việt
Nam).

### 5.1 Ứng viên Chương mở màn (3 nước user đã nêu)

| Nước | Món đề xuất | Vì sao hợp làm chain merge |
|---|---|---|
| Trung Quốc | Sủi cảo (dumpling) | Có bước gói/hấp rõ ràng, dễ tách tier: bột→vỏ bánh→nhân→gói→hấp chín |
| Nhật Bản | Sushi/cơm cuộn | Nhiều thành phần (cơm, rong biển, cá) — hợp làm `combo`/`mixed` mode như đã thiết kế cho Vùng 4 cũ |
| Hàn Quốc | Kim chi | Có bước lên men (ủ) — hợp nối dài chain kiểu mứt ở §6 (cải thảo→muối→trộn gia vị→ủ→kim chi chín) |

Đây chỉ là 3 điểm khởi đầu theo đúng 3 nước user nêu — **không giới hạn**, đúng nguyên tắc §1.1: thêm Thái,
Ấn, Ý, Pháp... bất kỳ lúc nào sau, mỗi nước độc lập, không cần lý do gì thêm ngoài "nhà hàng mở rộng thực
đơn".

### 5.2 Việc cần làm trước khi thiết kế chi tiết

Chưa có nghiên cứu sâu (khác hẳn phần Việt Nam đã có nguồn Wikipedia/di sản quốc gia) — trước khi viết bảng
5 màn/chương kiểu `§11` cho từng món quốc tế, nên: xác nhận đúng 3-5 món khởi điểm, tránh chọn món có thể
nhạy cảm/tranh cãi về nguồn gốc văn hoá giữa các nước (vd một số món có tranh chấp nguồn gốc Trung-Nhật-Hàn)
— ưu tiên món ít tranh cãi, đại diện rõ (sủi cảo, sushi, kim chi đều an toàn).

---

## 6. Hồi 4 — Cửa hàng thời trang

**Tiền đề trong-game:** Mai lấn sang 1 ngành hoàn toàn khác ngoài ăn uống — mở 1 cửa hàng quần áo, ban đầu
có thể chỉ là góc nhỏ trong nhà hàng, sau tách riêng. Đây là **chain đầu tiên không phải đồ ăn** — minh hoạ
đúng nguyên tắc "core thuần, nội dung là data" (`SPECS.md §11.1`): luật gộp/tách không quan tâm nội dung là
gì, nên đổi hẳn sang thời trang không cần sửa gì ở `core/`.

| Chương | Chain đề xuất | Tier gợi ý (thay "hạt→trái" bằng "nguyên liệu→sản phẩm hoàn thiện") |
|---|---|---|
| Trang phục | `clothing` | Vải vụn → mảnh vải → áo mộc → áo hoàn thiện → bộ trang phục → bộ sưu tập (tier sâu hơn nếu muốn nối dài kiểu §8) |
| Nón | `hat` | Vành nón → khung nón → nón mộc → nón hoàn thiện → nón thời trang |
| Giày dép | `shoes` | Da/vải → đế giày → giày mộc → giày hoàn thiện → giày hiệu |

3 chain độc lập, đúng nguyên tắc §1.1 — không cần làm cả 3 cùng lúc, làm chương nào trước cũng được.

## 7. Hồi 5 — Tiệm cà phê

**Tiền đề trong-game:** Mai mở thêm 1 tụ điểm đồ uống — có thể là góc cà phê trong nhà hàng, hoặc quán riêng
tách biệt tuỳ chọn khi viết chi tiết. Đây là dịp dùng lại ý tưởng "cà phê Cao Nguyên" đã có ở bản Vùng cũ
(`GAME_DESIGN.md §2.1` cũ, Vùng 5) — nguyên liệu cà phê vẫn tái dùng được, chỉ đổi khung từ "1 miền" sang
"1 loại hình kinh doanh".

| Chương | Chain đề xuất | Tier gợi ý |
|---|---|---|
| Cà phê | `coffee` | Hạt cà phê xanh → rang → xay → pha → ly cà phê thành phẩm |
| Trà sữa | `milkTea` | Trà khô → pha trà → thêm sữa → trân châu → ly trà sữa hoàn chỉnh |
| Sinh tố/nước ép *(mở thêm)* | tuỳ trái cây đã có ở Hồi 1 (vd dừa, xoài...) | Tái dùng nguyên liệu Hồi 1, chỉ thêm bước pha chế — giống cách "Mứt dừa" nối dài chain ở §8 |

Ghi chú: `milkTea` (trà sữa) đang là thức uống rất phổ biến ở Việt Nam hiện nay — hợp làm chương đầu tiên dễ
gây thiện cảm nếu muốn ưu tiên độ nhận diện hơn cà phê truyền thống.

---

## 8. Cơ chế chain nối dài — tier sâu (2 → 2048)

Đáp ứng đúng ví dụ user đưa. **Không phải cơ chế mới về kỹ thuật** — dùng lại đúng khả năng `initialTiles`
đã có sẵn trong engine (chain `broth` hiện tại đã khởi đầu 1 màn bằng `initialTiles` tier 5), chỉ áp dụng có
chủ đích để 1 chain kéo dài qua nhiều Chương/Hồi thay vì dừng ở tier 7 như quy tắc cũ (`GAME_DESIGN.md
§3.2`).

### 8.1 Ví dụ đầy đủ: Dừa (Hồi 1) → Mứt dừa (Hồi 2)

| Tier | Giá trị | Tên | Ở đâu |
|---|---|---|---|
| 1 | 2 | Hạt dừa giống | Hồi 1, Chương "Vườn dừa", màn đầu |
| 2 | 4 | Chồi dừa | " |
| 3 | 8 | Mầm dừa | " |
| 4 | 16 | Cây dừa non | " |
| 5 | 32 | Cây dừa lớn | " |
| 6 | 64 | Cây dừa trưởng thành | " |
| 7 | 128 | Hoa dừa | " |
| 8 | 256 | Trái dừa | Hồi 1, màn boss — thu hoạch tại đây, `producesIngredient` cho Chợ |
| 9 | 512 | Cùi dừa phơi khô | Hồi 2, Chương "Mứt dừa" — **màn khởi đầu bằng `initialTiles` tier 8** (dùng lại đúng khả năng engine hiện có) |
| 10 | 1024 | Dừa ngâm đường | " |
| 11 | 2048 | Mứt dừa thành phẩm | " — màn cuối chương, đúng giá trị 2048 biểu tượng của thể loại game |

### 8.2 Vấn đề kỹ thuật cần giải quyết: tier 9-11 trên lưới nào?

Tier 11 cần rất nhiều lượt gộp nếu làm trong 1 màn thường (lưới 5×5/6×6 không đủ, đã cảnh báo ở `§3.2`:
tier 4 trên lưới 5×5 tỉ lệ thắng bot ngẫu nhiên chỉ 21%). **Không cần cơ chế mới** — dùng đúng tính năng
**`stages`** đã thiết kế sẵn nhưng chưa code (`GAME_DESIGN.md §4.2`): màn "Mứt dừa" là **1 màn 3 giai đoạn**
(giai đoạn 1 → tier 9, giai đoạn 2 → tier 10, giai đoạn 3 → tier 11), bàn không reset giữa các giai đoạn —
đúng mục đích `stages` được thiết kế ra ("chia nhỏ level", user đã yêu cầu từ tài liệu gốc). Đây là lý do
nên **ưu tiên code `stages` sớm** nếu muốn làm chain sâu kiểu này (xem lại thứ tự Phase ở `GAME_DESIGN.md
§9` — `stages` hiện xếp ở Phase 3a, có thể cần đẩy lên sớm hơn tuỳ khi nào làm tới Chương "Mứt dừa").

### 8.3 Nguyên tắc áp dụng cho chain khác

- Không phải chain nào cũng cần đi tới tier 11 — chỉ áp dụng cho món/sản phẩm có **bước chế biến rõ rệt sau
  thu hoạch** (mứt, kim chi, nước mắm ủ lâu, hoặc bên Hồi 4/5: vải→trang phục, hạt cà phê→ly cà phê). Chain
  đơn giản (trứng, thịt tươi) vẫn dừng ở tier 5-7 như cũ.
- Tier trần "7" ở `§3.2` vẫn là **mặc định cho 1 Chương/màn đơn**, không phải trần tuyệt đối cho cả chain —
  chain được phép "nối" sang Chương/Hồi sau bằng `initialTiles`, mỗi đoạn nối vẫn tôn trọng trần 7 tier/màn.
- Việc cần làm ở `sim/simulate.ts` (đã cảnh báo ở `GAME_DESIGN.md §7`): bot cần hiểu `initialTiles` khởi đầu
  ở tier cao khi tune `moveLimit` cho các Chương "nối dài" này.

---

## 9. Câu hỏi còn mở

1. ~~Tên nhân vật chính~~ **Đã chốt: Mai.**
2. **Hồi 1 có cần 1 NPC "cô bán hàng ở Chợ" cho ấm không, hay để trừu tượng (chỉ có UI đơn hàng, không nhân
   vật)?** → **Đã chốt: có** — xem §11, Ông Tư đảm nhiệm vai trò này.
3. **Bỏ hẳn Vùng 6 Tết (sự kiện lặp lại hàng năm) hay giữ lại dưới dạng 1 Chương Tết trong Hồi 2 mở quanh
   năm (không giới hạn thời gian)?** Đề xuất ở §2.1 là gộp vào Hồi 2 như 1 chương thường — cần xác nhận.
4. ~~Hồi 3-5 có cần nhân vật riêng...~~ **Đã chốt: có, mỗi Hồi 1 NPC** — xem bảng đầy đủ ở §11.
5. **Trung/Nhật/Hàn — giữ đúng 3 món đề xuất ở §5.1 hay đổi?**
6. **Thứ tự làm Hồi 4/5 — ngay sau Hồi 3, hay xen giữa Hồi 2/3 nếu muốn có nội dung "không phải đồ ăn" sớm
   hơn để đổi vị cho người chơi?** Cấu trúc tuyển tập (§1.1) cho phép làm theo bất kỳ thứ tự nào.
7. **`stages` (multi-stage level) hiện xếp Phase 3a ở lộ trình cũ — có cần đẩy sớm hơn không?** → Phát hiện
   mới khi thiết kế §14: `stages` cần **sớm hơn dự kiến** — không chỉ cho Chương "Mứt dừa" mà ngay cả màn
   boss "Vườn dừa" (Hồi 1) cũng chạm trần nếu muốn ép tới tier 8 trong 1 màn thường (xem §14.3). Đề xuất đẩy
   `stages` lên làm cùng đợt với Đá (Phase 2a), sớm hơn nhiều so với Phase 3a cũ.
8. **Vật cản "Hư hao" (§13) giới thiệu ở đúng Chương "Vườn dừa" (Hồi 1) như đề xuất, hay dời sang Hồi khác
   phù hợp chủ đề hơn (vd Hồi 5 cà phê — hạt cà phê mốc nếu để lâu)?**

---

## 10. Việc cần làm tiếp

1. Xác nhận các câu hỏi mở ở §9.
2. Viết bảng chi tiết kiểu `GAME_DESIGN.md §11` cho: Chương "Vườn dừa" (Hồi 1), Chương "Mứt dừa" (Hồi 2,
   minh hoạ `stages`), 3 chương Hồi 3 (sủi cảo/sushi/kim chi), chương mở màn Hồi 4 (trang phục/nón/giày dép)
   và Hồi 5 (cà phê/trà sữa).
3. Cập nhật `worlds.ts`/`WorldDef` (đã phác ở `GAME_DESIGN.md §11.4`) — đổi 2 World hiện có (`world1`,
   `world2`) thành đúng nhãn Hồi 1/Hồi 2, xoá giả định "world = 1 miền Việt Nam".
4. `LevelIntroDialog`/`LevelResultDialog`: không cần đổi gì về mặt kỹ thuật (vẫn dùng `NpcLines` nếu có NPC,
   bỏ qua nếu Hồi đó không có nhân vật — `npcLine` vốn đã là optional).
5. Không cần code `stages` ngay — chỉ cần khi thật sự làm tới Chương "Mứt dừa"/kim chi Hàn Quốc.

---

## 11. NPC theo Hồi

Đổi từ "1 NPC/miền" (bản cũ) sang **1 NPC/giai đoạn sự nghiệp** — mỗi người là lý do Mai bước sang Hồi tiếp
theo, đúng tinh thần "khởi nghiệp" thay vì "đi thăm vùng miền". Tên đều là đề xuất tạm, đổi được.

| Hồi | NPC | Vai trò |
|---|---|---|
| 1 — Nông trại | **Ông Tư** | Hàng xóm lâu năm, biết rõ đất/nông trại cũ của Bà Năm — chỉ Mai cách dọn lại vườn, đứng ra "trông Chợ" (giao đơn hàng, §3.2) |
| 2 — Ẩm thực Việt Nam | **Cô Hạnh** | Đầu bếp lâu năm ở chợ huyện — dạy Mai nấu món Việt cơ bản trước khi Mai tự biến tấu thành đặc sản riêng |
| 3 — Nhà hàng quốc tế | **Khang** | Bạn học cũ, đang làm đầu bếp trên thành phố — người rủ Mai "lên phố mở quán", dạy món quốc tế |
| 4 — Cửa hàng thời trang | **Linh** | Em gái hoặc bạn thân của Mai, mê thời trang — thuyết phục Mai mở thêm nhánh quần áo cạnh nhà hàng |
| 5 — Tiệm cà phê | **Duy** | Barista trẻ mới vào nghề, ngỏ ý hợp tác mở góc cà phê riêng |

Data model **không đổi** so với `GAME_DESIGN.md §12.1` (`NpcDef`/`NpcLines`) — chỉ điền tên/vai trò mới, gắn
`npcId` vào từng Hồi thay vì từng Vùng.

---

## 12. Cốt truyện chi tiết theo Hồi

Giữ đúng nguyên tắc **tuyển tập, không mạch nối tiếp** (`GAME_DESIGN.md §13` cũ, vẫn áp dụng): mỗi Hồi chỉ
cần biết Mai đang ở giai đoạn nào, không cần biết chi tiết Hồi khác.

| Hồi | Mở đầu (`onWorldEnter`) | Kết thúc (`onWorldComplete`) |
|---|---|---|
| 1 | Mai về tới nông trại hoang, đọc lại vài dòng trong sổ tay của Bà Năm — quyết định ở lại thử vài tháng | Ông Tư: "Vườn với chuồng gọn gàng rồi đó — Chợ huyện đang cần người nấu ngon, con thử chưa?" |
| 2 | Cô Hạnh ghé Chợ, thấy Mai bán nguyên liệu thô mãi — rủ Mai nấu thử vài món bán kèm | Cô Hạnh: "Món con nấu giờ ngon hơn cô hồi trẻ rồi đó — mở hẳn 1 quán nhỏ đi" |
| 3 | Khang tình cờ ghé quán, ngạc nhiên vì món ngon — rủ Mai lên thành phố thử sức | Khang: "Nhà hàng mình giờ đủ sức cạnh tranh rồi — con nghĩ thử mở thêm gì không?" |
| 4 | Linh lên thăm, chê... khen đồ Mai mặc quê mùa — nói vui "hay mở luôn shop quần áo cạnh quán" | Linh: "Không ngờ chị làm thời trang cũng mát tay — giờ thiếu đúng 1 góc cà phê cho khách ngồi lâu hơn thôi" |
| 5 | Duy xin làm thêm ở nhà hàng, đề nghị mở góc pha chế | Duy: "Từ tiệm cà phê nhỏ này, không biết chị còn tính mở gì nữa không nhỉ?" *(câu hỏi ngỏ — cớ tự nhiên cho Hồi 6+ sau này, đúng nguyên tắc §1.1)* |

---

## 13. Vật cản mới — "Hư hao" (Decay)

Vật cản thứ 5 (sau Đá/Cỏ dại/Băng/Lưới đánh cá ở `GAME_DESIGN.md §4.1`), theo đúng yêu cầu trực tiếp của
user — khác hẳn 4 loại cũ ở 2 điểm: **sinh ra dần theo thời gian** (không đặt sẵn từ đầu màn) và **có thể
leo thang thành dạng nặng hơn không tự dọn được**.

### 13.1 Hành vi đầy đủ

| Giai đoạn | Mô tả |
|---|---|
| **Sinh ra** | Cứ mỗi `decaySpawn.every` lượt (đề xuất mặc định 10) mà màn **chưa thắng**, 1 ô trống biến thành **"hư nhẹ"** — chọn theo thứ tự cố định (như quy ước cỏ dại) để test được, dừng sinh thêm nếu đã đạt `decaySpawn.maxActive`. |
| **Va chạm** | 1 lượt vuốt mà có Tile trượt tới và **bị chặn dừng lại** ngay sát ô hư (hành vi giống hệt Đá chặn line) tính là 1 lần va chạm cho ô đó — dùng lại nguyên logic `resolveLine` đã có cho Đá, chỉ thêm bộ đếm. |
| **Dọn ô hư nhẹ** | Sau đúng **5 va chạm** cộng dồn, ô hư nhẹ biến mất, trả lại thành ô trống bình thường. |
| **Leo thang** | Nếu tới mốc sinh ra tiếp theo mà đang có **≥2 ô hư nhẹ chưa dọn xong cùng lúc**, 2 ô đó gộp lại thành **1 ô "hư nặng"** duy nhất (giảm 1 ô trên bàn) — hư nặng **không dọn được bằng va chạm nữa**. |
| **Dọn ô hư nặng** | Chỉ dọn được bằng vật phẩm hỗ trợ mới — **"Bộ Sửa Chữa"** (mua bằng xu/gem, dùng 1 lần xoá ngay 1 ô hư nặng, không cần va chạm) — thêm vào danh sách booster đã có ở `GAME_DESIGN.md §5` (Hoàn tác/Xáo bàn/+lượt). |

### 13.2 Schema (mở rộng `ObstacleDef` đã phác ở `GAME_DESIGN.md §11.5`)

```ts
type ObstacleType = 'rock' | 'weed' | 'ice' | 'net' | 'decay' | 'heavyDecay';
interface ObstacleDef {
  type: ObstacleType;
  row: number; col: number;
  spreadEvery?: number;     // weed
  hitsTaken?: number;       // decay — bộ đếm va chạm, bắt đầu 0
}
interface LevelConfig {
  // ...
  decaySpawn?: { every: number; maxActive: number }; // vd { every: 10, maxActive: 2 }
}
```

`GameSession` cần thêm: đếm lượt kể từ đầu màn (đã có `movesUsed`, tái dùng được), mỗi khi `movesUsed %
decaySpawn.every === 0` mà chưa thắng → thử sinh 1 ô hư nhẹ; sau mỗi lượt vuốt, với mỗi ô hư nhẹ bị chặn ít
nhất 1 line → `hitsTaken++`; `hitsTaken >= 5` → xoá; kiểm tra leo thang ngay sau khi sinh ô hư mới.

### 13.3 Nguyên tắc an toàn (đúng nguyên tắc chung ở `GAME_DESIGN.md §4.1`)

- **Luôn còn đường giải** — vì đây là vật cản sinh ra theo thời gian (khác 4 loại cũ cố định từ đầu), rủi ro
  làm màn bất khả thi cao hơn nếu người chơi chơi chậm. Bắt buộc giới hạn `maxActive` thấp (đề xuất 2, tối
  đa 3 kể cả sau khi leo thang) và `moveLimit` phải đủ dư so với tốc độ sinh ra — cần bot sim xác nhận riêng
  (khác các vật cản cũ, đây là loại đầu tiên có yếu tố *thời gian*, không chỉ *vị trí*).
- Đúng nguyên tắc "1 Vùng/Hồi chỉ giới thiệu 1 cơ chế mới" — Chương giới thiệu "Hư hao" **không** cộng dồn
  thêm Đá/Cỏ dại/Băng cùng lúc (trừ màn boss "tổng ôn", như quy ước đã có).

### 13.4 Giới thiệu ở đâu

Đề xuất Chương "Vườn dừa" (Hồi 1, §14) — khớp chủ đề "trái/hoa để lâu ngoài vườn dễ hư nếu không thu hoạch
kịp". Sau khi giới thiệu, tái dùng được ở Hồi khác (vd Hồi 5: hạt cà phê mốc nếu để lâu) — xem câu hỏi mở
§9.8 nếu muốn đổi chỗ giới thiệu.

---

## 14. Hồi 1 — Nội dung chi tiết & độ khó

### 14.1 Chương 1 "Trại gà nhỏ" — tái dùng nguyên vẹn

Đã có, đang live (`poultry` chain, 5 màn, tier 1-5) — không cần thiết kế lại, chỉ đổi khung câu chuyện đầu
game theo §1/§12 (Mai tự học nuôi lại đàn gà, không phải "cháu về phụ bà còn sống").

### 14.2 Chương 2 "Vườn dừa" — mới, chain 8 tier

Dùng đúng chain `coconut` đã phác ở §8.1 (tier 1-8, hạt→trái). **Quan trọng:** không đặt objective ở tier 7-8
cho bất kỳ màn thường nào (xem §14.3 vì sao) — 5 màn dưới đây chỉ yêu cầu tới tier 6, tier 7-8 người chơi vẫn
tự nhiên chạm tới nếu gộp dư (tự động thu hoạch dư thành xu, đúng cơ chế overflow đã có) và **tier 8 chính
thức xuất hiện lại làm `initialTiles` ở Chương "Mứt dừa"** (§8.1) mà không cần đã từng là objective ở đây.

| Màn | Tên | Objectives | Hư hao | moveLimit* | Ghi chú |
|---|---|---|---|---|---|
| 2-1 | Gieo hạt dừa | t3(mầm)×2 | — | ~16 | Giới thiệu chain, chưa có vật cản |
| 2-2 | Ươm chồi | t3×3 | — | ~22 | |
| 2-3 | Vườn ươm rộng | t3×2 + t4(cây non)×1 | — | ~30 | Lưới 5×5 |
| 2-4 | Cây trưởng thành | t5(cây lớn)×2 | 1 ô hư nhẹ · every=10, max=1 | ~36 | **Giới thiệu "Hư hao"** — chỉ 1 ô, sinh chậm, đủ thời gian làm quen |
| 2-5 | Mùa dừa đầu tiên (Boss) | t6(cây trưởng thành)×1 + t4×2 | every=10, max=2 (từ đầu màn) | ~52 | `boss:true`, lưới 6×6 — 2 ô hư nhẹ có thể leo thang thành 1 hư nặng nếu chơi chậm, đúng đúng tinh thần "làm quen rủi ro leo thang" ở màn cuối chương |

\* Công thức `§7`, chưa cộng `decayPenalty` (chưa có sẵn — cần thêm tương tự `rockPenalty`/`weedPenalty`,
để bot sim tự tune vì đây là vật cản có yếu tố thời gian, khó ước lượng tay chính xác như vật cản tĩnh).

### 14.3 Vì sao objective dừng ở tier 6, không phải tier 8

Kiểm bằng công thức `§7`: 1 tier 8 (target×2⁷=128 đơn vị tier-1) ngay cả với hệ số 1.3 (boss) đã ra ~166 lượt
— vượt xa nhịp "3-8 phút/màn" (`GAME_DESIGN.md §1`). Tier 6 (32 đơn vị) vẫn nằm trong dải đã kiểm chứng ở
Chương 1 (tier 5 = 16 đơn vị, ML36). Đây là lý do kỹ thuật đứng sau câu hỏi mở §9.7 — nếu sau này vẫn muốn 1
màn thường tự nó chạm tier 8 (không đợi qua Chương "Mứt dừa"), **bắt buộc cần `stages`** để chia nhỏ thành
nhiều giai đoạn nhỏ hơn trong cùng 1 màn, y hệt cách áp dụng ở "Mứt dừa" (§8.2).
