import type { Level } from '#lib/types/learning';

/**
 * Spec-defined level thresholds:
 *   score < 85        → Keep Growing
 *   85 ≤ score < 95   → Level Up
 *   score ≥ 95        → Power Team
 */
export function calculateLevel(averageScore: number): Level {
  const s = Math.max(0, Math.min(100, averageScore));

  if (s >= 95) {
    return {
      name: 'Power Team',
      minScore: 95,
      maxScore: 100,
      color: '#D97706',
      bgColor: '#FEF3C7',
      progress: Math.round(((s - 95) / 5) * 100)
    };
  }
  if (s >= 85) {
    return {
      name: 'Level Up',
      minScore: 85,
      maxScore: 94,
      color: '#2E7BE8',
      bgColor: '#EBF3FE',
      progress: Math.round(((s - 85) / 10) * 100)
    };
  }
  return {
    name: 'Keep Growing',
    minScore: 0,
    maxScore: 84,
    color: '#1C50A7',
    bgColor: '#EFF4FC',
    progress: s === 0 ? 0 : Math.round((s / 85) * 100)
  };
}
