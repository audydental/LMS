import type { PointData } from '#lib/types/learning';
import { mockPoints } from '#lib/mocks/points';

export async function getPoints(): Promise<PointData> {
  return mockPoints;
}
