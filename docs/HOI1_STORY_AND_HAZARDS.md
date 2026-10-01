# Hồi 1 — Cốt truyện xuyên suốt & Hệ vật cản/tác nhân v2

> Bổ sung cho `HOI1_VIETNAM_EXPANSION.md` (v5). Trả lời 2 yêu cầu:
> 1. **1 câu chuyện đủ dài để nối 307 chương / 1.976 màn** mà không lặp, không nhàm.
> 2. **Vật cản/tác nhân mới cho các màn sau**: sâu bệnh, quả bị hư do tác nhân trong bàn, cỏ, hồ, gò đất…
>
> Dữ liệu máy đọc được: [`hoi1_story_map.csv`](hoi1_story_map.csv) (mỗi chương → Tập → beat → vai trò → vật cản),
> sinh từ [`hoi1_assets.csv`](hoi1_assets.csv). Mọi số liệu về màn/`moveLimit`/độ khó vẫn là **thiết kế khởi điểm, chưa sim**.

---

## 0. Tóm tắt

| Yêu cầu | Giải pháp |
|---|---|
| Story nối cả 1.976 màn, không nhàm | **Story Engine 5 tầng**: Sổ (1) → Phần/tháng (12) → **Tập (48)** → Chương (307) → Màn. Mỗi tầng có "đơn vị nội dung" riêng; chỉ 3 loại màn có thoại (§1.2). Chống lặp bằng **15 loại beat**, **48 câu tục ngữ/ca dao không trùng**, **36 khoản nợ nghĩa** và **quy tắc xen kẽ** (§3–§5). |
| Vật cản mới, tăng độ khó | **Codex 14 vật cản** (6 địa hình · 2 động · 5 tác nhân + trạng thái **Thâm/Hư** cho quả) — mỗi Phần giới thiệu đúng 1–2 loại kèm **lý do trong truyện** (§7–§8). |
| Không chỉ "khó hơn" mà có chiến thuật | Mỗi vật cản có **đối sách trên bàn** *và* **đối sách ngoài bàn** (vật nuôi/công trình đã có ở nông trại → buff phòng thủ) (§8.5). |

---

## 1. Story Engine — vì sao 1.976 màn không nhàm

### 1.1 Năm tầng

| Tầng | Số lượng | Đơn vị nội dung | Ghi chú |
|---|---|---|---|
| **Sổ** (xuyên suốt) | 1 | Câu hỏi kịch tính: *Mai ở lại hay đi?* + 12 trang sổ + 36 khoản nợ nghĩa | Sợi chỉ đỏ, không bao giờ "hết chuyện" |
| **Phần** (tháng âm lịch) | 12 | 1 dịp lễ thật + 1 mối họa mới + 1 trang sổ | Đã có ở v5 §2 |
| **Tập** | **48** (4/Phần) | 1 vụ việc nhỏ có mở–thắt–gỡ, 1 NPC chủ đạo, 1 loại beat, 1 câu tục ngữ | **Đơn vị chống nhàm chính** (§5) |
| **Chương** | 307 | 1 "thẻ kiến thức" (1 sự thật thật về vật/món) + 1 dòng NPC | Không có cốt truyện riêng; dùng để "đổi giọng" (§6) |
| **Màn** | 1.976 | Không thoại, trừ 3 trường hợp | Tránh nghẽn nhịp chơi |

### 1.2 Chỉ 3 loại màn có thoại

1. **Màn 1 của chương** — 1–2 bong bóng (thẻ kiến thức + dòng NPC).
2. **Màn boss / màn cuối của chương** — 1–2 bong bóng kết chương.
3. **Lần đầu xuất hiện một vật cản/tác nhân** — 1 màn hướng dẫn có thoại (14 lần trong cả Hồi).

Ngoài ra **Tập mở đầu/kết** có cảnh dài (6–10 dòng / 3–4 dòng). Ước lượng tổng thoại Hồi 1 ≈ **2.000 dòng**
(Tập 48×14 · chương 307×2 · nợ nghĩa 36×10 · sổ 12×15 · hướng dẫn vật cản 14×8 · kết Hồi 30).

### 1.3 Vì sao cách này chống lặp

- **Không lặp cấu trúc:** 15 loại beat, không Tập liền nhau cùng beat (đã kiểm: 0 cặp trùng trong 48 Tập).
- **Không lặp nội dung:** mỗi Tập có 1 câu tục ngữ/ca dao riêng (48 câu, không trùng), mỗi chương 1 "thẻ kiến thức" riêng.
- **Không lặp nhân vật:** 12 dân làng + 9 NPC chính luân phiên; không NPC nào chủ đạo 2 Tập liền nhau.
- **Xen kẽ thể loại chương:** mỗi Tập chứa hỗn hợp **xây + trồng + nuôi + chế biến** (script phân bổ round-robin, xem CSV), nên người
  chơi không bao giờ gặp 8 chương "cây" liền nhau.
- **Nhịp cao trào:** mỗi Phần luôn kết bằng **lễ hội** (Tập 4); mỗi 3 chương có 1 chương "thở" (hazard nhẹ).

---

## 2. Cốt truyện bao trùm

*(Giữ nguyên nội dung ở `HOI1_MASTER_DESIGN.md §2` và `HOI1_VIETNAM_EXPANSION.md §8` — không nhắc lại; chỉ bổ sung khung ghép.)*

**Ba sợi chỉ chính** chạy song song, mỗi Tập kéo ít nhất 1 sợi:

| Sợi | Câu hỏi | Nhịp mở | Nhịp đóng |
|---|---|---|---|
| **A. Ở hay đi?** | Mai bán đất hay giữ? | Thư môi giới #1 (P3), #2 (P7), #3 (P11) | Xé thư (P12T1) |
| **B. Sổ 12 trang** | Bà Năm muốn nói gì với Mai? | Trang #1 (P1T1) | Trang #12 (P12T4) |
| **C. Sổ nợ nghĩa** | Vì sao cả xóm giúp Mai? | Lộ ra ở P6T3 (nhưng khoản đầu đã gieo từ P1T2) | Trả hết ở P12T2 |

