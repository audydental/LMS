import { json } from '@sveltejs/kit';
import type { RequestHandler } from './$types';

const mockNotifications = [
  { id: '1', type: 'material_completed', title: 'Materi selesai!', message: 'Kamu telah menyelesaikan Greeting & Patient Communication. +10 point!', is_read: false, created_at: new Date().toISOString() },
  { id: '2', type: 'stage_available', title: 'Stage baru tersedia', message: 'Level Up Your Role sekarang tersedia untuk kamu pelajari.', is_read: true, created_at: new Date(Date.now() - 86400000).toISOString() }
];

export const GET: RequestHandler = async ({ locals }) => {
  if (!locals.user) {
    return json({ success: false, error: { code: 'UNAUTHORIZED', message: 'Authentication required.' } }, { status: 401 });
  }

  // Production: query Supabase notifications for locals.user.id
  return json({ success: true, data: mockNotifications });
};
