import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { mockMaterials } from '#lib/mocks/materials';
import type { Material } from '#lib/types/learning';

export const POST: RequestHandler = async ({ params, locals }) => {
  if (!locals.user) {
    return json({ success: false, error: { code: 'UNAUTHORIZED', message: 'Authentication required.' } }, { status: 401 });
  }

  const { materialId } = params;
  const material: Material | undefined = mockMaterials.find((m: Material) => m.id === materialId);

  if (!material) {
    return json({ success: false, error: { code: 'NOT_FOUND', message: 'Materi tidak ditemukan.' } }, { status: 404 });
  }

  try {
    /**
     * PRODUCTION: upsert user_material_progress, insert point_transaction,
     * create notification — all in a transaction-safe manner.
     * Duplicate point protection: check if status already 'completed' before awarding.
     */
    return json({
      success: true,
      data: {
        materialId,
        status: 'completed',
        pointsAwarded: material.status === 'completed' ? 0 : material.pointReward,
        alreadyCompleted: material.status === 'completed',
        message: material.status === 'completed'
          ? 'Materi sudah selesai sebelumnya.'
          : `+${material.pointReward} point berhasil ditambahkan!`
      }
    });
  } catch {
    return json({ success: false, error: { code: 'SERVER_ERROR', message: 'Gagal menyimpan progress.' } }, { status: 500 });
  }
};
