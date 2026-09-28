# Story Concept — Phương án bối cảnh Việt Nam cho toàn bộ game *(đã thay thế)*

> ⚠️ **Đã thay thế (2026-09-28).** User chọn thiết kế lại cốt truyện từ đầu thay vì chọn 1 trong 4 phương án
> dưới đây — xem [docs/GAME_DESIGN_ACTS.md](./GAME_DESIGN_ACTS.md) §1 ("cô gái thành thị thừa hưởng nông
> trại"). Giữ file này lại để tham khảo (phần nghiên cứu văn hoá — Con Rồng cháu Tiên, 32 di sản ẩm thực
> quốc gia, hội quán Hội An — vẫn có thể hữu ích sau này nếu muốn thêm chi tiết văn hoá vào bản mới), nhưng
> **không còn là tài liệu để quyết định theo nữa**.

## 0. Khung đánh giá

4 phương án dưới đây đều phải thoả 2 ràng buộc:

1. **Không đụng `core/`** — chỉ đổ nội dung vào 2 field đã thiết kế sẵn ở `GAME_DESIGN.md §12.1`
   (`NpcLines.onWorldEnter`/`onWorldComplete`) cộng data mới thuần tuý (NPC, decor).
2. **Cấu trúc tuyển tập, không mạch nối tiếp** — bản đầu tiên của tài liệu này để mỗi Vùng "nhắc tên" Vùng
   kế tiếp (kiểu Chú Sáu kể có Dì Ba ở miệt vườn...). Vấn đề: nếu 1 Vùng bị trì hoãn, đổi thứ tự sản xuất,
   hoặc tư liệu/nội dung cho Vùng đó yếu hơn dự kiến, mọi Vùng phía trước nó (đã nhắc tên) bị treo — nhắc tới
   1 người/nơi mà nội dung chưa tồn tại. Cả 4 phương án dưới đây **đã sửa lại theo hướng modular**: mỗi Vùng
   chỉ liên hệ với **khung chung** (sổ tay/gia phả/hồ sơ/token — tuỳ phương án), không liên hệ với Vùng khác.
   Thêm, bớt, đổi thứ tự, hay để 1 Vùng "yếu" nằm im chưa làm đều không ảnh hưởng phần còn lại — đây là ràng
   buộc bắt buộc cho *cả 4* phương án, không phải điểm khác biệt để so sánh.

Khác nhau giữa 4 phương án chỉ còn ở **khung ý nghĩa** bọc quanh 5 Vùng đã có, không phải cấu trúc kỹ thuật.

So sánh theo 5 tiêu chí:

| Tiêu chí | Ý nghĩa |
|---|---|
| **Kéo dài vô hạn** | Vùng 6 Tết + Vùng 7+ (GAME_DESIGN.md §2.1) có "chỗ đứng" tự nhiên trong truyện không, hay mỗi lần thêm Vùng phải nghĩ lại lý do? |
| **Chi phí thêm** | Có cần đổi 5 NPC đã đặt tên ở §12.1 không, hay chỉ cần diễn giải lại vai trò của họ? |
| **Rủi ro văn hoá** | Có động vào huyền thoại/tín ngưỡng/lịch sử thật cần cẩn trọng khi dùng cho giải trí không? |
| **Hợp thể loại casual** | Có đòi hỏi đọc nhiều/nhớ nhiều nhân vật không, hay vẫn "lướt qua được" như merge game bình thường? |
| **Khớp Vùng 6 (Tết)** | Có tự nhiên nối được vào Tết — vốn đã là sự kiện riêng theo §2.1 — hay phải gượng ép? |

---

## 1. Phương án A — "Sổ tay của Bà Năm" (hoài niệm gia đình)

*Đã viết đầy đủ ở `GAME_DESIGN.md §13` hiện tại — tóm tắt lại đây để so sánh cùng khung với B/C/D.*

**Tiền đề:** Bà Năm (NPC Vùng 1 có sẵn) hồi trẻ đi khắp ba miền học nghề, quen 1 người bạn mỗi vùng, rồi
dừng lại mở quán nhỏ nuôi cháu. Sổ tay cũ của bà ghi công thức + tên bạn bè nhưng bỏ dở. Cháu (người chơi)
tiếp tục hành trình thay bà.

