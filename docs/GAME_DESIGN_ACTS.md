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

---

## 15. Kế hoạch sản xuất đầy đủ — số chương/màn, lưới, vật cản, vật phẩm mỗi Hồi

Trả lời trực tiếp 5 câu hỏi của user cho **cả 5 Hồi**, không chỉ Hồi 1. Toàn bộ `moveLimit` dùng công thức
`GAME_DESIGN.md §7`: `Σ(target×2^(tier−1)) × hệ số` (hệ số ~1.8-2.0 màn đầu chương, giảm dần còn ~1.4-1.5 màn
boss) — **đều là điểm khởi đầu, chưa chạy `npm run sim`**, đúng nguyên tắc đã áp dụng xuyên suốt tài liệu
này. Vị trí vật cản đặt theo đúng thứ tự đã dùng ở §11 GAME_DESIGN.md/§14: giữa bàn trước, rồi 2 đầu 1 trục,
rồi đổi trục, rồi 4 góc — để không màn nào lặp y hệt màn trước trong cùng chương.

### 15.0 Bảng tổng quan

| Hồi | Số chương dự tính | Số màn | Lưới (thường → boss) | Vật cản dùng | Vật phẩm chính (tier cần) |
|---|---|---|---|---|---|
| 1 — Nông trại | 2 *(mở thêm khi cần)* | 10 | 4×4 → 6×6 | Hư hao *(mới, giới thiệu ở đây)* | Gà (t5) · Dừa (t8, nối sang Hồi 2) |
| 2 — Ẩm thực Việt | 6 | ~28 *("Mứt dừa" dùng `stages`, không đủ 5 màn riêng)* | 4×4 → 6×6 | Đá · Cỏ dại · Băng · Lưới đánh cá *(tái dùng đủ 4 loại cũ)* | Phở (t5) · Gà xé (t5) · Lúa mì (t5) · Heo (t5) · Dừa nối dài (t9-11) · Nước mắm (t5, mới) |
| 3 — Nhà hàng quốc tế | 3 | 15 | 5×5 → 6×6 | Đá · Băng · Cỏ dại *(tái dùng, đổi flavor)* | Sủi cảo (t6) · Sushi (t6) · Kim chi (t7) |
| 4 — Thời trang | 3 | 15 | 5×5 → 6×6 | Lưới đánh cá · Đá · Băng *(tái dùng, đổi flavor)* | Trang phục (t6) · Nón (t5) · Giày dép (t5) |
| 5 — Cà phê | 2 *(+Sinh tố mở thêm)* | 10 | 5×5 | Hư hao · Cỏ dại *(tái dùng)* | Cà phê (t5) · Trà sữa (t5) |
| **Tổng (v1.0 mở rộng)** | **16 chương** | **~78 màn** | | 5 loại, không cần thêm loại mới | 12 chain |

Nguyên tắc xuyên suốt: **không có Hồi nào cần vật cản mới** ngoài "Hư hao" đã thiết kế ở §13 — 4 Hồi còn lại
chỉ tái dùng 5 loại đã có, đổi tên/hình theo chủ đề (đúng nguyên tắc "vật cản là dữ liệu màn" ở
`GAME_DESIGN.md §4.1`). Điều này giữ chi phí kỹ thuật thấp dù nội dung tăng gấp nhiều lần.

### 15.1 Hồi 1 — đã chi tiết đủ ở §14

Chương "Trại gà nhỏ" (có sẵn, live) + Chương "Vườn dừa" (5 màn, lưới 4×4→6×6, vật cản Hư hao) — xem lại §14,
không lặp ở đây.

### 15.2 Hồi 2 — đã có phần lớn, cần thêm 2 chương

Chương Tô phở bò (có sẵn), Cơm gà Hội An/Bánh mì/Bún chả (15 màn đã đủ chi tiết ở `GAME_DESIGN.md §11`, kèm
toạ độ vật cản) — không lặp lại. 2 chương còn thiếu:

**Chương "Mứt dừa"** — nối dài chain `coconut` (§8.1), lưới 6×6, **1 màn 3 giai đoạn** (`stages`, xem §8.2)
thay vì 5 màn riêng:

| Giai đoạn | Objective | Ghi chú |
|---|---|---|
| 1 | t9 (Cùi dừa phơi khô) ×2 | Màn khởi đầu bằng `initialTiles` tier 8 (Trái dừa) — không cần tự gộp từ đầu |
| 2 | t10 (Dừa ngâm đường) ×1 | Bàn giữ nguyên từ giai đoạn 1, không reset |
| 3 (kết) | t11 (Mứt dừa thành phẩm) ×1 | `boss:true`, ML tổng ước lượng ~70-80 (3 giai đoạn cộng dồn, cần sim) |

**Chương "Nước mắm"** *(mới)* — chain `fishSauce`, lưới 5×5, vật cản **Lưới đánh cá** (tái dùng từ ý tưởng
Biển đảo cũ, hợp chủ đề cá cơm):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Cá cơm tươi | 🐟 |
| 2 | Ướp muối | 🧂 |
| 3 | Ủ chượp | 🛢️ |
| 4 | Rút mắm | 🍶 |
| 5 | Nước mắm nguyên chất | 🍶✨ |

| Màn | Objectives | Lưới đánh cá | moveLimit* |
|---|---|---|---|
| 1 | t3×2 | — | ~16 |
| 2 | t3×3 | 1 ô · (2,2) | ~24 |
| 3 | t3×2+t4×1 | 2 ô · (1,2),(3,2) | ~32 |
| 4 | t4×2 | 2 ô · (2,1),(2,3) | ~34 |
| 5 (Boss) | t5×1+t3×2 | 3 ô · (1,1),(3,3),(2,2) | ~48 |

### 15.3 Hồi 3 — Nhà hàng quốc tế (thiết kế mới đầy đủ)

**Chương "Sủi cảo"** — chain `dumpling`, lưới 5×5, vật cản **Đá** (tái dùng):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Bột mì nhào | 🌾 |
| 2 | Vỏ bánh mỏng | ⚪ |
| 3 | Nhân thịt băm | 🥩 |
| 4 | Gói sủi cảo | 🥟 |
| 5 | Hấp chín | ♨️ |
| 6 | Đĩa sủi cảo | 🍽️ |

| Màn | Objectives | Đá | moveLimit* |
|---|---|---|---|
| 1 | t3×2 | — | ~16 |
| 2 | t3×3 | 1 · (2,2) | ~24 |
| 3 | t3×2+t4×1 | 2 · (1,2),(3,2) | ~32 |
| 4 | t4×2 | 2 · (2,1),(2,3) | ~34 |
| 5 (Boss) | t6(Đĩa sủi cảo)×1+t4×2 | 4 · (1,1),(1,3),(3,1),(3,3) | ~54 |

**Chương "Sushi"** — chain `sushi`, lưới 5×5, vật cản **Băng** (tái dùng — "cá cần rã đông"):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Hạt gạo | 🍚 |
| 2 | Cơm giấm | 🍙 |
| 3 | Rong biển cuộn | 🍥 |
| 4 | Cá tươi thái lát | 🐟 |
| 5 | Cuộn sushi | 🍣 |
| 6 | Khay sushi đầy đủ | 🍱 |

| Màn | Objectives | Băng | moveLimit* |
|---|---|---|---|
| 1 | t3×2 | — | ~16 |
| 2 | t3×3 | 1 · (2,2) | ~22 |
| 3 | t3×2+t4×1 | 2 · (1,1),(3,3) | ~30 |
| 4 | t4×2 | 2 · (1,3),(3,1) | ~32 |
| 5 (Boss) | t6(Khay sushi)×1+t4×2 | 3 · (2,2),(1,3),(3,1) | ~52 |

