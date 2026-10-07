import type { ScoreData } from '#lib/types/learning';
import { mockScore } from '#lib/mocks/scores';

export async function getScore(): Promise<ScoreData> {
  return mockScore;
}