**Kết nối (modular):** sổ của Bà Năm đã ghi sẵn tên + địa danh cả 4 người kia từ Vùng 1 — Chú Sáu (Hội An),
Dì Ba (miệt vườn), Anh Hải (biển đảo), Ông Bảy (cao nguyên) đều chỉ nói về đúng trang của mình, không ai
nhắc tới người khác — xem bảng đầy đủ đã sửa ở `GAME_DESIGN.md §13.2`.

**Mốc kết v1.0:** Khai trương farm-decor "Quán Ba Miền". Sổ còn trang trống → cớ cho Vùng 6/7+.

| Tiêu chí | Đánh giá |
|---|---|
| Kéo dài vô hạn | Tốt — "sổ chưa đầy" là lý do mở vô hạn, không cần twist |
| Chi phí thêm | Thấp nhất — dùng nguyên 5 NPC đã có, không thêm ai |
| Rủi ro văn hoá | Không — thuần hư cấu cá nhân, không động chạm gì có thật |
| Hợp thể loại casual | Rất hợp — ấm áp, nhẹ, không cần nhớ chi tiết |
| Khớp Vùng 6 (Tết) | Tự nhiên — "Tết là dịp cả nhà mở sổ ra xem lại" |

**Rủi ro duy nhất:** khá "an toàn"/chung chung — không có gì đặc trưng riêng cho bối cảnh Việt Nam ngoài các
món ăn (một câu chuyện bà-cháu-sổ-tay có thể đặt ở bất kỳ nước nào), nên nếu muốn bản sắc rõ hơn thì cần B.

---

## 2. Phương án B — "Con Rồng Cháu Tiên" (huyền thoại Bách Việt)

**Nghiên cứu nền:** dựa trên truyền thuyết **Con Rồng cháu Tiên** — Lạc Long Quân (giống Rồng, dưới biển)
kết duyên Âu Cơ (giống Tiên, trên núi), sinh bọc trăm trứng nở trăm con; 50 con theo cha xuống biển, 50 con
theo mẹ lên núi, người con trưởng lập nước Văn Lang, xưng Hùng Vương ([Wikipedia tiếng Việt][1]). Ghép thêm
truyền thuyết **bánh chưng bánh giầy**: Lang Liêu — con thứ 18 của Hùng Vương, nhà nghèo, được thần báo mộng
"không gì quý hơn gạo" — làm bánh giầy tròn (tượng Trời) và bánh chưng vuông (tượng Đất) dâng vua, được
truyền ngôi vì lễ vật giản dị mà ý nghĩa nhất, chứ không phải vì châu báu quý hiếm của các anh em
([Wikisource][2], [Wikipedia tiếng Việt][3]).

**Tiền đề:** Xưa kia, dòng dõi trăm con Lạc Hồng tản đi trăm ngả — có người xuống biển, có người lên núi,
mỗi nhánh mang theo 1 nghề/1 món ăn tổ truyền nhưng dần quên gốc gác. Người chơi (không cần là "hậu duệ" cụ
thể nào, chỉ là 1 người trẻ được 1 cụ từ giữ đền làng nhờ việc) đi tìm lại từng nhánh, ghi vào 1 "gia phả ẩm
thực" — mỗi Vùng là 1 nhánh con cháu, mỗi món ăn phục dựng là 1 mảnh ký ức nối lại. Framing **giữ nguyên 5
NPC đã có** — chỉ thêm đúng 1 nhân vật phụ, xuất hiện ngắn ở đầu/cuối game (không có Vùng riêng, không tốn
thêm ô nhớ): "Cụ Từ" giữ đền làng, người duy nhất còn nhớ mảnh truyền thuyết này.

**Kết nối (modular):** khác Phương án A, khung "trăm nhánh" không cần từng NPC nhắc nhau — chỉ **Cụ Từ** biết
và kể toàn bộ khung này, đúng 2 lần (mở đầu game ở Vùng 1, và ở mốc kết Vùng 5), còn 5 NPC vùng chỉ nói về
đúng món/nhánh của mình, không ai biết hay nhắc tới nhánh khác (họ cũng quên gốc gác — đúng tiền đề). Vì vậy
độc lập tuyệt đối giữa các Vùng, kể cả hơn Phương án A (A vẫn có Bà Năm "biết trước" tên cả 4 người kia; ở
đây ngay cả 5 NPC cũng không biết về nhau, chỉ Cụ Từ — 1 nhân vật phụ không gắn Vùng nào — mới nối được):

