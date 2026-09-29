import '../core/types.dart';

/// Groups the flat `chapters` list (lib/data/chapters.dart) into "tài sản"
/// (properties) for the world-map tab — 1 property per Hồi's worth of
/// chapters that actually exist in code so far. A property unlocks exactly
/// when its first chapter does (see SaveManager.isPropertyUnlocked), so this
/// is purely a display grouping — no new unlock state.
///
/// Only 2 properties exist right now because only Hồi 1 (4 chapters) and the
/// start of Hồi 2 (1 chapter) are implemented — see docs/GAME_DESIGN_ACTS.md
/// §18/§17.2 for the many chapters still backlog-only. Add a chapter's id to
/// the right `chapterIds` (or a new PropertyDef) as more chapters land.
const farmProperty = PropertyDef(id: 'farm', name: 'Nông trại', emoji: '🚜', chapterIds: ['ch1', 'ch_coconut', 'ch_dairy', 'ch_vegetable']);

const cuisineProperty = PropertyDef(id: 'cuisine', name: 'Ẩm thực Việt Nam', emoji: '🍜', chapterIds: ['ch2']);

final List<PropertyDef> properties = [farmProperty, cuisineProperty];