**Ba sợi phụ:** **D. Mực** (chó đen — thấy ở P1T3, có tên P10T3) · **E. Mứt gừng** (gừng P7 → mứt P11 thiếu vị → hoàn thành P12) · **F. Vòng cung NPC** (§2.1).

### 2.1 Vòng cung NPC (mỗi người 4 nhịp — đảm bảo mỗi NPC có "chuyện của riêng mình", không chỉ làm nền)

| NPC | Nhịp 1 | Nhịp 2 | Nhịp 3 | Nhịp 4 |
|---|---|---|---|---|
| **Ông Tư** | Hứa với bà canh nông trại (P1) | Lộ ra ông từng dạy bà cấy (P6) | Ông giấu mảnh đất nhỏ để dành cho Mai (P9) | Ông nhận mình là "người canh" cuối cùng (P12) |
| **Chú Bảy** | Cứng đầu, chê nhà kính (P2) | Chịu thua khi nhà kính cho rau ra sớm (P4) | Cùng Bác Tám thi trái ngon (P5) | Nhận nhà kính "phụ" của Mai (P10) |
| **Bé Na** | Bé con nghịch phá (P3) | Học nhận biết bệnh cây từ Thầy Lành (P5) | Nuôi mèo, tự tin (P9) | Tự xin làm "bác sĩ nhí" của vườn (P11) |
| **Dì Sáu** | Chê Mai là "dân thành phố" (P1) | Bắt đầu tin (P5) | Con trai Tài về, tự hào (P7) | Nhường sạp đẹp nhất cho Mai (P12) |
| **Bác Hai** | Chê Mai xây ẩu (P1) | Xây nhà cho con trai, kể chuyện (P4) | Đắp gò, cứu vật nuôi (P8) | Xây Cổng chào (P12) |
| **Cô Ba** | Chưa xuất hiện | Dạy làm bánh (P9) | Buồn vì chưa nhớ hết công thức bà (P11) | Cùng Mai hoàn thành mứt gừng (P12) |
| **Anh Tài** | Ở thành phố (nhắc tên) | Về làng, mơ đi xa (P7) | Ở lại lo vận chuyển (P10) | Lái xe chở Chợ nổi Tết (P12) |
| **Anh Long** | Thư lịch sự (P3) | Thư nài nỉ nhẹ (P7) | Đích thân đến, thấy xóm (P11) | Mua mứt thay vì đất (P12) |

### 2.2 12 dân làng luân phiên (không cần full-body, chỉ chân dung nhỏ)

Chị Hai Hạnh (cô giáo) · Anh Ba Đen (chèo xuồng) · Bác Tám (lão nông hay quên) · Chị Tư Lụa (thợ may) · Cậu Út (mê livestream) ·
Bà Chín Mắm (bán mắm, hay càu nhàu) · Chú Năm Điện (thợ điện) · Sư cô Diệu Liên (chùa làng) · Thầy Lành (thú y) ·
Ông Sáu Râu (ngư dân) · Mợ Bảy Chè (bán chè) · Cậu Tí (nhóc bạn Bé Na).

---

## 3. Thư viện 15 beat

Mỗi Tập gán đúng 1 beat chính. Beat quyết định **hình thức cảnh mở Tập** (không phải nội dung) — cùng 1 câu chuyện nhưng cách kể khác nhau.

| Mã | Beat | Hình thức | Tần suất trong 48 Tập |
|---|---|---|---|
| B01 | Nhờ vả | NPC nhờ, Mai đồng ý/khó xử | 1 |
| B02 | Dạy nghề | NPC làm mẫu, Mai thử sai rồi đúng | 3 |
| B03 | Sự cố | Vật cản mới xuất hiện, cần đối phó | 7 |
| B04 | Lễ hội | Cảnh tập thể, nhiều NPC | 12 |
| B05 | Trang sổ | Mai đọc trang sổ, nội tâm | 4 |
| B06 | Hồi tưởng | Màu sepia, bà hiện ra nhạt | 3 |
| B07 | Thi đua | 2 NPC cạnh tranh nhẹ | 1 |
| B08 | Khách lạ | Người ngoài làng ghé | 2 |
| B09 | Xây dựng | Bác Hai + đội xây | 2 |
| B10 | Chuyện phiếm | Nói chuyện hàng xóm, vui | 1 |
| B11 | Trả nghĩa | Khoản nợ được trả | 3 |
| B12 | Hài | Bé Na/Cậu Út gây rối | 2 |
| B13 | Thời tiết | Mưa/nắng/nước tác động, hazard theo mùa | 4 |
| B14 | Quyết định | Mai lựa chọn (chỉ cảnh giác, không nhánh) | 1 |
| B15 | Đổi quà | Trao đổi vật phẩm giữa NPC | 2 |

*(Tần suất do script tính từ bảng 48 Tập bên dưới.)*

### Quy tắc chống lặp (bắt buộc khi viết/duyệt nội dung)

1. **Không 2 Tập liền nhau cùng beat.**
2. **Mỗi Phần ≥ 3 beat khác nhau**, và luôn có **B04 (Lễ hội) ở Tập 4**.
3. **Vật cản mới chỉ được giới thiệu ở Tập B03 (Sự cố) hoặc B13 (Thời tiết)**; mỗi lần giới thiệu phải có **cách giải quyết khác loại** (bắt tay / xây / che / đổi / nuôi vật) — xem §8.1.
4. **1 NPC không chủ đạo 2 Tập liền nhau** (đã kiểm: 0 cặp trùng trong 48 Tập).
5. **Không quá 2 chương liền cùng loại** trong 1 Tập (kiểm bằng CSV).
6. **Tục ngữ không lặp** (48 câu đã chọn, xem bảng).
7. **Trang sổ chỉ xuất hiện khi có công trình hoàn thành** — thưởng cho tiến độ, không phải "nhặt bừa".

---

## 4. Sổ nợ nghĩa — 36 khoản

Mỗi khoản = 1 mini-arc **2–3 chương** trong đúng Tập ghi ở cột 1. Cấu trúc: *(1) NPC nhắc lại chuyện bà giúp* → *(2) NPC xin trả nghĩa bằng hành động cụ thể* → *(3) phần thưởng nhỏ (xu / giống / vật liệu / trang trí).*