| Vùng | NPC | Vai trò trong khung Bách Việt (chỉ Cụ Từ biết, NPC không tự nhận) |
|---|---|---|
| 1 | Bà Năm | Giữ 1 món cúng gia truyền — Cụ Từ (không phải Bà Năm) nhận ra nó giống lời tích xưa |
| 2 | Chú Sáu | Món ở Hội An — không biết gì về khung Bách Việt, chỉ dạy đúng món của mình |
| 3 | Dì Ba | Món miệt vườn — độc lập tương tự |
| 4 | Anh Hải | Món biển đảo — độc lập tương tự |
| 5 | Ông Bảy | Món cao nguyên — độc lập tương tự |

**Mốc kết v1.0:** Quay lại Cụ Từ ở đền làng (Vùng 1) — cụ xác nhận: đúng là "trăm nhánh" như tích xưa, và
**trăm mới chỉ là 5**. "Quán Ba Miền" (giống Phương án A) giờ mang thêm ý nghĩa: nơi trưng "gia phả ẩm thực"
đang ghép dần. Số 100 trong tích gốc là lý do trong-truyện rất tự nhiên cho việc **còn rất nhiều nhánh/Vùng
chưa tìm ra** — mạnh hơn "trang sổ trống" của Phương án A vì có 1 con số cụ thể, mang tính biểu tượng dân
tộc sẵn có thay vì tự bịa.

| Tiêu chí | Đánh giá |
|---|---|
| Kéo dài vô hạn | Rất tốt — "100 nhánh" là khung mở vô hạn có sẵn trong văn hoá, không cần bịa số |
| Chi phí thêm | Thấp — vẫn 5 NPC cũ, chỉ thêm 1 nhân vật phụ không cần Vùng riêng |
| Rủi ro văn hoá | **Trung bình** — đây là truyền thuyết lập quốc, mang tính thiêng liêng với nhiều người Việt; cần giữ giọng **trân trọng, không hài hước hoá, không tự ý "diễn giải lại" cốt truyện gốc** — game chỉ mượn khung "trăm nhánh tản đi" làm ẩn dụ, không kể lại/thay đổi chính truyền thuyết trong game |
| Hợp thể loại casual | Được — chỉ cần 1-2 câu nhắc mỗi Vùng, không cần kể lại cả tích |
| Khớp Vùng 6 (Tết) | Rất khớp — bánh chưng/bánh giầy **chính là** món của Lang Liêu, Vùng 6 gần như tự kể tiếp phần 2 của cùng 1 truyền thuyết đã dùng ở B |

**Rủi ro cần cân nhắc kỹp:** vì đụng tới huyền thoại khai quốc, nên nếu chọn B, khuyến nghị **chỉ ẩn dụ**
(gợi nhắc, không dựng lại đối thoại của Lạc Long Quân/Âu Cơ/Hùng Vương như nhân vật trong game) — an toàn
hơn nhiều so với biến các nhân vật huyền sử thành NPC trực tiếp.

---

## 3. Phương án C — "Hồ Sơ Di Sản" (hành trình ghi danh ẩm thực, hiện đại)

**Nghiên cứu nền:** tính đến 2025, Việt Nam có **32 di sản văn hoá phi vật thể cấp quốc gia** liên quan ẩm
thực — trong đó Phở Hà Nội được công nhận ngày 9/8/2024, cùng Phở Nam Định, Mì Quảng, nghề làm nem Lai Vung
đầu 2024, v.v. ([VietnamPlus][4], [Báo Hà Tĩnh][5]). Ẩm thực Việt Nam **chưa** được UNESCO công nhận trực
tiếp — chỉ ở cấp quốc gia — nên game **không nên nói "được UNESCO công nhận"** (sai sự thật), chỉ nên dùng
đúng khái niệm "Di sản Văn hoá Phi vật thể Quốc gia".

