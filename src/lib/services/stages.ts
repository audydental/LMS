import type { Stage } from '#lib/types/learning';
import { mockStages } from '#lib/mocks/stages';

// Future: replace with Supabase query
// const { data } = await supabase.from('stages').select('*').eq('status', 'active').order('sequence');
export async function getStages(): Promise<Stage[]> {
  await new Promise((r) => setTimeout(r, 300));
  return mockStages
    .filter((stage) => stage.status === 'active')
    .sort((a, b) => a.sequence - b.sequence);
}
