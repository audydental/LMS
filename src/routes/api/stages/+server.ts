import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { mockStages } from '#lib/mocks/stages';
import type { Stage } from '#lib/types/learning';

export const GET: RequestHandler = async ({ locals }) => {
  if (!locals.user) {
    return json({ success: false, error: { code: 'UNAUTHORIZED', message: 'Authentication required.' } }, { status: 401 });
  }

  try {
    const stages: Stage[] = mockStages
      .filter((s: Stage) => s.status === 'active')
      .sort((a: Stage, b: Stage) => a.sequence - b.sequence);

    return json({ success: true, data: stages });
  } catch {
    return json({ success: false, error: { code: 'SERVER_ERROR', message: 'Gagal memuat stage.' } }, { status: 500 });
  }
};