**Tiền đề:** Bối cảnh hiện đại, không hoài niệm quá khứ mà hướng tới **giữ cho tương lai**: mỗi Vùng có 1
nghệ nhân/chủ quán (vẫn đúng 5 NPC cũ) đang tự làm hồ sơ xin công nhận Di sản Văn hoá Phi vật thể Quốc gia
cho món của họ, nhưng thiếu người ghi chép/chuẩn hoá công thức đúng cách (chính là việc người chơi làm khi
chơi qua các màn — mỗi Chương nấu xong = 1 phần hồ sơ hoàn thiện). Người chơi có thể là người trẻ về quê
(giữ tương thích với Phương án A) hoặc 1 nhân vật mới làm "trợ lý ghi danh di sản" — tuỳ chọn.

**Kết nối (modular):** đây là phương án độc lập nhất trong 4 phương án — mỗi NPC tự làm hồ sơ của riêng
mình, không ai biết/nhắc tới NPC vùng khác, không cần khung chung kiểu sổ tay/gia phả để giữ mạch. Bù lại 1
dòng tiến độ chung ở HomeScreen kiểu "3/5 hồ sơ đã hoàn thiện" (thuần UI, không cần state mới ngoài đếm số
Chương đã `cooked`) để người chơi vẫn thấy có 1 "dự án chung" đang ghép dần, dù các phần không liên hệ nhau.

**Mốc kết v1.0:** Cả 5 hồ sơ hoàn thiện → "Quán Ba Miền" đổi vai trò thành **phòng trưng bày di sản** thay
vì quán ăn gia đình. Mở rộng về sau (Vùng 6/7+) có lý do rất thật: "còn 27 di sản quốc gia về ẩm thực khác
chưa ai ghi lại đủ" — con số 32 đã liệt kê là nguồn đề tài thật, kiểm chứng được, không cần bịa.

| Tiêu chí | Đánh giá |
|---|---|
| Kéo dài vô hạn | Tốt — có danh sách 32 di sản thật làm "kho đề tài", cần cập nhật khi có danh sách mới qua từng năm |
| Chi phí thêm | Thấp — vẫn 5 NPC cũ, không cần nhân vật phụ |
| Rủi ro văn hoá | Thấp, **nhưng cần chính xác** — phải dùng đúng thuật ngữ "Di sản Văn hoá Phi vật thể Quốc gia", không nói nhầm thành UNESCO, và nên cập nhật lại danh sách nếu có công nhận mới trước khi code |
| Hợp thể loại casual | Được, nhưng **kém ấm áp hơn A/B** — thiên về "nhiệm vụ hành chính" (hồ sơ) hơn là cảm xúc gia đình |
| Khớp Vùng 6 (Tết) | Trung bình — cần thêm lý do vì sao Tết cũng "xin công nhận di sản" được (có thể: phong tục Tết chưa nằm trong 32 di sản kể trên, phải tự bịa lý do, kém chặt hơn A/B) |

---

## 4. Phương án D — "Hội Quán Ba Miền" (mạng lưới thương hội di sản)

**Nghiên cứu nền:** lấy cảm hứng từ **hội quán** có thật ở phố cổ Hội An — nơi các bang hội thương nhân Hoa
kiều (định cư từ thế kỷ 17 tại thương cảng Hội An/Faifo, di sản UNESCO từ 1999) dựng lên làm trung tâm sinh
hoạt cộng đồng, tín ngưỡng và kết nối buôn bán giữa các thương nhân xa quê ([Hoianheritage.net][6],
[Wikipedia tiếng Việt][7]). Đây là **cảm hứng, không phải tái hiện lịch sử chính xác** — game hư cấu thêm 1
mạng lưới hội quán tưởng tượng trải khắp 5 vùng (thực tế hội quán lịch sử tập trung ở Hội An, không có ở cả
5 miền), nên cần nói rõ trong game đây là chi tiết hư cấu lấy cảm hứng dân gian, không phải sự kiện lịch sử
xác thực.

