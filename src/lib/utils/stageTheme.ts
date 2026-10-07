export interface StageTheme {
  color: string;
  bgColor: string;
  badgeBg: string;
  badgeText: string;
}

const stageThemes: StageTheme[] = [
  // Stage 1 — deep blue
  { color: '#1C50A7', bgColor: '#EFF4FC', badgeBg: '#1C50A7', badgeText: '#ffffff' },
  // Stage 2 — medium blue
  { color: '#2E7BE8', bgColor: '#EBF3FE', badgeBg: '#2E7BE8', badgeText: '#ffffff' },
  // Stage 3 — orange/amber (highlight)
  { color: '#D97706', bgColor: '#FEF6E8', badgeBg: '#F2AC44', badgeText: '#ffffff' },
  // Stage 4 — soft purple
  { color: '#7C5CBF', bgColor: '#F3EEFF', badgeBg: '#7C5CBF', badgeText: '#ffffff' },
  // Stage 5 — soft green
  { color: '#27AE78', bgColor: '#E8F8F2', badgeBg: '#27AE78', badgeText: '#ffffff' },
];

/**
 * Returns the visual theme for a stage based on its sequence number.
 * Wraps around if sequence exceeds the number of defined themes.
 */
export function getStageTheme(sequence: number): StageTheme {
  const idx = Math.max(0, sequence - 1) % stageThemes.length;
  return stageThemes[idx];
}
