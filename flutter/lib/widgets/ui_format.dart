/// Ported from src/view/theme.ts (starString).
String starString(int stars, [int max = 3]) => '★' * stars + '☆' * (max - stars);