**Tiền đề:** Ngày xưa có 1 "Hội Buôn Ba Miền" — mạng lưới hội quán nhỏ dọc các vùng miền, chuyên trao đổi
đặc sản/công thức giữa các thương nhân. Hội tan rã đã lâu, chỉ còn 5 người giữ được 1 hội quán/mối quen mỗi
vùng (đúng 5 NPC cũ, đổi vai từ "bạn bè" thành "hậu duệ các hội quán"). Người chơi được giao 1 vật tín (thẻ
bài/con dấu hội) để đi "nối lại" từng hội quán.

**Kết nối (modular):** vật tín (token, 1 cái/hội quán) thay cho sổ tay làm biểu tượng xuyên suốt — người giữ
mỗi hội quán chỉ biết đúng hội quán của mình, không biết/nhắc tới hội quán khác (hội đã tan rã lâu, họ không
còn liên lạc với nhau). Cái nối duy nhất là **con dấu/vật tín ban đầu** người chơi được giao ở Vùng 1 — cứ
mang tới đúng địa danh nào có dấu tích hội quán cũ (do gameplay/HomeScreen dẫn tới, không phải NPC trước chỉ
đường) là nhận thêm 1 token. Token sưu tập được lên hình 1 trang farm-decor riêng ("bộ token hội quán") song
song cookbook.