**Chương "Kim chi"** — chain `kimchi`, lưới 6×6 (chain sâu hơn, 7 tier), vật cản **Cỏ dại** (tái dùng — "mốc
lan nếu ủ không kỹ", rất khớp chủ đề lên men):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Cải thảo tươi | 🥬 |
| 2 | Cải thảo muối | 🧂 |
| 3 | Rửa sạch | 💧 |
| 4 | Trộn gia vị ớt | 🌶️ |
| 5 | Cho vào hũ | 🫙 |
| 6 | Ủ men | ⏳ |
| 7 | Kim chi chín | 🥘 |

| Màn | Objectives | Cỏ dại | moveLimit* |
|---|---|---|---|
| 1 | t3×2 | — | ~18 |
| 2 | t3×3 | 1 · (0,0)·N=4 | ~26 |
| 3 | t3×2+t4×1 | 2 · (0,0),(5,5)·N=4 | ~34 |
| 4 | t4×2 | 2 · (0,5),(5,0)·N=3 | ~36 |
| 5 (Boss) | t6(Ủ men)×1+t4×2 | 3 · (0,0),(5,5),(2,2)·N=3 | ~56 |

### 15.4 Hồi 4 — Cửa hàng thời trang (thiết kế mới đầy đủ)

**Chương "Trang phục"** — chain `clothing`, lưới 5×5, vật cản **Lưới đánh cá** (tái dùng — "gỡ cuộn chỉ
rối", tap ×2):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Vải vụn | 🧵 |
| 2 | Mảnh vải | 🪡 |
| 3 | Cắt may | ✂️ |
| 4 | Áo mộc | 👕 |
| 5 | Áo hoàn thiện | 👚 |
| 6 | Bộ trang phục | 👗 |

| Màn | Objectives | Lưới (tap ×2) | moveLimit* |
|---|---|---|---|
| 1 | t3×2 | — | ~16 |
| 2 | t3×3 | 1 · (2,2) | ~24 |
| 3 | t3×2+t4×1 | 2 · (1,2),(3,2) | ~32 |
| 4 | t4×2 | 2 · (2,1),(2,3) | ~34 |
| 5 (Boss) | t6(Bộ trang phục)×1+t4×2 | 3 · (1,1),(3,3),(2,2) | ~54 |

**Chương "Nón"** — chain `hat`, lưới 5×5, vật cản **Đá** (tái dùng):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Vành nón | ⭕ |
| 2 | Khung nón | 🔺 |
| 3 | Nón mộc | 👒 |
| 4 | Nón hoàn thiện | 🎩 |
| 5 | Nón thời trang | 👒✨ |

| Màn | Objectives | Đá | moveLimit* |
|---|---|---|---|
| 1 | t3×2 | — | ~16 |
| 2 | t3×3 | 1 · (2,2) | ~22 |
| 3 | t3×2+t4×1 | 2 · (1,2),(3,2) | ~30 |
| 4 | t4×2 | 2 · (2,1),(2,3) | ~30 |
| 5 (Boss) | t5×1+t3×2 | 4 · (1,1),(1,3),(3,1),(3,3) | ~46 |

**Chương "Giày dép"** — chain `shoes`, lưới 5×5, vật cản **Băng** (tái dùng — "keo dán chưa khô"):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Da/vải | 🟫 |
| 2 | Đế giày | 👞 |
| 3 | Giày mộc | 👟 |
| 4 | Giày hoàn thiện | 👢 |
| 5 | Giày hiệu | 👠 |

| Màn | Objectives | Băng | moveLimit* |
|---|---|---|---|
| 1 | t3×2 | — | ~16 |
| 2 | t3×3 | 1 · (2,2) | ~22 |
| 3 | t3×2+t4×1 | 2 · (1,1),(3,3) | ~30 |
| 4 | t4×2 | 2 · (1,3),(3,1) | ~30 |
| 5 (Boss) | t5×1+t3×2 | 3 · (2,2),(1,3),(3,1) | ~46 |

### 15.5 Hồi 5 — Tiệm cà phê (thiết kế mới đầy đủ)

**Chương "Cà phê"** — chain `coffee`, lưới 5×5, vật cản **Hư hao** (tái dùng — hạt cà phê mốc nếu để lâu,
đúng ý đã nêu ở câu hỏi mở §9.8):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Hạt cà phê xanh | 🌰 |
| 2 | Rang | 🔥 |
| 3 | Xay | ☕ |
| 4 | Pha | 🫖 |
| 5 | Ly cà phê thành phẩm | ☕✨ |

| Màn | Objectives | Hư hao | moveLimit* |
|---|---|---|---|
| 1 | t3×2 | — | ~16 |
| 2 | t3×3 | — | ~22 |
| 3 | t3×2+t4×1 | — | ~30 |
| 4 | t4×2 | 1 ô hư nhẹ · every=10,max=1 | ~36 |
| 5 (Boss) | t5×1+t3×2 | every=10,max=2 (từ đầu) | ~50 |

**Chương "Trà sữa"** — chain `milkTea`, lưới 5×5, vật cản **Cỏ dại** (tái dùng — "trà mốc nếu để ẩm"):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Trà khô | 🍃 |
| 2 | Pha trà | 🫖 |
| 3 | Thêm sữa | 🥛 |
| 4 | Trân châu | ⚫ |
| 5 | Ly trà sữa hoàn chỉnh | 🧋 |

| Màn | Objectives | Cỏ dại | moveLimit* |
|---|---|---|---|
| 1 | t3×2 | — | ~16 |
| 2 | t3×3 | 1 · (0,0)·N=4 | ~24 |
| 3 | t3×2+t4×1 | 2 · (0,0),(4,4)·N=4 | ~32 |
| 4 | t4×2 | 2 · (0,4),(4,0)·N=3 | ~34 |
| 5 (Boss) | t5×1+t3×2 | 3 · (0,0),(4,4),(2,2)·N=3 | ~48 |

### 15.6 Sơ đồ puzzle (board diagram) mẫu

Bảng toạ độ ở trên **là** sơ đồ puzzle dạng dữ liệu (đúng khuôn `initialObstacles` sẽ dùng trong code). Bản
**vẽ trực quan** cho 3 màn tiêu biểu (Vườn dừa Boss, Bún chả Hà Nội Đại boss Hồi 2, Kim chi Boss Hồi 3) đã
thêm vào Artifact **"Mai's Farm — Content & Flow"** (đã publish) — xem 3 artboard mới "Sơ đồ puzzle mẫu".
Các màn còn lại dùng chung 1 bộ quy tắc đặt toạ độ (giữa bàn → 2 đầu 1 trục → đổi trục → 4 góc, xem đầu §15)
nên không cần vẽ hết — vẽ mẫu 3 màn đủ để thấy quy luật.

### 15.7 Việc cần làm tiếp (bổ sung cho §10)

1. Tất cả moveLimit/toạ độ ở §15 đều **chưa chạy sim** — làm sau khi `sim/simulate.ts` hiểu Đá/Cỏ dại/Băng/
   Lưới đánh cá/Hư hao (đã nêu ở §11.6 GAME_DESIGN.md và §13.3).
2. Chương "Mứt dừa" cần code `stages` trước tiên trong số nội dung mới — không màn nào khác ở §15 phụ thuộc
   `stages`.
3. Tên 12 chain mới (coconut đã có ở §8, +`fishSauce`/`dumpling`/`sushi`/`kimchi`/`clothing`/`hat`/`shoes`/
   `coffee`/`milkTea`) đều là đề xuất — đổi tên/emoji/màu tuỳ ý khi làm asset thật, không ảnh hưởng số liệu.

---

## 16. Mở rộng quy mô — user thấy §15 "quá ít nội dung"

User xác nhận thiếu ở **cả 3 hướng cùng lúc**: nhiều chương hơn mỗi Hồi, nhiều màn hơn mỗi chương, nhiều Hồi
hơn ngay từ v1.0. §15.0 giữ nguyên làm tài liệu (số liệu ở đó vẫn đúng cho các chương đã thiết kế), nhưng
**bảng quy mô ở §16.1 dưới đây mới là mục tiêu sản xuất hiện tại**, lớn hơn đáng kể.

### 16.0 Vì sao §15 mỏng — và giới hạn thật sự nằm ở đâu

5 màn/chương không phải giới hạn kỹ thuật — `ChapterDef.levelIds` là 1 mảng độ dài tuỳ ý, không có gì trong
`core/` ép cứng con số 5. Đó chỉ là **quy ước nội dung** kế thừa từ Chương 1 (đã ship). Tương tự, "2-3 chương/
Hồi" ở §15.0 chỉ là điểm khởi đầu thận trọng, không phải trần. Giới hạn thật sự duy nhất là **công sức thiết
kế thủ công** (mỗi màn cần objective + vị trí vật cản + `moveLimit` tính tay) — vì vậy thay vì tiếp tục viết
tay từng màn một, §16.1 đưa ra 1 **công thức tổng quát** áp dụng được cho bất kỳ chương nào, để tăng quy mô
mà không phải nhân công thiết kế lên gấp nhiều lần.

### 16.1 Chuẩn màn/chương mới: 9 màn (thay vì 5)

Áp dụng cho **chương mới** từ đây trở đi (chương đã thiết kế xong ở §11/§14/§15 giữ nguyên 5 màn, không bắt
buộc làm lại — có thể mở rộng sau nếu muốn). Khuôn tổng quát, tự suy ra `moveLimit` bằng công thức `§7`
(`Σtarget×2^(tier−1) × hệ số`, hệ số giảm dần 1.8→1.4 khi tới boss):

| Màn | Objective (tier chain 6-7 cấp) | Vật cản | Hệ số | ML ước lượng* |
|---|---|---|---|---|
| 1 | t3×2 | 0 | 1.8 | ~16 |
| 2 | t3×3 | 0 | 1.7 | ~22 |
| 3 | t3×2+t4×1 | 1 đơn vị | 1.7 | ~28 |
| 4 | t4×2 | 1 đơn vị | 1.6 | ~30 |
| 5 | t4×2+t3×1 | 2 đơn vị | 1.6 | ~36 |
| 6 | t5×1+t3×2 | 2 đơn vị | 1.5 | ~38 |
| 7 | t5×1+t4×1 | 3 đơn vị | 1.5 | ~42 |
| 8 | t5×1+t4×2 | 3 đơn vị | 1.4 | ~46 |
| 9 (Boss) | t6×1+t4×2 | 4 đơn vị | 1.4 | ~58 |

\* Vẫn chỉ là điểm khởi đầu, chưa sim — dùng chung nguyên tắc "chưa đưa thẳng vào code" như mọi số liệu
khác trong tài liệu này. Vị trí vật cản: tiếp tục quy tắc giữa bàn → 2 đầu 1 trục → đổi trục → 4 góc (đã
dùng xuyên suốt §11/§14/§15).

### 16.2 Hồi 1-5 — thêm chương (danh sách, chưa chi tiết từng màn)

| Hồi | Chương đã thiết kế | + Chương thêm mới | Tổng chương | Tổng màn ước tính |
|---|---|---|---|---|
| 1 Nông trại | Trại gà nhỏ · Vườn dừa | **+ Bò sữa · Vườn rau củ** | 4 | 5+5+9+9 = 28 |
| 2 Ẩm thực Việt | Tô phở bò · Cơm gà Hội An · Bánh mì · Bún chả · Mứt dừa · Nước mắm | **+ Bún bò Huế · Mì Quảng · Bánh xèo · Chè** | 10 | ~28 (cũ) + 4×9 = 64 |
| 3 Quốc tế | Sủi cảo · Sushi · Kim chi | **+ Pad Thái (Thái) · Pizza (Ý) · Cà ri (Ấn Độ) · Croissant (Pháp)** | 7 | 3×9 (nâng chuẩn) + 4×9 = 63 |
| 4 Thời trang | Trang phục · Nón · Giày dép | **+ Túi xách · Trang sức** | 5 | 3×9 + 2×9 = 45 |
| 5 Cà phê | Cà phê · Trà sữa | **+ Bánh ngọt · Sinh tố · Kem** | 5 | 2×9 (nâng chuẩn, xem §16.4) + 3×9 = 45 |

Ghi chú: món mới ở Hồi 2 lấy thẳng từ kho đề tài đã nghiên cứu ở `GAME_DESIGN.md §2.1b` (Bún bò Huế/Mì Quảng
đã là di sản quốc gia, Bánh xèo/Chè đã liệt kê sẵn) — không cần nghiên cứu lại.

### 16.3 Hồi 6-8 — mở thêm ngay từ v1.0 (thay vì chỉ "mở dần theo nhu cầu")

Nối tiếp đúng mạch "Mai mở rộng kinh doanh" — không cần lý do mới ngoài "còn ý tưởng kinh doanh khác":

| Hồi | Chủ đề | Chương gợi ý (4 chương/Hồi, 9 màn/chương) |
|---|---|---|
| 6 — Tiệm bánh ngọt | Bakery riêng, tách khỏi góc cà phê | Bánh kem sinh nhật · Bánh quy · Chocolate · Bánh Trung thu |
| 7 — Quà tặng & hoa | Cửa hàng quà lưu niệm cạnh nhà hàng | Hoa tươi · Nến thơm · Đồ thủ công · Giỏ quà |
| 8 — Homestay tại nông trại | **Khép vòng lại đúng nơi bắt đầu** — Mai cải tạo nông trại cũ (Hồi 1) thành homestay, mang mọi thứ đã gây dựng (nông sản, món ăn, phong cách) về lại | Nội thất · Vườn cảnh · Dịch vụ đón khách · Trải nghiệm nông trại |

Hồi 8 đặc biệt đáng làm sớm về mặt câu chuyện: nó tạo **điểm khép vòng cảm xúc** cho toàn bộ hành trình (bắt
đầu ở nông trại hoang, "kết" tạm bằng nông trại hồi sinh thành homestay) — trong khi Hồi 6-7 thuần là mở
rộng kinh doanh, không có ý nghĩa tường thuật đặc biệt (khớp nguyên tắc modular ở §1.1 — không Hồi nào bắt
buộc phải có ý nghĩa gì đặc biệt để hợp lệ).

Tổng thêm: 3 Hồi × 4 chương × 9 màn = 12 chương, 108 màn.

### 16.4 Ví dụ đầy đủ theo chuẩn 9 màn — mở rộng Chương "Cà phê" (Hồi 5)

Áp dụng khuôn §16.1 vào đúng chain `coffee` đã có ở §15.5 (nới chain từ 5 lên 6 tier để đủ chỗ ramp 9 màn —
thêm 1 tier "Rang kỹ hai lần" giữa Rang và Xay):

| Tier | Tên |
|---|---|
| 1 | Hạt cà phê xanh |
| 2 | Rang |
| 3 | Rang kỹ hai lần *(tier mới)* |
| 4 | Xay |
| 5 | Pha |
| 6 | Ly cà phê thành phẩm |

| Màn | Objectives | Hư hao | moveLimit* |
|---|---|---|---|
| 1 | t3×2 | — | ~16 |
| 2 | t3×3 | — | ~22 |
| 3 | t3×2+t4×1 | 1 ô · every=12,max=1 | ~28 |
| 4 | t4×2 | 1 ô · every=12,max=1 | ~30 |
| 5 | t4×2+t3×1 | 1 ô · every=10,max=1 | ~36 |
| 6 | t5×1+t3×2 | 1 ô · every=10,max=1 | ~38 |
| 7 | t5×1+t4×1 | every=10,max=2 | ~42 |
| 8 | t5×1+t4×2 | every=10,max=2 | ~46 |
| 9 (Boss) | t6×1+t4×2 | every=8,max=2 (từ đầu) | ~58 |

Chương "Trà sữa" và mọi chương khác ở §16.2/§16.3 làm theo đúng khuôn này khi tới lượt thiết kế chi tiết.

### 16.5 Quy mô tổng sau khi mở rộng

| | Trước (§15) | Sau (§16) |
|---|---|---|
| Số Hồi | 5 | **8** |
| Số chương | 16 | **43** |
| Số màn | ~78 | **~381** |

Gần với thang "vài trăm màn" của game merge/farm thương mại mà user tham chiếu. Đánh đổi: khối lượng thiết
kế chi tiết (objective/vật cản/`moveLimit` từng màn) còn rất lớn — §16.2/§16.3 mới dừng ở tên chương, chưa
có bảng màn đầy đủ như §16.4 đã làm mẫu cho "Cà phê". Đây là backlog thật, không giả vờ đã xong.

### 16.6 Việc cần làm tiếp (bổ sung §15.7)

1. Viết bảng 9 màn đầy đủ (theo khuôn §16.4) cho từng chương mới ở §16.2/§16.3 — ưu tiên theo đúng thứ tự
   Hồi (1→2→…→8), không nhảy cóc, đúng nguyên tắc đã có ở §2.1a GAME_DESIGN.md.
2. Xác nhận lại danh sách món/chương gợi ý ở §16.2/§16.3 — đều là đề xuất, đổi được trước khi thiết kế chi
   tiết (đỡ phí công nếu đổi sau khi đã viết bảng màn).
3. `sim/simulate.ts` càng cần sớm hơn nữa với quy mô này — 381 màn tune bằng tay gần như không khả thi, bot
   sim không còn là "nên có" mà là **bắt buộc** trước khi đưa bất kỳ số liệu §16 nào vào code thật.

---

## 17. Chi tiết đầy đủ — 6 chương đầu tiên theo chuẩn 9 màn

Trả lời trực tiếp "lên chi tiết từng màn/chương + vật cần merge + layout puzzle" cho §16.2. **43 chương là
khối lượng rất lớn** (~774 dòng nếu làm hết cùng lúc) — làm theo đúng thứ tự ưu tiên đã chốt ở §16.6 (Hồi
1→8, không nhảy cóc): trọn Hồi 1 + Hồi 2 mở rộng trước (6 chương mới, 54 màn). Hồi 3-8 (21 chương còn lại)
làm ở lượt sau, dùng đúng công thức này — không cần đợi user nhắc lại.

**Layout puzzle** dùng 1 khuôn toạ độ cố định cho cả 6 chương (đúng tinh thần "công thức tổng quát" ở §16.1
— không cần vẽ riêng từng chương, chỉ đổi loại vật cản):

| Màn | Lưới | Vật cản (số·toạ độ) |
|---|---|---|
| 1-2 | 4×4 | — |
| 3-4 | 4×4 | 1 · (2,2) |
| 5-6 | 5×5 | 2 · (1,2),(3,2) rồi (2,1),(2,3) |
| 7-8 | 5×5 | 3 · (1,2),(3,2),(2,2) rồi (2,1),(2,3),(2,2) |
| 9 (Boss) | 6×6 | 4 · (1,1),(1,3),(3,1),(3,3) |

### 17.1 Hồi 1 — 2 chương mới

**Chương "Bò sữa"** — chain `dairyCow`, vật cản **Hư hao** (tái dùng từ Vườn dừa, cùng Hồi):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Bê con | 🐄 |
| 2 | Bò tơ | 🐮 |
| 3 | Bò sữa non | 🥛 |
| 4 | Bò sữa trưởng thành | 🐄 |
| 5 | Vắt sữa | 🫗 |
| 6 | Thùng sữa tươi | 🥛✨ |

| Màn | Objectives | Hư hao | moveLimit* |
|---|---|---|---|
| 1 | t3×2 | — | ~16 |
| 2 | t3×3 | — | ~22 |
| 3 | t3×2+t4×1 | 1 ô · every=12,max=1 | ~28 |
| 4 | t4×2 | 1 ô · every=12,max=1 | ~30 |
| 5 | t4×2+t3×1 | 1 ô · every=10,max=1 | ~36 |
| 6 | t5×1+t3×2 | 2 ô · every=10,max=2 | ~38 |
| 7 | t5×1+t4×1 | 2 ô · every=10,max=2 | ~42 |
| 8 | t5×1+t4×2 | 2 ô · every=8,max=2 | ~46 |
| 9 (Boss) | t6×1+t4×2 | every=8,max=3 (từ đầu) | ~58 |

**Chương "Vườn rau củ"** — chain `vegetable`, **không vật cản** (màn nghỉ, giống Chương 1 gốc — không phải
chương nào cũng cần vật cản):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Hạt giống rau | 🌱 |
| 2 | Mầm rau | 🌿 |
| 3 | Cây rau non | 🥬 |
| 4 | Luống rau | 🥕 |
| 5 | Rau củ chín | 🥦 |
| 6 | Rổ rau tươi | 🧺 |

| Màn | Objectives | moveLimit* |
|---|---|---|
| 1 | t3×2 | ~15 |
| 2 | t3×3 | ~20 |
| 3 | t3×2+t4×1 | ~24 |
| 4 | t4×2 | ~26 |
| 5 | t4×2+t3×1 | ~30 |
| 6 | t5×1+t3×2 | ~32 |
| 7 | t5×1+t4×1 | ~36 |
| 8 | t5×1+t4×2 | ~38 |
| 9 (Boss) | t6×1+t4×2 | ~48 |

### 17.2 Hồi 2 — 4 chương mới (lấy đề tài từ `GAME_DESIGN.md §2.1b` đã nghiên cứu)

**Chương "Bún bò Huế"** — chain `bunBoHue`, vật cản **Đá** (tái dùng):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Xương bò | 🦴 |
| 2 | Ninh nước lèo | 🍲 |
| 3 | Sả ớt | 🌶️ |
| 4 | Thịt bò tái | 🥩 |
| 5 | Chả cua | 🦀 |
| 6 | Tô bún bò Huế | 🍜 |

**Chương "Mì Quảng"** — chain `miQuang`, vật cản **Cỏ dại** (tái dùng):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Gạo xay | 🌾 |
| 2 | Bánh tráng mì | ⚪ |
| 3 | Sợi mì vàng | 🍜 |
| 4 | Tôm thịt | 🍤 |
| 5 | Nước lèo sánh | 🥣 |
| 6 | Tô mì Quảng | 🍛 |

**Chương "Bánh xèo"** — chain `banhXeo`, vật cản **Lưới đánh cá** (tái dùng — đổi flavor "dầu nóng bắn, cần
gạt 2 lần mới lấy được"):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Bột gạo | 🌾 |
| 2 | Nước cốt dừa | 🥥 |
| 3 | Nhân tôm thịt | 🍤 |
| 4 | Đổ bánh | 🍳 |
| 5 | Gấp bánh | 🥟 |
| 6 | Đĩa bánh xèo | 🍽️ |

**Chương "Chè"** — chain `che`, vật cản **Hư hao** (tái dùng — "đá/nước cốt tan nếu để lâu", rất khớp chủ đề
món lạnh):

| Tier | Tên | Emoji |
|---|---|---|
| 1 | Đậu xanh | 🫘 |
| 2 | Nấu chè | 🍲 |
| 3 | Nước cốt dừa | 🥥 |
| 4 | Thạch/trân châu | ⚫ |
| 5 | Ly chè mát | 🍧 |
| 6 | Chè thập cẩm | 🍨 |

Cả 4 chương dùng chung **1 bảng màn** (chỉ khác cột vật cản — cùng số lượng/toạ độ theo khuôn đầu §17, chỉ
đổi loại vật cản tương ứng mỗi chương):

| Màn | Objectives | Đá (Bún bò Huế) | Cỏ dại (Mì Quảng) | Lưới (Bánh xèo) | Hư hao (Chè) | moveLimit* |
|---|---|---|---|---|---|---|
| 1 | t3×2 | — | — | — | — | ~16 |
| 2 | t3×3 | — | — | — | — | ~22 |
| 3 | t3×2+t4×1 | 1·(2,2) | 1·(2,2)·N=4 | 1·(2,2) | 1·every=12,max=1 | ~28 |
| 4 | t4×2 | 1·(2,2) | 1·(2,2)·N=4 | 1·(2,2) | 1·every=12,max=1 | ~30 |
| 5 | t4×2+t3×1 | 2·(1,2),(3,2) | 2·(1,2),(3,2)·N=4 | 2·(1,2),(3,2) | 1·every=10,max=1 | ~36 |
| 6 | t5×1+t3×2 | 2·(2,1),(2,3) | 2·(2,1),(2,3)·N=3 | 2·(2,1),(2,3) | 2·every=10,max=2 | ~38 |
| 7 | t5×1+t4×1 | 3·(1,2),(3,2),(2,2) | 3·cùng·N=3 | 3·cùng | 2·every=10,max=2 | ~42 |
| 8 | t5×1+t4×2 | 3·(2,1),(2,3),(2,2) | 3·cùng·N=3 | 3·cùng | 2·every=8,max=2 | ~46 |
| 9 (Boss) | t6×1+t4×2 | 4·4 góc | 4·4 góc·N=3 | 4·4 góc | every=8,max=3 | ~58 |

\* Tất cả moveLimit ở §17 dùng đúng công thức `GAME_DESIGN.md §7`, **chưa qua sim** — điểm khởi đầu, giống
mọi số liệu khác trong tài liệu.

### 17.3 Tiến độ & còn lại

| Hồi | Chương cần chi tiết | Đã xong (§14/§15/§17) | Còn lại |
|---|---|---|---|
| 1 | 4 | 4 ✓ | 0 |
| 2 | 10 | 10 ✓ | 0 |
| 3 | 7 | 3 (§15.3) | 4 (Pad Thái, Pizza, Cà ri, Croissant) |
| 4 | 5 | 3 (§15.4) | 2 (Túi xách, Trang sức) |
| 5 | 5 | 2 (§15.5, mẫu 9 màn ở §16.4) | 3 (Bánh ngọt, Sinh tố, Kem) |
| 6-8 | 12 | 0 | 12 (toàn bộ) |
| **Tổng** | **43** | **22** | **21** |

Hồi 1-2 (10 chương) giờ đã **xong hoàn toàn** ở chuẩn mới. Hồi 3-8 (21 chương) dùng đúng khuôn toạ độ +
công thức moveLimit ở đầu §17 khi tới lượt — chỉ cần thiết kế chain (tier/tên/emoji) + chọn vật cản tái
dùng cho từng chương, không cần nghĩ lại cấu trúc màn.

---

## 18. Hồi 1 v2 — mở rộng nội dung nông trại (~175-185 màn)

User phản hồi: Hồi 1 (4 chương, §14/§17.1) quá mỏng so với tiềm năng thật của chủ đề "nông trại" — còn rất
nhiều loại trái cây/vật nuôi chưa dùng tới, và chưa khai thác 2 khả năng đã có sẵn trong engine: (a) nối
chuỗi bằng `initialTiles` (đã dùng cho Mứt dừa, §8.2) để biến **mỗi loại trái cây thành 2 chương** (thu
hoạch → làm mứt), và (b) nhiều chain spawn cùng lúc trên 1 bàn (đã dùng ở §17.2 dạng "cùng bảng khác vật
cản", giờ đẩy xa hơn thành **nhiều chain khác nhau cùng lúc trên 1 bàn**). Không cần cơ chế engine mới —
chỉ cần nhiều `ChainDef` hơn và phối `LevelConfig.chains` (nhiều mảng spawn) trong cùng 1 màn.

### 18.0 Nguyên tắc

- Mỗi loại trái cây/ngũ cốc mới = 1 chương "thu hoạch" (5-6 tier, vật cản tái dùng theo vòng Đá→Cỏ dại→
  Băng→Lưới→Hư hao, không tạo vật cản mới).
- Trái cây có mứt = thêm 1 chương "mứt" ngay sau, dùng `initialTiles` bắt đầu từ tier cao nhất của chương
  thu hoạch (đúng mẫu Mứt dừa §8.2) — nối chuỗi trong cùng Hồi thay vì phải đợi sang Hồi 2.
- Vật nuôi: tách sản phẩm theo con vật thay vì gộp chung (gà đã có trứng ở Chương 1 → thêm chương riêng
  "gà thịt"; bò giữ nguyên "sữa"; thêm heo "thịt heo"). Không lặp lại chain "thịt bò" (đã dùng ở Hồi 2 Tô
  phở bò) để tránh trùng vật phẩm giữa 2 Hồi.
- "Chó giữ trại": theo yêu cầu, đây là **1 mission trong 1 chương**, không phải cơ chế companion mới — dùng
  đúng merge bình thường nhưng trên "bàn nhiễu" (nhiều chain vật nuôi nhỏ spawn cùng lúc, chỉ 1 chain tính
  vào mục tiêu). Chi tiết ở §18.3.
- "Phiên chợ": chương ngắn (6 màn), bàn lớn hơn (7×7/8×8), 2-3 chain khác nhau từ các chương trước spawn
  cùng lúc, mục tiêu gồm nhiều icon (giống mẫu 2 objective/màn đã có, chỉ mở rộng từ 1 chain lên 2-3 chain).
  Xen kẽ sau mỗi 2-3 chương thu hoạch/mứt để đóng "đơn hàng lớn" — không giới thiệu vật phẩm mới, chỉ tái
  sử dụng vật phẩm đã học.

### 18.1 Danh sách chương mới

| # | Chương | Chain | Tier | Vật cản | Loại | Màn |
|---|---|---|---|---|---|---|
| 5 | Vườn táo | `apple` | 5 | Đá | thu hoạch | 9 |
| 6 | Mứt táo | `apple` nối t6-8 (`initialTiles` từ t5) | +3 | Đá (tái dùng) | mứt | 9 |
| 7 | Ruộng dưa hấu | `watermelon` | 5 | Cỏ dại | thu hoạch | 9 |
| 8 | Mứt dưa hấu | `watermelon` nối t6-8 | +3 | Cỏ dại (tái dùng) | mứt | 9 |
| 9 | Vườn thanh long | `dragonfruit` | 5 | Băng | thu hoạch | 9 |
| 10 | Vườn xoài | `mango` | 5 | Lưới đánh cá (đổi flavor "lưới che nắng") | thu hoạch | 9 |
| 11 | Mứt xoài | `mango` nối t6-8 | +3 | Lưới (tái dùng) | mứt | 9 |
| 12 | Vườn thơm | `pineapple` | 5 | Hư hao (đổi flavor "thơm chín để lâu dễ hư") | thu hoạch | 9 |
| 13 | Mứt thơm | `pineapple` nối t6-8 | +3 | Hư hao (tái dùng) | mứt | 9 |
| 14 | Ruộng lúa | `rice` | 5 | Đá | thu hoạch | 9 |
| 15 | Ruộng ngô | `corn` | 5 | Cỏ dại | thu hoạch | 9 |
| 16 | Trại heo | `pork` | 5 | Băng | vật nuôi | 9 |
| 17 | Trại gà thịt | `chickenMeat` (tách từ `poultry`/trứng) | 5 | Lưới đánh cá | vật nuôi | 9 |
| 18 | Chó giữ trại | `guardDog` (+ nhiễu `cat`/`mouse`) | 4 | Đá | mission/bàn nhiễu | 9 |
| 19-22 | Phiên chợ I-IV | tổ hợp 2-3 chain đã học | — | không vật cản mới | combo | 6/chương |

Cộng 4 chương hiện có (§14/§17.1, 4 chương ≈ 28 màn) + 18 chương mới ở trên (~157 màn) = **22 chương,
~185 màn** cho riêng Hồi 1 — đúng khoảng 100-200 mà user đề xuất, không cần vượt tier 8 ở bất kỳ chain nào
(giữ nguyên giới hạn kỹ thuật đã lập ở §14.3).

### 18.2 Mứt — nối chuỗi trong cùng Hồi

Áp permanent mẫu Mứt dừa (§8.2) cho 4 loại trái cây có mứt (táo/dưa hấu/xoài/thơm). Ví dụ đầy đủ — Chương
"Mứt táo":

| Tier | Tên | Emoji | Nguồn |
|---|---|---|---|
| 5 | Táo chín (Trái) | 🍎 | tier cao nhất của Chương "Vườn táo", dùng làm `initialTiles` |
| 6 | Táo thái lát | 🍏 | merge mới trong chương này |
| 7 | Ngâm đường | 🍯 | |
| 8 | Mứt táo | 🍬 | boss màn cuối |

| Màn | Objectives | Đá | moveLimit* |
|---|---|---|---|
| 1 | t6×2 (bắt đầu bàn đã có sẵn vài ô t5 nhờ `initialTiles`) | — | ~18 |
| 2 | t6×3 | — | ~24 |
| 3 | t6×2+t7×1 | 1·(2,2) | ~30 |
| 4 | t7×2 | 1·(2,2) | ~32 |
| 5 | t7×2+t6×1 | 2·(1,2),(3,2) | ~36 |
| 6 | t7×1+t8×1 | 2·(2,1),(2,3) | ~44 |
| 7 | t8×1+t6×2 | 3·+tâm | ~48 |
| 8 | t8×2 | 3·+tâm | ~54 |
| 9 (Boss) | t8×2+t7×1 | 4·4 góc | ~64 |

3 chương mứt còn lại (dưa hấu/xoài/thơm) dùng cùng khuôn bảng trên, chỉ đổi tên/emoji tier 6-8 và vật cản
theo cột "Vật cản" ở §18.1 — chưa viết ra để tránh lặp lại 4 lần cùng 1 bảng (đúng backlog, xem §18.6).

### 18.3 "Chó giữ trại" — bàn nhiễu (board nhiễu)

Theo đúng mô tả của user: đây là **1 mission bình thường**, không phải cơ chế companion mới. Điểm khác
biệt duy nhất so với các chương khác: **3 chain vật nuôi nhỏ spawn cùng lúc trên 1 bàn**, nhưng chỉ 1 chain
(`guardDog`) tính vào mục tiêu — 2 chain còn lại (`cat`, `mouse`) là "nhiễu": vẫn merge được, vẫn có ích
(gộp hết thì dọn bàn thoáng hơn, thu xu nhỏ), nhưng không xuất hiện trong thanh objective, khiến người chơi
phải nhìn kỹ icon để không lãng phí lượt merge nhầm chain.

| Chain | Tier | Icon theo tier | Vai trò |
|---|---|---|---|
| `guardDog` | 4 | 🐕→🐕‍🦺→🐩→🛡️🐕 (chó chăn trại) | Objective — duy nhất tính điểm |
| `cat` | 2 | 🐱→🐈 | Nhiễu — không tính objective, spawn ít hơn |
| `mouse` | 2 | 🐭→🐀 | Nhiễu — không tính objective, spawn nhiều nhất (tạo cảm giác "phải lọc giữa đống chuột") |

Tỉ lệ spawn đề xuất: `guardDog` 45% / `mouse` 35% / `cat` 20% — đủ nhiễu để phải quan sát nhưng chó vẫn là
chain phổ biến nhất, tránh bế tắc màn.

| Màn | Objectives (chỉ guardDog) | Đá | Ghi chú | moveLimit* |
|---|---|---|---|---|
| 1 | t3(chó choai)×2 | — | Giới thiệu 3 chain, chưa vật cản | ~20 |
| 2 | t3×3 | — | | ~26 |
| 3 | t3×2+t4(chó trưởng thành)×1 | 1·(2,2) | | ~34 |
| 4 | t4×2 | 1·(2,2) | | ~36 |
| 5 | t4×2+t3×1 | 2·(1,2),(3,2) | | ~40 |
| 6 | t4(chó chăn trại)×1+t3×2 | 2·(2,1),(2,3) | | ~44 |
| 7 | t4×2+t3×1 | 3·+tâm | Nhiễu tăng: hạ tỉ lệ guardDog xuống 40% | ~50 |
| 8 | t4×2+t3×2 | 3·+tâm | | ~54 |
| 9 (Boss) | t4×3 "tuyển đủ 3 chó chăn trại" | 4·4 góc | Bàn 6×6, nhiễu tối đa (mouse 40%) | ~66 |

\* ML ở §18 cộng thêm hệ số nhiễu ước lượng +15-20% so với chain đơn (bàn bị chiếm chỗ bởi 2 chain không
tính điểm) — **đây là ước lượng tay thô nhất trong toàn tài liệu, cần sim trước tiên nếu triển khai** vì
chưa từng có tiền lệ đo đạc nhiều-chain-1-bàn trong `sim/simulate.ts`.

### 18.4 "Phiên chợ" — combo nhiều chain, bàn lớn hơn

Trả lời câu hỏi "ghép 2-3 loại khác nhau trong 1 màn hình merge, tăng kích thước ô": khả thi, dùng đúng cơ
chế multi-objective đã có (`LevelConfig.objectives` đã hỗ trợ nhiều dòng), chỉ thêm bàn to hơn để chứa nổi
nhiều chain. Ví dụ "Phiên chợ I" (sau Chương 5-8: táo, mứt táo, dưa hấu, mứt dưa hấu):

| Màn | Bàn | Objectives | moveLimit* |
|---|---|---|---|
| 1 | 7×7 | táo t5×1 + dưa hấu t5×1 | ~30 |
| 2 | 7×7 | mứt táo t6×1 + mứt dưa hấu t6×1 | ~34 |
| 3 | 7×7 | táo t5×2 + dưa hấu t5×1 | ~38 |
| 4 | 7×7 | mứt táo t7×1 + mứt dưa hấu t6×1 | ~42 |
| 5 | 8×8 | táo t5×1 + dưa hấu t5×1 + mứt táo t6×1 | ~50 |
| 6 (Boss) | 8×8 | "Đơn hàng lớn": mứt táo t8×1 + mứt dưa hấu t8×1 + táo t5×1 | ~68 |

3 Phiên chợ còn lại (II: xoài/mứt xoài/thơm/mứt thơm, III: lúa/ngô/heo, IV: gà thịt/chó giữ trại/tổng kết
Hồi 1) dùng cùng khuôn 6 màn trên, đổi objective theo chain tương ứng — chưa viết chi tiết (backlog §18.6).

### 18.5 Bảng cấu trúc Hồi 1 v2 (đầy đủ)

| # | Chương | Trạng thái |
|---|---|---|
| 1 | Trại gà nhỏ | ✓ live |
| 2 | Vườn dừa | ✓ thiết kế xong (§14.2) |
| 3 | Bò sữa | ✓ thiết kế xong (§17.1) |
| 4 | Vườn rau củ | ✓ thiết kế xong (§17.1) |
| 5 | Vườn táo | ⏳ cấu trúc xong (§18.1), chưa viết bảng màn |
| 6 | Mứt táo | ✓ viết đầy đủ (§18.2, mẫu) |
| 7-15 | Dưa hấu, mứt dưa hấu, thanh long, xoài, mứt xoài, thơm, mứt thơm, lúa, ngô | ⏳ cấu trúc xong, backlog bảng màn |
| 16-17 | Trại heo, Trại gà thịt | ⏳ cấu trúc xong, backlog bảng màn |
| 18 | Chó giữ trại | ✓ viết đầy đủ (§18.3) |
| 19 | Phiên chợ I | ✓ viết đầy đủ (§18.4, mẫu) |
| 20-22 | Phiên chợ II-IV | ⏳ cấu trúc xong, backlog bảng màn |

### 18.6 Việc còn lại

- Viết bảng 9 màn đầy đủ (toạ độ vật cản theo khuôn §17.0) cho 13 chương còn "⏳" ở §18.5 — dùng đúng công
  thức/khuôn đã lập, không cần thiết kế lại cấu trúc.
- Thêm `ChainDef` mới vào code (`apple`, `watermelon`, `dragonfruit`, `mango`, `pineapple`, `rice`, `corn`,
  `pork`, `chickenMeat`, `guardDog`, `cat`, `mouse`) — thuần dữ liệu, không đổi engine.
- **Cần trước tiên khi code:** `LevelConfig` phải hỗ trợ nhiều `chains`/spawn-weight trong 1 màn (cho §18.3
  và §18.4) — kiểm tra xem field này đã có sẵn dạng danh sách hay đang giả định 1 chain/màn; nếu chưa, đây
  là thay đổi kiểu dữ liệu nhỏ (mở rộng field, không phải cơ chế mới) cần làm trước khi lên bất kỳ màn nào
  ở §18.3/§18.4.
- Sim toàn bộ Hồi 1 v2 trước Hồi khác vì đây là nơi đầu tiên có nhiều-chain-1-bàn — moveLimit ở §18.3/§18.4
  là ước lượng kém tin cậy nhất trong tài liệu.

---

## 19. Hồi 1 — NPC, Script & Board đầy đủ

Hồi 1 giờ có 22 chương/8 cụm nội dung (§18) — 1 NPC duy nhất (Ông Tư) không đủ sức "gánh" toàn bộ Hồi như
mô hình cũ (§11: 1 NPC/Hồi). Mở rộng thành **4 NPC trong Hồi 1**, mỗi người phụ trách 1 cụm chương, đúng quy
mô mới. Không phá nguyên tắc tuyển tập (§1) — cả 4 vẫn chỉ tồn tại trong khung Hồi 1, không NPC nào cần
biết trước nội dung Hồi khác.

### 19.0 Bảng NPC Hồi 1

| NPC | Vai trò | Gắn với chương | Giọng điệu | Xuất hiện lần đầu |
|---|---|---|---|---|
| **Ông Tư** | Hàng xóm lâu năm, biết đất của Bà Năm, đầu mối "Chợ" chung cho toàn Hồi | Mở đầu Hồi 1, Chương 1, 3, 4, 14, 15 | Điềm đạm, chân chất, hay ví von thành ngữ | Trước Chương 1 |
| **Chú Bảy** | Bạn già của Ông Tư, "biết tay" cây cối, chuyên vườn cây ăn trái | Chương 2, 5-13 (toàn bộ cụm trái cây + mứt) | Vui tính, đam mê, hay so sánh cây với người | Chương 2 |
| **Bé Na** | Cháu ngoại Ông Tư, học lớp 5, mê động vật | Chương 16-18 (heo, gà thịt, chó giữ trại) | Hồn nhiên, năng lượng cao, hay hỏi "tại sao" | Chương 16 |
| **Dì Sáu** | Chủ sạp chợ huyện, thương lái quen Bà Năm ngày trước | Chương 19-22 (toàn bộ cụm Phiên chợ) | Lanh lợi, thực tế nhưng ấm áp | Chương 19 |

### 19.1 Script — Mở đầu Hồi 1 (trước Chương 1 "Trại gà nhỏ")

> Sân nông trại bỏ hoang, sáng sớm.

**MAI** *(nội tâm)*: Nhà cũ của bà... lâu rồi mình mới về.
*(Mai mở cửa chuồng gà, thấy cỏ mọc um tùm, vài con gà đi lạc)*
**ÔNG TƯ** *(từ hàng rào)*: Ơ, cháu bà Năm đây hả? Về từ hôm nào vậy con?
**MAI**: Dạ con mới về sáng nay chú Tư. Con... con định dọn lại ít bữa rồi tính sau.
**ÔNG TƯ** *(cười)*: Tính sau là tính gì, đất này bà Năm cực khổ gầy dựng cả đời. Để chú chỉ con vài đường,
gà vịt với đất đai không khó như con nghĩ đâu.
**MAI** *(cầm cuốn sổ tay cũ của bà Năm lên)*: Con thấy trong này bà ghi mấy công thức... con chưa hiểu hết.
**ÔNG TƯ**: Từ từ rồi hiểu. Bắt đầu từ đàn gà trước đi, cái gì cũng phải có cái đầu tiên.

`→ mở khoá Chương 1 "Trại gà nhỏ"`

### 19.2 Script — Chương 2 "Vườn dừa": giới thiệu Chú Bảy

> Góc vườn phía sau nhà, hàng dừa già cỗi.

**ÔNG TƯ**: Đám dừa này bỏ lâu quá rồi, để chú kêu ông Bảy qua coi giùm, ổng rành cây cối hơn chú.
*(Chú Bảy xuất hiện, đội nón lá, tay cầm cái cuốc)*
**CHÚ BẢY**: Trời đất, dừa nhà bà Năm mà để vầy nè! Để chú coi... *(sờ vào gốc cây)* Còn sống, còn cứu được.
**MAI**: Chú ơi con phải làm sao để nó ra trái lại ạ?
**CHÚ BẢY** *(cười lớn)*: Từ từ con ơi, cây cối cũng như người, phải nuôi từ hạt, lớn từng chút một. Con
gieo hạt đi, chú chỉ từng bước.

`→ mở khoá Chương 2 "Vườn dừa"`

### 19.3 Script — Chương 16 mở đầu: giới thiệu Bé Na

> Sân nhà, chiều muộn, sau khi Mai đã có bò sữa + rau củ + vườn cây ăn trái ổn định.

*(Một bé gái chạy ùa vào sân, theo sau là Ông Tư)*
**BÉ NA**: Chị ơi chị ơi, ông nội nói chị nuôi bò với trồng cây giỏi lắm, chị nuôi heo được không?
**MAI** *(cười)*: Ủa bé này là...?
**ÔNG TƯ**: Cháu ngoại chú, con Na. Nó mê con vật lắm, cứ đòi qua đây coi hoài.
**BÉ NA**: Con biết nuôi heo nè! Con phụ chị được không?
**MAI**: Được chứ, vậy em chỉ chị nuôi heo với gà thịt nha.
**BÉ NA** *(hào hứng)*: Dạ! Mà chị ơi... nhà mình có nuôi chó không? Con thấy nhà ai cũng có chó giữ, nhà
chị chưa có.
**MAI** *(nhìn quanh sân trống)*: Ừa ha... để chị tính.

`→ mở khoá Chương 16-17 "Trại heo" / "Trại gà thịt"`

### 19.4 Script — Chương 18 "Chó giữ trại" (đầy đủ mission)

**Intro (trước màn 1):**
**BÉ NA**: Chị ơi con nghe nói chợ huyện có bầy chó con mới đẻ, có cả mèo với chuột hoang chạy lộn xộn
trong đó luôn, lựa muốn mệt!
**MAI**: Lộn xộn vậy sao lựa được chó?
**BÉ NA**: Thì phải nhìn kỹ chứ chị! Con mèo với con chuột nó cũng dễ thương, nhưng nhà mình cần chó giữ,
không phải mèo với chuột.
**MAI** *(nội tâm)*: Vậy là phải merge cẩn thận, đừng để lẫn lộn.

`→ Màn 1-2: giới thiệu 3 chain, chưa vật cản`

**Giữa mission (trước màn 6, sau khi có "chó trưởng thành" đầu tiên):**
**BÉ NA**: Chị ơi nó lớn rồi nè, sắp thành chó chăn trại chưa?
**MAI**: Sắp rồi, còn phải gộp thêm chút nữa.
**BÉ NA**: Con đặt tên nó là Mực được không chị?
**MAI** *(cười)*: Được, để coi Mực có giữ nhà giỏi không.

`→ Màn 7-8: nhiễu tăng, tỉ lệ guardDog giảm còn 40%`

**Boss (màn 9 "tuyển đủ 3 chó chăn trại"):**
**BÉ NA**: Ông nội nói nhà nông trại lớn phải có ít nhất 3 con mới giữ xuể hết mấy khu vườn với chuồng
trại.
**MAI**: Ba con luôn hả? Vậy chị ráng gộp cho đủ.
*(Hoàn thành màn)*
**BÉ NA** *(ôm chầm lấy 1 "chó chăn trại")*: Mực ơi mày giỏi quá! Từ nay khu vườn với chuồng heo hết bị
chuột phá rồi!
**ÔNG TƯ** *(đi ngang, gật gù)*: Vậy là đủ bộ rồi đó, gà vịt, heo bò, cây trái, giờ có thêm chó giữ nhà.
Nông trại bà Năm sống lại thiệt rồi con.

`→ mở khoá Chương 19 "Phiên chợ I"`

### 19.5 Script — Chương 19 "Phiên chợ I": giới thiệu Dì Sáu

> Cổng chợ huyện, sáng sớm, Mai chở theo mấy giỏ táo/dưa hấu/mứt.

**DÌ SÁU** *(từ sạp hàng)*: Ơ, đồ nhà bà Năm hả con? Lâu quá không thấy ai đem đồ nhà đó ra chợ.
**MAI**: Dạ, con là cháu bà. Con mới làm lại nông trại, đem ít trái cây với mứt ra thử bán ạ.
**DÌ SÁU** *(cầm thử 1 hũ mứt táo)*: Ngon nè! Bà Năm hồi xưa cũng hay làm mứt kiểu này, y chang luôn. Thôi
vầy đi, con gom đủ 1 đợt hàng lớn, dì lấy giá tốt cho, khách chợ huyện thích đồ nhà làm lắm.
**MAI**: Dạ, đợt lớn là sao ạ?
**DÌ SÁU**: Là gom vài loại cùng lúc đó — táo, dưa hấu, với mứt luôn, đóng combo bán chạy hơn bán lẻ.

`→ mở khoá Chương 19 "Phiên chợ I"`

### 19.6 Script — Kết Hồi 1 (sau Chương 22 "Phiên chợ IV")

> Sân nông trại, buổi tối, Mai ngồi xem lại sổ tay bà Năm, nông trại giờ đã đầy đủ: gà, dừa, bò, rau, vườn
> cây trái, heo, chó giữ.

**MAI** *(nội tâm)*: Vậy là xong... nông trại giờ đâu ra đó rồi. Bà ơi, con làm được rồi nè.
*(Dì Sáu ghé ngang, mang theo 1 giỏ hàng trống)*
**DÌ SÁU**: Con ơi, dạo này đồ nhà con bán chạy dữ lắm nha. Có khách hỏi con có làm món ăn sẵn không, kiểu
như bán đồ chế biến luôn á, chứ không chỉ nguyên liệu thô.
**MAI**: Món ăn sẵn... như là nấu luôn hả dì?
**DÌ SÁU**: Ừ đó, con nấu ngon vậy mà chỉ bán nguyên liệu thì uổng. Con thử làm vài món Việt coi, biết đâu
lại "bắt tay" được.
**ÔNG TƯ** *(gật gù)*: Bà Năm hồi xưa cũng nấu ngon lắm, cháu chắc cũng có máu đó.
**MAI** *(mỉm cười, gấp sổ tay lại)*: Vậy con thử nha.

`→ mở khoá Hồi 2 "Ẩm thực Việt Nam"`

### 19.7 Lời thoại ngắn — các chương còn lại (onChapterEnter)

Không phải chương nào cũng cần 1 cảnh đầy đủ — 15 chương còn lại dùng 1 câu thoại ngắn đúng giọng NPC phụ
trách, đủ để Hồi 1 có thoại xuyên suốt 22 chương mà không lặp cấu trúc cảnh 6 lần:

| # | Chương | NPC | Lời thoại (onChapterEnter) |
|---|---|---|---|
| 3 | Bò sữa | Ông Tư | "Bò nhà bà Năm hiền lắm, con cứ vắt sữa từ từ, đừng vội." |
| 4 | Vườn rau củ | Ông Tư | "Rau củ dễ trồng nhất đó con, coi như màn nghỉ sau vụ dừa." |
| 5 | Vườn táo | Chú Bảy | "Táo này giống bà Năm trồng hồi xưa, ngọt lắm nghen." |
| 6 | Mứt táo | Chú Bảy | "Táo hái rồi đừng để hư, làm mứt liền cho thơm nhà." |
| 7 | Ruộng dưa hấu | Chú Bảy | "Dưa hấu chịu nắng tốt, mùa này trồng là vừa." |
| 8 | Mứt dưa hấu | Chú Bảy | "Ai đời làm mứt dưa hấu, để chú chỉ con cách, ngon bất ngờ đó." |
| 9 | Vườn thanh long | Chú Bảy | "Thanh long leo cọc, coi vậy mà chăm công phu lắm." |
| 10 | Vườn xoài | Chú Bảy | "Xoài nhà bà Năm nổi tiếng cả xóm, ráng giữ giống nghen con." |
| 11 | Mứt xoài | Chú Bảy | "Mứt xoài dẻo dẻo, con nít mê lắm à nha." |
| 12 | Vườn thơm | Chú Bảy | "Thơm chín để lâu là hư liền, hái tới đâu gọn tới đó." |
| 13 | Mứt thơm | Chú Bảy | "Coi như xong hết vụ cây trái rồi đó con, giỏi lắm." |
| 14 | Ruộng lúa | Ông Tư | "Lúa là gốc đó con, có lúa mới tính chuyện khác được." |
| 15 | Ruộng ngô | Ông Tư | "Ngô dễ trồng, để dành nuôi gà nuôi heo cũng được." |
| 17 | Trại gà thịt | Bé Na | "Gà thịt khác gà đẻ trứng đó chị, con biết phân biệt nè!" |
| 20 | Phiên chợ II | Dì Sáu | "Đợt này gom xoài với thơm nha con, khách chợ đang hỏi dữ lắm." |
| 21 | Phiên chợ III | Dì Sáu | "Lúa với ngô con để dành nuôi heo cũng được, dư thì đem ra đây dì bán giùm." |

### 19.8 Board — sơ đồ puzzle 3 màn tiêu biểu

Dùng đúng khuôn toạ độ §17.0. 2 board đầu có vật cản cố định (Đá); board Phiên chợ không có vật cản
(nguyên tắc §18.0) nên chỉ minh hoạ mật độ/đa dạng spawn, không phải toạ độ cố định.

**Mứt táo — Boss (màn 9, 5×5, 4 Đá góc + 1 giữa):**

```
🪨 ·  ·  ·  🪨
·  ·  ·  ·  ·
·  ·  🪨 ·  ·
·  ·  ·  ·  ·
🪨 ·  ·  ·  🪨
```

**Chó giữ trại — Boss (màn 9, 6×6, 4 Đá góc cố định + nhiễu mèo/chuột/chó rải ngẫu nhiên):**

```
🪨 ·  ·  ·  ·  🪨
·  🐀 ·  🐱 ·  ·
·  ·  🐕 ·  🐀 ·
·  🐱 ·  🐕 ·  ·
·  ·  🐀 ·  🐱 ·
🪨 ·  ·  ·  ·  🪨
```
*(1 khung hình minh hoạ giữa ván — vị trí mèo 🐱/chuột 🐀/chó 🐕 ngẫu nhiên theo tỉ lệ spawn ở §18.3, chỉ 4
ô Đá góc là cố định)*

**Phiên chợ I — Boss (màn 6, 8×8, không vật cản, 3 chain trộn ngẫu nhiên toàn bàn):**

```
🍎 ·  🍉 ·  🍯 ·  🍎 ·
·  🍯 ·  🍎 ·  🍉 ·  🍯
🍉 ·  🍎 ·  🍉 ·  🍯 ·
·  🍎 ·  🍯 ·  🍎 ·  🍉
🍯 ·  🍉 ·  🍎 ·  🍯 ·
·  🍉 ·  🍯 ·  🍉 ·  🍎
🍎 ·  🍯 ·  🍉 ·  🍎 ·
·  🍯 ·  🍎 ·  🍯 ·  🍉
```
*(1 khung hình mẫu ngẫu nhiên — bàn lớn hơn chỉ để chứa đủ 3 loại tile spawn cùng lúc, không có vùng cố
định theo chain, đúng cách tính spawn-weight board-wide đã dùng ở Chó giữ trại)*
