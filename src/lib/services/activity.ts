import type { ActivityDay } from '#lib/types/learning';
import { mockWeeklyActivity } from '#lib/mocks/activity';

export async function getWeeklyActivity(): Promise<ActivityDay[]> {
  return mockWeeklyActivity;
}