**Mốc kết v1.0:** "Quán Ba Miền" trở thành hội quán trung tâm phục dựng — nơi trưng bộ token đủ 5 vùng. Mở
rộng về sau: hội quán vốn có "chi nhánh khắp nơi", lý do mở Vùng mới rất tự nhiên ("còn hội quán X chưa tìm
lại được") — tương đương độ mở của A, kém tính biểu tượng dân tộc so với B.

| Tiêu chí | Đánh giá |
|---|---|
| Kéo dài vô hạn | Tốt — "hội quán còn chi nhánh khác" tương đương độ mở của A |
| Chi phí thêm | Thấp — 5 NPC cũ, đổi vai không đổi tên |
| Rủi ro văn hoá | Thấp — miễn nói rõ đây là hư cấu lấy cảm hứng, không nhận là lịch sử thật của cả 5 vùng |
| Hợp thể loại casual | Được — thêm 1 món sưu tập (token) hợp genre merge/collector, nhưng là **tính năng UI thêm**, không miễn phí như A/B |
| Khớp Vùng 6 (Tết) | Trung bình — hội quán thường mở hội vào dịp Tết cũng hợp lý, nhưng không "sẵn có" bằng B |

---

## 5. Bảng so sánh nhanh

| | A — Sổ tay Bà Năm | B — Con Rồng Cháu Tiên | C — Hồ Sơ Di Sản | D — Hội Quán Ba Miền |
|---|---|---|---|---|
| Kéo dài vô hạn | Tốt | **Rất tốt** (số "100" có sẵn) | Tốt (32 di sản thật) | Tốt |
| Chi phí thêm | **Thấp nhất** | Thấp (+1 nhân vật phụ) | Thấp nhất | Thấp |
| Rủi ro văn hoá | Không | **Trung bình — cần cẩn trọng giọng kể** | Thấp (cần chính xác thuật ngữ) | Thấp (cần ghi rõ hư cấu) |
| Bản sắc riêng cho bối cảnh VN | Trung bình | **Cao nhất** | Cao (thời sự, thật) | Cao |
| Hợp casual | **Rất hợp** | Hợp | Hợp, kém ấm hơn | Hợp |
| Khớp sẵn Vùng 6 Tết | Tự nhiên | **Rất tự nhiên** (cùng 1 tích) | Gượng | Trung bình |

## 6. Đề xuất

**Không nhất thiết chọn 1 duy nhất** — A và B ghép được với nhau mà không mâu thuẫn: giữ nguyên toàn bộ nội
dung Phương án A (đã viết ở `GAME_DESIGN.md §13`, ấm áp, chi phí thấp, an toàn) làm **lớp cảm xúc chính**,
và thêm **đúng 2 điểm chạm** từ Phương án B làm lớp ý nghĩa sâu hơn phía sau mà không đổi bất kỳ dòng nào đã
viết:

1. Cụ Từ giữ đền (nhân vật phụ, chỉ xuất hiện 1 lần ở Vùng 1 và 1 lần ở mốc kết Vùng 5) — gợi ý cuốn sổ của
   bà Năm nhắc bà cụ của bà từng nói "chắc nhà mình cũng là 1 trong trăm nhánh" — nói mờ, không khẳng định,
   không dựng lại truyền thuyết như một cảnh trong game.
2. Đổi 1 câu ở mốc kết Vùng 5 (§13.3): thay vì chỉ "chắc còn ai đó bà quên mất tên", thêm "trăm nhánh mà mới
   tìm được 5, còn xa lắm cháu ơi" — cho khung mở rộng 1 con số biểu tượng thay vì mơ hồ.

Cách này giữ được toàn bộ công đã viết ở §13, thêm đúng 2 chỗ để có bản sắc bối cảnh Việt Nam rõ hơn (đúng
yêu cầu "toàn diện" lần này), và vẫn rẻ nhất trong 4 phương án — không cần quyết định lại NPC, không cần
tính năng UI mới như token ở Phương án D, không cần cập nhật danh sách di sản quốc gia mỗi năm như Phương
án C.

Nếu muốn bản sắc mạnh hơn nữa (đánh đổi lấy rủi ro giọng kể phải cẩn trọng hơn), chọn thẳng Phương án B làm
khung chính. Nếu muốn nội dung gắn với thời sự/có thể quảng bá là "lấy cảm hứng từ di sản quốc gia thật",
chọn Phương án C. Phương án D hợp nếu về sau muốn thêm 1 hệ thống sưu tập mới (token) cho farm.

## 7. Việc cần làm tiếp (sau khi chọn)

1. Xác nhận chọn A đơn thuần / A+B lai / B / C / D.
2. Cập nhật `GAME_DESIGN.md §13` theo đúng phương án chọn (giữ cấu trúc bảng `onWorldEnter`/`onWorldComplete`
   đã có, chỉ đổi nội dung câu chữ).
3. Xoá/rút gọn file này sau khi đã chốt, đúng quy ước "khi chốt thì dời khỏi tài liệu để ngỏ".
4. Nếu chọn phương án có Cụ Từ/nhân vật phụ (B) hoặc token (D): thêm đúng phần data cần ở §13.5 tương ứng.

---

### Nguồn tham khảo

- [1] [Con Rồng cháu Tiên – Wikipedia tiếng Việt](https://vi.wikipedia.org/wiki/Con_R%E1%BB%93ng_ch%C3%A1u_Ti%C3%AAn)
- [2] [Sự tích bánh chưng bánh giầy – Wikisource tiếng Việt](https://vi.wikisource.org/wiki/S%E1%BB%B1_t%C3%ADch_b%C3%A1nh_ch%C6%B0ng_b%C3%A1nh_gi%E1%BA%A7y)
- [3] [Lang Liêu – Wikipedia tiếng Việt](https://vi.wikipedia.org/wiki/Lang_Li%C3%AAu)
- [4] [Tìm hiểu về 32 Di sản Phi vật thể Quốc gia liên quan đến ẩm thực của Việt Nam – VietnamPlus](https://www.vietnamplus.vn/tim-hieu-ve-32-di-san-phi-vat-the-quoc-gia-lien-quan-den-am-thuc-cua-viet-nam-post971858.vnp)
- [5] [Toàn bộ 32 di sản phi vật thể Quốc gia về ẩm thực Việt Nam – Báo Hà Tĩnh](https://baohatinh.vn/toan-bo-32-di-san-phi-vat-the-quoc-gia-ve-am-thuc-viet-nam-post274765.html)
- [6] [Kiến trúc cổ các hội quán của người Hoa ở Hội An (Quảng Nam) – Hoianheritage.net](https://hoianheritage.net/vi/trao-doi-chuyen-nganh/chuyen-de-nghien-cuu-trao-doi/kien-truc-co-cac-hoi-quan-cua-nguoi-hoa-o-hoi-an-quang-nam-735.html)
- [7] [Phố cổ Hội An – Wikipedia tiếng Việt](https://vi.wikipedia.org/wiki/Ph%E1%BB%91_c%E1%BB%95_H%E1%BB%99i_An)
