/// NPC dialogue shown once per chapter, before its first level. Content is
/// copied verbatim from docs/GAME_DESIGN_ACTS.md §19 (script for Hồi 1).
library;

/// One line of dialogue. An empty [speaker] marks a stage direction (shown
/// in italics, no speaker name) rather than a spoken line.
class DialogueLine {
  final String speaker;
  final String text;
  const DialogueLine({required this.speaker, required this.text});
}

class SceneDef {
  final String id;
  final List<DialogueLine> lines;
  const SceneDef({required this.id, required this.lines});
}

/// §19.1 — mở đầu Hồi 1, trước Chương 1 "Trại gà nhỏ".
const hoi1Open = SceneDef(
  id: 'hoi1_open',
  lines: [
    DialogueLine(speaker: '', text: 'Sân nông trại bỏ hoang, sáng sớm.'),
    DialogueLine(speaker: 'Mai (nội tâm)', text: 'Nhà cũ của bà... lâu rồi mình mới về.'),
    DialogueLine(speaker: '', text: 'Mai mở cửa chuồng gà, thấy cỏ mọc um tùm, vài con gà đi lạc.'),
    DialogueLine(speaker: 'Ông Tư (từ hàng rào)', text: 'Ơ, cháu bà Năm đây hả? Về từ hôm nào vậy con?'),
    DialogueLine(speaker: 'Mai', text: 'Dạ con mới về sáng nay chú Tư. Con... con định dọn lại ít bữa rồi tính sau.'),
    DialogueLine(
      speaker: 'Ông Tư (cười)',
      text:
          'Tính sau là tính gì, đất này bà Năm cực khổ gầy dựng cả đời. Để chú chỉ con vài đường, gà vịt '
          'với đất đai không khó như con nghĩ đâu.',
    ),
    DialogueLine(
      speaker: 'Mai (cầm cuốn sổ tay cũ của bà Năm lên)',
      text: 'Con thấy trong này bà ghi mấy công thức... con chưa hiểu hết.',
    ),
    DialogueLine(speaker: 'Ông Tư', text: 'Từ từ rồi hiểu. Bắt đầu từ đàn gà trước đi, cái gì cũng phải có cái đầu tiên.'),
  ],
);

/// §19.2 — Chương 2 "Vườn dừa": giới thiệu Chú Bảy.
const chCoconutIntro = SceneDef(
  id: 'ch_coconut_intro',
  lines: [
    DialogueLine(speaker: '', text: 'Góc vườn phía sau nhà, hàng dừa già cỗi.'),
    DialogueLine(
      speaker: 'Ông Tư',
      text: 'Đám dừa này bỏ lâu quá rồi, để chú kêu ông Bảy qua coi giùm, ổng rành cây cối hơn chú.',
    ),
    DialogueLine(speaker: '', text: 'Chú Bảy xuất hiện, đội nón lá, tay cầm cái cuốc.'),
    DialogueLine(
      speaker: 'Chú Bảy',
      text: 'Trời đất, dừa nhà bà Năm mà để vầy nè! Để chú coi... (sờ vào gốc cây) Còn sống, còn cứu được.',
    ),
    DialogueLine(speaker: 'Mai', text: 'Chú ơi con phải làm sao để nó ra trái lại ạ?'),
    DialogueLine(
      speaker: 'Chú Bảy (cười lớn)',
      text: 'Từ từ con ơi, cây cối cũng như người, phải nuôi từ hạt, lớn từng chút một. Con gieo hạt đi, chú chỉ từng bước.',
    ),
  ],
);

/// §19.7 — dòng thoại ngắn, Chương 3 "Bò sữa".
const chDairyIntro = SceneDef(
  id: 'ch_dairy_intro',
  lines: [DialogueLine(speaker: 'Ông Tư', text: 'Bò nhà bà Năm hiền lắm, con cứ vắt sữa từ từ, đừng vội.')],
);

/// §19.7 — dòng thoại ngắn, Chương 4 "Vườn rau củ".
const chVegetableIntro = SceneDef(
  id: 'ch_vegetable_intro',
  lines: [DialogueLine(speaker: 'Ông Tư', text: 'Rau củ dễ trồng nhất đó con, coi như màn nghỉ sau vụ dừa.')],
);

final Map<String, SceneDef> scenes = {
  for (final s in [hoi1Open, chCoconutIntro, chDairyIntro, chVegetableIntro]) s.id: s,
};