| # | Tập | NPC | Bà Năm từng… | Trả nghĩa bằng |
|---|---|---|---|---|
| D01 | P1T2 | Ông Tư | cho mượn cái cuốc 20 năm chưa trả | công dọn sân + cuốc đã rèn lại |
| D02 | P1T3 | Bác Tám | cho 3 con gà giống | chỉ chỗ Mực hay ngồi + lồng |
| D03 | P1T4 | Dì Sáu | cho mượn gánh bán hàng đầu tiên | cho Mai mượn Sạp chợ |
| D04 | P2T1 | Chú Bảy | dạy nghề ghép | dạy Mai ghép cành |
| D05 | P2T2 | Chị Tư Lụa | cho mượn máy may | nón lá + khăn rằn (trang trí) |
| D06 | P2T3 | Mợ Bảy Chè | nấu chè 3 ngày đám ma nhà bà | gói bánh trôi bánh chay |
| D07 | P3T1 | Chú Năm Điện | cho mượn đèn măng-xông | sửa điện chuồng |
| D08 | P3T2 | Bé Na | cứu con heo con nhà Na | xung phong chăm heo |
| D09 | P3T3 | Sư cô Diệu Liên | mượn hạt sen cho chùa | biếu hạt sen giống |
| D10 | P4T1 | Bác Tám | cho cành mít ghép | cây mít giống |
| D11 | P4T2 | Bác Hai | giúp lợp lại mái nhà | miễn công giăng lưới |
| D12 | P4T3 | Bà Chín Mắm | cho mượn hũ muối | rượu nếp gia truyền |
| D13 | P5T1 | Dì Sáu | cho khách đặt hàng đầu tiên | giới thiệu khách du lịch |
| D14 | P5T2 | Thầy Lành | nuôi giúp con chó bệnh | dạy phòng bệnh cây trái |
| D15 | P5T3 | Cậu Tí | cho kẹo thuở nhỏ | đi bắt sâu giúp |
| D16 | P6T1 | Chú Năm Điện | thắp đèn giữa lũ | che kho khỏi mưa |
| D17 | P6T2 | Bác Tám | được bà dạy cấy lúa | dạy lại cho Mai cấy gặt |
| D18 | P6T3 | Ông Sáu Râu | cho mượn xuồng | giữ xuồng cho Mai |
| D19 | P7T1 | Anh Ba Đen | đưa ông qua sông lúc bệnh | chèo xuồng chở hàng |
| D20 | P7T2 | Dì Sáu (vì Tài) | cho Tài tiền học lái | Tài chở hàng miễn phí mùa đầu |
| D21 | P7T3 | Chú Bảy | trồng gừng chữa ho cho ông | giống gừng già |
| D22 | P8T1 | Ông Sáu Râu | mua cá giá cao lúc ông hết vốn | tặng cá giống |
| D23 | P8T2 | Bác Hai | cho nhờ một gò đất | đắp gò cho Mai |
| D24 | P8T3 | Chị Hai Hạnh | cho lớp học mượn bảng | cả trường đến phụ |
| D25 | P9T1 | Bà Chín Mắm | cho mượn hũ gạo lúc đói | gạo mới cúng bà |
| D26 | P9T2 | Bé Na | tặng Na mèo con | mèo giữ kho |
| D27 | P9T3 | Cô Ba | dạy nghề bánh | công thức sáp ong |
| D28 | P10T1 | Cậu Út | dạy Út hát | livestream bán mứt |
| D29 | P10T2 | Chú Bảy | cứu vườn khỏi bão | dựng bù nhìn |
| D30 | P10T3 | Chị Tư Lụa | may áo cưới miễn phí | vải may áo Tết |
| D31 | P11T1 | Bà Chín Mắm | thả cá chép giúp | mang cá chép |
| D32 | P11T2 | Thầy Lành | nuôi thầy hồi nhỏ | thuốc quý trị bệnh |
| D33 | P11T3 | Cô Ba | giấu vị cuối của mứt gừng | bí quyết lát quýt |
| D34 | P12T1 | Anh Long | cho mẹ anh bát cơm hồi đói | mua mứt thay đất |
| D35 | P12T2 | Cả xóm | — | trả hết nợ còn lại |
| D36 | P12T3 | Anh Ba Đen | — | chèo xuồng Chợ nổi Tết |

---

## 5. 48 Tập — bản đồ toàn Hồi 1

Mỗi Tập gồm 2–10 chương, gồm cả 4 loại (xây/trồng/nuôi/chế biến) trừ Tập nhỏ ở P1/P12. Danh sách chương thuộc Tập nằm ở
[`hoi1_story_map.csv`](hoi1_story_map.csv) (cột `tap`, `thuTu`). Chương **ghim** (pinned) theo cốt truyện: ví dụ Nhà ong ở P9T3, mứt gừng ở P11T3.

