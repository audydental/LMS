import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { mockStages } from '#lib/mocks/stages';
import { mockMaterials } from '#lib/mocks/materials';
import type { Stage } from '#lib/types/learning';
import type { Material } from '#lib/types/learning';

export const GET: RequestHandler = async ({ locals }) => {
  if (!locals.user) {
    return json({ success: false, error: { code: 'UNAUTHORIZED', message: 'Silakan login terlebih dahulu.' } }, { status: 401 });
  }

  try {
    const activeStages: Stage[] = mockStages.filter((s: Stage) => s.status === 'active');
    const totalMaterials = mockMaterials.length;
    const completedMaterials = mockMaterials.filter((m: Material) => m.status === 'completed').length;

    return json({
      success: true,
      data: {
        totalPoint: 50,
        averageScore: 0,
        level: 'Keep Growing',
        completedStages: activeStages.filter((s: Stage) => s.isCompleted).length,
        totalStages: activeStages.length,
        completedMaterials,
        totalMaterials,
        weeklyPointGain: 10
      }
    });
  } catch {
    return json({ success: false, error: { code: 'SERVER_ERROR', message: 'Data belum dapat dimuat.' } }, { status: 500 });
  }
};
