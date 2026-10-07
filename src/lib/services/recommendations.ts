import type { Recommendation } from '#lib/types/learning';
import { mockRecommendations } from '#lib/mocks/recommendations';

export async function getRecommendations(): Promise<Recommendation[]> {
  return mockRecommendations;
}