| Tập | Tên | Beat | NPC | Vấn đề → giải quyết | Tục ngữ / ca dao | Số chương |
|---|---|---|---|---|---|---|
| P1T1 | Về nhà | B05 Trang sổ | Ông Tư | Mai về nông trại hoang, tìm trang sổ #1 trong chuồng gà cũ. | *Có công mài sắt, có ngày nên kim.* | 3 |
| P1T2 | Tiếng gà đầu năm | B09 Xây dựng | Bác Hai | Bác Hai dựng lại chuồng gà; gạch đá vụn ngổn ngang chặn lối. | *Một cây làm chẳng nên non.* | 3 |
| P1T3 | Con chó ngoài hàng rào | B10 Chuyện phiếm | Dì Sáu | Mai thấy chó đen đứng ngoài hàng rào; Dì Sáu bảo đó là chó của bà. | *Nuôi chó giữ nhà, nuôi gà gáy sáng.* | 3 |
| P1T4 | Rằm Nguyên Tiêu | B04 Lễ hội | Ông Tư | Cả xóm ra Sạp chợ làng mừng Mai về; buổi bán đầu tiên. | *Tháng Giêng là tháng ăn chơi.* | 3 |
| P2T1 | Hạt giống của bà | B02 Dạy nghề | Chú Bảy | Chú Bảy dạy gieo hạt; Mai tìm ra cách bà đếm hạt bằng đồng dao (#2). | *Tấc đất tấc vàng.* | 7 |
| P2T2 | Cỏ dại tháng Hai | B03 Sự cố | Bác Tám | Cỏ mọc lấn cả luống rau; Mai học nhổ tận gốc. | *Nhổ cỏ phải nhổ tận gốc.* | 8 |
| P2T3 | Thanh Minh tảo mộ | B06 Hồi tưởng | Ông Tư | Mai ra mộ bà, thấy cả xóm đã dọn mộ từ trước; hồi tưởng. | *Uống nước nhớ nguồn.* | 8 |
| P2T4 | Bánh trôi bánh chay | B04 Lễ hội | Mợ Bảy Chè | Hàn Thực 3/3: cả xóm gói bánh, Mai đem ra chợ. | *Bánh trôi nước, thân em vừa trắng lại vừa tròn.* | 7 |
| P3T1 | Mưa đầu mùa | B13 Thời tiết | Ông Tư | Sân lầy sau cơn mưa đầu mùa; bùn kẹt cả xe cút kít. | *Mưa thuận gió hòa.* | 6 |
| P3T2 | Bé Na đến chơi | B12 Hài | Bé Na | Bé Na "phụ" chăm heo, cả chuồng náo loạn. | *Trẻ trồng na, già trồng chuối.* | 5 |
| P3T3 | Hạt sen chùa làng | B11 Trả nghĩa | Sư cô Diệu Liên | Bà từng cho chùa mượn hạt sen; thư môi giới #1 đến. | *Gần bùn mà chẳng hôi tanh mùi bùn.* | 5 |
| P3T4 | Phiên chợ chay Phật Đản | B04 Lễ hội | Dì Sáu | Rằm Phật Đản: chợ chay đông nhất năm. | *Ở hiền gặp lành.* | 5 |
| P4T1 | Trái đầu mùa | B02 Dạy nghề | Chú Bảy | Chú Bảy dạy ghép cành; cây bà trồng ra trái đầu tiên. | *Ăn quả nhớ kẻ trồng cây.* | 6 |
| P4T2 | Lưới che nắng | B03 Sự cố | Bác Hai | Nắng gắt cháy quả; Bác Hai giăng lưới che. | *Nước chảy đá mòn.* | 5 |
| P4T3 | Đoan Ngọ diệt sâu bọ | B15 Đổi quà | Dì Sáu | Sáng mùng 5, cả xóm đổi bánh tro, rượu nếp, trái cây. | *Của biếu là của lo, của cho là của nợ.* | 5 |
| P4T4 | Chợ trái cây Đoan Ngọ | B04 Lễ hội | Bà Chín Mắm | Phiên chợ trái cây đầu hè. | *Buôn có bạn, bán có phường.* | 5 |
| P5T1 | Trái chín rộ | B08 Khách lạ | Mợ Bảy Chè | Đoàn khách du lịch ghé vườn, hỏi mua đủ thứ. | *Trông trời, trông đất, trông mây.* | 6 |
| P5T2 | Sâu đục quả! | B03 Sự cố | Thầy Lành | Thầy Lành chỉ Mai bắt sâu bằng tay, không dùng thuốc. | *Con sâu làm rầu nồi canh.* | 7 |
| P5T3 | Thi trái ngon | B07 Thi đua | Chú Bảy | Chú Bảy và Bác Tám thi xem ai có trái ngon nhất. | *Trăm hay không bằng tay quen.* | 6 |
| P5T4 | Hội chợ trái cây miền Tây | B04 Lễ hội | Dì Sáu | Hội chợ trái cây lớn nhất năm. | *Có bột mới gột nên hồ.* | 6 |
| P6T1 | Mưa dầm tháng Bảy | B13 Thời tiết | Chú Năm Điện | Mưa dầm cả tuần, kho ẩm mốc. | *Mưa dầm thấm lâu.* | 6 |
| P6T2 | Vụ lúa hè thu | B02 Dạy nghề | Bác Tám | Bác Tám dạy Mai cấy và gặt (bà từng dạy ông). | *Được mùa lúa, úa mùa cau.* | 7 |
| P6T3 | Sổ nợ nghĩa | B05 Trang sổ | Ông Tư | Mai đọc trang đầu sổ nợ nghĩa (#6): cả xóm từng được bà giúp. | *Lá lành đùm lá rách.* | 7 |
| P6T4 | Vu Lan cúng bà | B04 Lễ hội | Sư cô Diệu Liên | Rằm tháng Bảy: Mai cúng bà lần đầu. | *Công cha như núi Thái Sơn.* | 7 |
| P7T1 | Nước đầu thu | B13 Thời tiết | Anh Ba Đen | Nước dâng lấp bờ ruộng; Anh Ba Đen chèo xuồng đến. | *Nước lên thì bèo lên.* | 10 |
| P7T2 | Anh Tài về làng | B08 Khách lạ | Anh Tài | Anh Tài (con Dì Sáu) chở xe tải về; Dì Sáu tự hào. | *Đi một ngày đàng học một sàng khôn.* | 10 |
| P7T3 | Gừng bà dặn | B06 Hồi tưởng | Chú Bảy | Bà dặn trồng gừng cho Tết; thư môi giới #2 đến. | *Gừng càng già càng cay.* | 9 |
| P7T4 | Trung Thu rước đèn | B04 Lễ hội | Chị Hai Hạnh | Cô giáo Hạnh tổ chức rước đèn cho cả xóm. | *Rằm tháng Tám trông trăng.* | 9 |
| P8T1 | Nước nổi về | B13 Thời tiết | Anh Ba Đen | Cánh đồng ngập trắng, xuồng thay xe. | *Thuận buồm xuôi gió.* | 9 |
| P8T2 | Gò đất cao | B03 Sự cố | Bác Hai | Bác Hai đắp gò đất cao cho vật nuôi tránh nước. | *Đất lành chim đậu.* | 8 |
| P8T3 | Cả xóm chèo xuồng | B11 Trả nghĩa | Ông Sáu Râu | Bà từng chèo xuồng đưa hạt giống cho cả xóm (#8); nay cả xóm chèo xuồng đến giúp. | *Một con ngựa đau cả tàu bỏ cỏ.* | 8 |
| P8T4 | Chợ mùa nước nổi | B04 Lễ hội | Dì Sáu | Chợ trên xuồng, buổi thử của Chợ nổi. | *Trên bến dưới thuyền.* | 8 |
| P9T1 | Cơm mới cúng bà | B06 Hồi tưởng | Ông Tư | Tết Thường Tân 10/10: cúng cơm mới, hồi tưởng. | *Ăn cơm mới, nói chuyện cũ.* | 4 |
| P9T2 | Chuột trong kho lúa | B03 Sự cố | Bé Na | Chuột phá kho; Bé Na xin nuôi mèo. | *Chuột sa chĩnh gạo.* | 5 |
| P9T3 | Nhà ong của bà | B09 Xây dựng | Bác Hai | Xây Nhà ong xong; trang sổ #9: bà học nuôi ong từ đâu. | *Mật ngọt chết ruồi.* | 5 |
| P9T4 | Lò bánh đầu tiên | B04 Lễ hội | Cô Ba | Cô Ba nhóm lò bánh; Mai được nếm bánh đúng vị bà. | *Một hạt thóc là chín giọt mồ hôi.* | 5 |
| P10T1 | Vào vụ Tết | B01 Nhờ vả | Cậu Út | Cậu Út nhờ Mai làm quà Tết để livestream bán hàng. | *Tháng Chạp trồng khoai, tháng Giêng trồng đậu, tháng Hai trồng cà.* | 8 |
| P10T2 | Chim ăn nụ hoa | B03 Sự cố | Chú Bảy | Chim sẻ ăn nụ mai; Chú Bảy chỉ cách dựng bù nhìn. | *Chim có tổ, người có tông.* | 8 |
| P10T3 | Mực có tên | B12 Hài | Bé Na | Bé Na đặt tên Mực; cỏ leo phủ kín hàng rào. | *Chó treo, mèo đậy.* | 8 |
| P10T4 | Chợ hoa Tết | B04 Lễ hội | Dì Sáu | Chợ hoa Tết đầu tiên của nông trại. | *Xuân về trăm hoa đua nở.* | 8 |
| P11T1 | Ông Táo về trời | B15 Đổi quà | Bà Chín Mắm | 23 tháng Chạp: thả cá chép tiễn Ông Táo. | *Cá chép hóa rồng.* | 9 |
| P11T2 | Quả hư, ruồi bay | B03 Sự cố | Thầy Lành | Quả hư đầu tiên kéo ruồi; bệnh lây từ luống này sang luống khác. | *Thuốc đắng dã tật.* | 9 |
| P11T3 | Mứt gừng thiếu vị | B05 Trang sổ | Cô Ba | Mai làm mứt gừng nhưng thiếu 1 vị bà hay thêm (#11); thư môi giới #3 đến. | *Ăn ở như bát nước đầy.* | 10 |
| P11T4 | Đêm gói bánh chưng | B04 Lễ hội | Ông Tư | Cả làng thức đêm canh nồi bánh chưng. | *Cây có cội, nước có nguồn.* | 10 |
| P12T1 | Ba mươi Tết | B14 Quyết định | Anh Long | Anh Long đến hỏi câu trả lời; Mai xé thư. | *Bà con xa không bằng láng giềng gần.* | 3 |
| P12T2 | Trả nghĩa cuối năm | B11 Trả nghĩa | Ông Tư | Cả xóm đến trả hết nợ nghĩa còn lại. | *Có qua có lại mới toại lòng nhau.* | 3 |
| P12T3 | Chợ nổi Tết | B04 Lễ hội | Anh Ba Đen | Mùng 1: xuồng đầy hoa và mứt trên sông. | *Mua may bán đắt.* | 3 |
| P12T4 | Lời cuối | B05 Trang sổ | Mai | Trang sổ #12 — lời cuối của bà. | *Tre già măng mọc.* | 2 |

**Ví dụ sắp xếp chương trong 1 Tập (P5T2 — "Sâu đục quả!")** *(thứ tự chương trong Tập: xây → cây → vật nuôi → chế biến)*:
xem CSV: mỗi chương có `role` (`xay`/`chinh`/`tho`/`boss-remix`) và `hazards`, nên màn giới thiệu sâu luôn là chương cây/quả đầu Tập.

---

## 6. "Thẻ kiến thức" — làm chương nào cũng khác

Mỗi **chương** (307) có 1 thẻ, viết theo khuôn, để 2 chương cùng loại vẫn không giống nhau:

| Trường | Ví dụ (Xoài) | Ví dụ (Bánh tét) | Ví dụ (Nhà ong) |
|---|---|---|---|
| Sự thật thật | Xoài cát Hòa Lộc thơm nhất khi chín cây | Bánh tét miền Nam gói lá chuối, nhân đậu xanh | Ong thợ bay xa 3 km lấy mật |
| Mùa/vùng | Tháng 4–6, Tiền Giang | 25–30 Tết, miền Nam | Mùa hoa nhãn |
| Dòng NPC (1 câu, đúng giọng) | Chú Bảy: "Cây già cho trái ngọt." | Cô Ba: "Nếp phải ngâm qua đêm." | Bác Hai: "Thùng ong phải quay hướng đông." |
| Cảm xúc | Tự hào | Ấm áp | Tò mò |

Yêu cầu: **không lặp "cảm xúc" ở 3 chương liền nhau**; **dòng NPC** luân phiên theo bảng NPC của Tập; thẻ dùng làm nhãn "bạn có biết?" cả trong
Album giống. Đây là **việc viết nội dung** (≈ 300 thẻ) — nên làm từ file CSV để không bỏ sót chương.

---

## 7. Vật cản v2 — Codex 14

### 7.1 Thuật ngữ

- **Địa hình**: đặt sẵn từ đầu màn (vị trí trong dữ liệu).
- **Động**: thay đổi theo lượt (lịch cố định, có báo trước).
- **Tác nhân**: một **thực thể trên bàn** (di chuyển hoặc bám vào ô) có thể **làm hỏng quả** (gây trạng thái Thâm/Hư).
- **Trạng thái quả**: **Tươi → Thâm → Hư** (chỉ áp dụng cho ô có Tile thu hoạch: trái, rau, sản phẩm).

### 7.2 Bảng Codex

| # | id | Tên | Loại | Hành vi | Cách xử lý | Trọng số* |
|---|---|---|---|---|---|---|
| 1 | `rock` | Đá tảng | Địa hình | Chặn ô như hiện có (cắt line thành 2 đoạn) | Không dọn; dùng bố cục | 1 |
| 2 | `weed` | Cỏ dại | Địa hình→lan | Cứ **4 lượt** lan sang 1 ô trống liền kề theo thứ tự cố định | Gộp/tách **tại** ô cỏ để dọn | 1 |
| 3 | `mud` | Bùn lầy | Địa hình | Tile ở ô bùn **không trượt** khi vuốt, nhưng vẫn gộp nếu ô liền kề trượt tới | Sau khi Tile đó tham gia 1 phép gộp, bùn khô | 1 |
| 4 | `net` | Lưới giàn | Địa hình | Ô chỉ thu hoạch được khi **chạm 2 lần** (tự dọn sau lần 2) | Chạm 2 lần | 1 |
| 5 | `mound` | **Gò mối / Gò đất** | Địa hình | Chặn ô, có **3 độ bền**. Mỗi **phép gộp** xảy ra ở ô liền kề (4 hướng) trừ 1. Về 0 → thành ô trống. **Nước dâng không vượt gò.** | Gộp cạnh gò 3 lần | 1,5 |
| 6 | `pond` | **Ao / Hồ** | Địa hình | Ô nước: **không đặt/dừng Tile**, không sinh mới. Khi vuốt, **Tile bay qua** ao như thể ô đó không tồn tại (line ngắn lại). Ao là **nguồn của Nước dâng**. | Không dọn; tận dụng "nhảy qua ao" để gộp hai bờ | 1 |
| 7 | `vine` | **Cỏ leo** *(biến thể nặng của cỏ dại)* | Địa hình→lan | Lan **2 ô** mỗi **3 lượt** dọc hàng/cột đã có cỏ leo; bám chặt: gộp tại ô mới dọn | Gộp tại ô, hoặc liền kề 2 lần | 2 |
| 8 | `decay` | Ẩm mốc *(đã có: `GAME_DESIGN_ACTS.md §13`)* | Động | Sinh dần theo lượt, 5 va chạm để dọn; 2 nhẹ gộp thành **nặng** cần Bộ Sửa Chữa | Vuốt cho Tile "va" vào; hoặc Bộ Sửa Chữa | 2 |
| 9 | `flood` | **Nước dâng** | Động | Mỗi **6 lượt** nước dâng từ ao/biên **2 lượt** phủ 2–4 ô theo 1 hàng/cột. **Báo trước 1 lượt** (icon sóng). Ô ngập: **không sinh Tile mới**; Tile **đang đứng ở ô ngập lúc nước đạt đỉnh → Thâm**. Bị **gò/đá** chặn | Dời quả khỏi hàng báo ngập; đặt gò/đá làm đê | 3 |
| 10 | `worm` | **Sâu đục quả** | Tác nhân | Bám lên 1 Tile tier ≥2. Mỗi **3 lượt** cắn: **Tươi→Thâm**; cắn lần 2 → **Hư**, rồi bò sang ô liền kề có Tile. | **Chạm ô có sâu = "bắt sâu"** (tốn 1 lượt, sâu chết); hoặc **gộp** Tile đó (sâu chết) | 2 |
| 11 | `rat` | **Chuột** | Tác nhân | Vào từ biên mỗi **8 lượt**; mỗi lượt tiến 1 ô về Tile **tier cao nhất**; khi tới sẽ **ăn** (xoá Tile) sau 1 lượt | **Chạm chuột = đuổi** (1 lượt); hoặc **gộp** Tile mục tiêu trước | 2,5 |
| 12 | `bird` | **Chim sẻ** | Tác nhân | **Báo trước 1 lượt** (bóng chim trên 1 hàng). Rồi mổ Tile **tier cao nhất trong hàng**: **Tươi→Thâm** | Dời/gộp Tile khỏi hàng; hàng có **lưới** an toàn | 2 |
| 13 | `fly` | **Ruồi vàng** | Tác nhân | **Sinh ra từ mỗi quả Hư** (mỗi **4 lượt**, tối đa 2 con). Mỗi lượt bay 1 ô ngẫu nhiên (RNG cố định theo màn); đậu lên Tile **Tươi → Thâm**. Sống 6 lượt | **Chạm ruồi = đuổi** (1 lượt); **bỏ quả Hư** để hết nguồn | 2,5 |
| 14 | `blight` | **Bệnh nấm** | Tác nhân | 1 Tile nhiễm. Mỗi **3 lượt** lây sang 1 Tile **cùng chuỗi** liền kề; nhiễm 4 lượt → **Hư** | **Gộp Tile nhiễm** với Tile cùng tier (cách ly & làm sạch); hoặc Thuốc | 3 |

\* Trọng số dùng cho **ngân sách vật cản** ở §8.6 (weight × số đơn vị).

### 7.3 Quả bị hư do tác nhân — 3 trạng thái (yêu cầu của bạn)

| Trạng thái | Nhận biết | Ảnh hưởng |
|---|---|---|
| **Tươi** | bình thường | tính vào mục tiêu |
| **Thâm** (bruised) | đốm nâu | Vẫn gộp được, nhưng **kết quả gộp cũng Thâm**; **không tính vào mục tiêu** ("khách chê quả thâm") |
| **Hư** (rotten) | xám mốc, ruồi | **Không gộp được**, chiếm ô; phát sinh **ruồi** (`fly`) |

**Đối sách quả:**
- **Gọt** (chạm Tile **Thâm**, tốn 1 lượt): về **Tươi**, tụt **1 tier** (tối thiểu tier 1).
- **Bỏ** (chạm Tile **Hư**, tốn 1 lượt): ô trống. Nếu đã xây **Hầm ủ phân** → **miễn phí** và nhận xu "phân".
- **Gộp Thâm + Thâm cùng tier** → ra **Thâm tier+1** (không phục hồi); nên "gọt" trước khi gộp nếu cần mục tiêu.

> Nguyên tắc: tác nhân **không bao giờ** làm mất quả *ngay lập tức* — luôn có ≥ 1 lượt báo trước và ≥ 1 cách xử lý miễn phí/rẻ. **Trừ chuột** (ăn thật) nhưng chuột có đường đi dự đoán được và có thể đuổi.

### 7.4 Quy tắc an toàn chung

1. **Luôn còn đường giải** (bot sim).
2. **3 lượt an toàn đầu màn**: tác nhân chưa hành động.
3. **Tối đa 2 tác nhân hoạt động cùng lúc** (3 ở boss).
4. **Mọi tác động đều có báo trước 1 lượt** (icon), RNG cố định theo `levelId` để chơi lại y hệt (cần cho sim & thi đua).
5. **Chương "xây"** chỉ có **địa hình** (`rock/weed/mud/mound/pond`), tối đa 1 đơn vị — luôn nhẹ.
6. **≤ 3 loại vật cản khác nhau / màn.**

---

## 8. Giới thiệu & tăng độ khó

### 8.1 Lịch giới thiệu — 1 loại mới mỗi Phần (2 ở P8, P10, P11)

| Phần | Vật cản mới | Tập giới thiệu | Lý do trong truyện | NPC dạy | Cách giải quyết |
|---|---|---|---|---|---|
| P1 | `rock` | P1T2 | Gạch đá vụn nhà cũ | Bác Hai | **Bắt tay dọn** |
| P2 | `weed` | P2T2 | Đất bỏ hoang, cỏ mọc | Bác Tám / Chú Bảy | **Nhổ tận gốc** |
| P3 | `mud` | P3T1 | Mưa đầu mùa, sân lầy | Ông Tư | **Chờ nắng + rải rơm** |
| P4 | `net` | P4T2 | Nắng gắt cháy quả | Bác Hai | **Xây lưới che** |
| P5 | `worm` | P5T2 | Mùa trái chín rộ | Thầy Lành | **Bắt tay** (không dùng thuốc) |
| P6 | `decay` | P6T1 | Mưa dầm tháng Bảy | Chú Năm Điện | **Che kho / phơi** |
| P7 | `pond` | P7T1 | Nước dâng đầu thu | Anh Ba Đen | **Đi vòng / đắp bờ** |
| P8 | `flood` · `mound` | P8T1 · P8T2 | Nước nổi; gò cao cứu vật nuôi | Anh Ba Đen · Bác Hai | **Đắp gò** |
| P9 | `rat` | P9T2 | Cơm mới, kho lúa | Bé Na | **Nuôi mèo** (nhận buff) |
| P10 | `bird` · `vine` | P10T2 · P10T3 | Nụ hoa Tết; hàng rào bị phủ | Chú Bảy · Bé Na | **Dựng bù nhìn**; **cắt tỉa** |
| P11 | `fly` · `blight` | P11T2 | Quả hư → ruồi → bệnh lây | Thầy Lành | **Vệ sinh + cách ly** |
| P12 | *(không thêm)* | — | "Tổng ôn" — trộn mọi loại | — | — |

Mỗi vật cản có **1 màn hướng dẫn có thoại** (chương đầu của Tập giới thiệu; xem CSV: vật cản mới **không xuất hiện trước** Tập giới thiệu), độ nặng ≤ 30% ngân sách.
### 8.2 Ngân sách vật cản (Hazard Budget — HB)

`HB = Σ (trọng số × số đơn vị)`. Trần **màn boss** tăng theo Phần; màn thường tăng dần trong chương:

| Phần | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Trần boss | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 | 14 |

- Màn `k` trong chương `N` màn: `HB = trần × (0.15 + 0.85 × (k−1)/(N−1))`, màn 1 mỗi chương **≤ 15% trần**.
- **Chương "thở"** (`role=tho`): HB ≤ 40% trần Phần đó (nhịp răng cưa).
- **`moveLimit` điều chỉnh:** `ML = ML_cơ_sở × (1 + 0.02 × HB)`, rồi tinh chỉnh bằng sim.

**Ví dụ boss có nhiều loại** (đều ≤ 3 loại/màn):
- **P8 — Chợ mùa nước nổi:** `flood`×1 (3) + `mound`×2 (3) + `pond`×1 (1) = **7**  ≤ 9 ✓
- **P11 — Mâm ngũ quả:** `fly`×1 (2,5) + `blight`×1 (3) + `net`×2 (2) = **7,5** ≤ 12 ✓
- **P12 — Đại đơn hàng:** `flood`×1 (3) + `rat`×1 (2,5) + `blight`×1 (3) + `mound`×2 (3) = **11,5** ≤ 14 ✓

### 8.3 Ma trận tương thích & mức dùng

Tác nhân chỉ xuất hiện ở loại chương hợp lý (sâu ↔ trái/rau/ngũ cốc; chuột ↔ ngũ cốc/bánh/chế biến; chim ↔ trái/hoa; ruồi ↔ ngọt/mứt/bánh; nấm ↔ trồng + mứt/bánh). Kết quả thực tế trong `hoi1_story_map.csv`:

| Vật cản | Phần đầu | Số chương có dùng | Loại chương tương thích |
|---|---|---|---|
| rock | P1 | 56 | mọi loại |
| weed | P2 | 53 | mọi loại |
| mud | P3 | 48 | mọi loại |
| net | P4 | 36 | mọi loại |
| worm | P5 | 17 | fruit, veg, grain |
| decay | P6 | 36 | mọi loại |
| pond | P7 | 41 | mọi loại |
| flood | P8 | 29 | mọi loại |
| mound | P8 | 38 | mọi loại |
| rat | P9 | 18 | grain, banh, food, jam |
| bird | P10 | 14 | fruit, flower, grain |
| vine | P10 | 14 | mọi loại |
| fly | P11 | 17 | fruit, jam, banh, food |
| blight | P11 | 13 | fruit, veg, grain, flower, food, jam, banh |

### 8.4 Cường độ tăng từ Phần này sang Phần khác (không chỉ tăng "loại")

Trung bình ≈ **1,6 loại/chương**, nhưng **số đơn vị & tốc độ** tăng:
- **Địa hình:** số ô tăng (1 → 4).
- **Động:** khoảng cách lượt giảm (nước dâng 6 → 5 lượt; sâu cắn 3 → 2 lượt ở P11–P12).
- **Tác nhân:** số con đồng thời tăng (1 → 2 → 3 ở boss).
- **Kết hợp:** từ P9 xuất hiện **cặp có tương tác** (Sâu + Ruồi; Nước + Nấm; Chuột + Chim) để tạo phản ứng dây chuyền.

### 8.5 Đối sách ngoài bàn — nông trại của bạn là giáp

Vật nuôi/công trình đã xây làm giảm áp lực (**tổng tối đa −30% HB hiệu dụng**, kiểm bằng sim):

| Bạn có… | Hiệu ứng | Vật cản bị ảnh hưởng |
|---|---|---|
| **Gà** (chuồng gà + chương gà hoàn thành) | Mỗi màn miễn **1 lần cắn đầu tiên** của sâu | `worm` |
| **Vịt** (ao vịt) | Sâu cắn chậm hơn **+1 lượt** | `worm` |
| **Mèo** (nhận ở P9T2, D26) | Chuột đến chậm hơn **+3 lượt** | `rat` |
| **Chó Mực** (chuồng chó + chương chó) | Chuột **−50% xuất hiện**; **báo trước chim +1 lượt** | `rat`, `bird` |
| **Ếch** (ao đặc sản) | Ruồi sống **ngắn hơn 2 lượt** | `fly` |
| **Kho lạnh** | Thâm→Hư chậm hơn **+1 lượt** | trạng thái quả |
| **Hầm ủ phân** | **Bỏ quả Hư miễn phí** + thưởng xu | trạng thái quả |
| **Nhà kính** | Cỏ lan chậm hơn **+1 lượt** | `weed`, `vine` |
| **Nhà ong + hoa** | Không phòng thủ — thưởng mật | — |

### 8.6 Booster mới (ăn vào Kho — không chỉ xu)

| Booster | Vật phẩm cần (lấy từ Kho) | Tác dụng |
|---|---|---|
| **Bẫy ruồi giấm** | 1 Giấm (`vinegar`, P9) | Diệt mọi ruồi trên bàn |
| **Bù nhìn** | 1 Vải bạt (`canvas`) | Chim không tấn công 5 lượt |
| **Thuốc bệnh** | 1 Tinh dầu sả (`lemongrassOil`) | Xoá mọi ô nhiễm nấm |
| **Cuốc đất** | 1 Dụng cụ (`tool`) | Phá 1 gò/đá hoặc **lấp** 1 ao |
| **Bộ Sửa Chữa** *(đã có)* | gem | Xoá 1 ô ẩm mốc nặng |

→ Liên kết **Kho** với **chiến thuật**: người chơi có lý do giữ hàng trong Kho thay vì bán sạch.

### 8.7 Ví dụ bàn 5×5 — Phần 8 (nước nổi)

```
 .  .  ~  .  .        ~ = ao (bay qua)
 .  A  .  M  .        M = gò mối (3 độ bền, chặn nước)
 W  W  .  .  .        W = ô sẽ ngập ở lượt kế (báo trước)
 .  .  B  .  .        A,B = quả (B nằm trên hàng ngập → dời ngay)
 .  .  .  .  .
```
Chiến thuật: dời B khỏi hàng W hoặc gộp trước khi nước đạt đỉnh; gộp ở ô cạnh **M** để giảm độ bền gò.

---

## 9. Kỹ thuật

| # | Việc | File liên quan |
|---|---|---|
| 1 | Mở rộng `ObstacleKind` (thêm `mound`, `pond`, `vine`, `flood`) + luật `resolveLine` cho `pond` (bỏ qua ô) | `core/types.dart`, `core/resolve_line.dart` |
| 2 | Thêm **thực thể tác nhân** (`Agent`: sâu/chuột/chim/ruồi) với vị trí, tuổi, RNG cố định theo `levelId` + **báo trước** | `core/board.dart`, `core/game_session.dart` |
| 3 | `TileState { fresh, bruised, rotten }` + luật mục tiêu chỉ đếm **fresh** | `core/types.dart`, `core/objective_tracker.dart` |
| 4 | Thao tác chạm mới: **bắt sâu / đuổi / gọt / bỏ** | `game/farm_merge_game.dart` |
| 5 | Buff phòng thủ từ nông trại (đọc `SaveData`) | `core/save_manager.dart` |
| 6 | Booster dùng vật phẩm Kho | `core/save_manager.dart`, `widgets/` |
| 7 | Cân bằng bằng `tool/simulate.dart` (bot có đối sách: bắt sâu, dời quả) | `flutter/tool/` |
| 8 | Sinh `hoi1_story_map.csv` → cấu hình chương (`tap`, `hazards`, `role`) | `tool/gen_levels.dart` |

---

## 10. Câu hỏi mở

1. **Chuột "ăn thật" (xoá Tile)** — chấp nhận là mối đe dọa duy nhất mất hẳn quả? Hay muốn chuột cũng chỉ làm **Thâm**?
2. **Bắt sâu/đuổi/gọt/bỏ** tốn **1 lượt** — hay muốn **miễn phí nhưng giới hạn số lần/màn**?
3. **Trần `HB` ở P12 = 14** có quá cao? (sẽ chỉnh khi sim.)
4. **Thẻ kiến thức**: bạn muốn tôi viết **bản đầu 307 thẻ** từ CSV không?
5. **Mèo** (P9) không phải asset — cần 1 chương mini hay chỉ là quà nhận thưởng?
