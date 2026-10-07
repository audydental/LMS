import type { FreshUpdate } from '#lib/types/learning';
import { mockFreshUpdates } from '#lib/mocks/freshUpdates';

export async function getFreshUpdates(): Promise<FreshUpdate[]> {
  return mockFreshUpdates;
}
