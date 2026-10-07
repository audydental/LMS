import type { Recommendation } from '#lib/types/learning';

export const mockRecommendations: Recommendation[] = [
  {
    id: 'rec-001',
    title: 'Pengenalan Audy Dental',
    subtitle: 'Stage 1 · 8 menit',
    category: 'Stage 1',
    durationMinutes: 8,
    difficulty: 'beginner',
    thumbnailColor: '#EFF4FC'
  },
  {
    id: 'rec-002',
    title: 'Standar Pelayanan Pasien',
    subtitle: 'Stage 1 · 10 menit',
    category: 'Stage 1',
    durationMinutes: 10,
    difficulty: 'beginner',
    thumbnailColor: '#EBF3FE'
  },
  {
    id: 'rec-003',
    title: 'Sterilisasi Alat Klinik',
    subtitle: 'Stage 2 · 12 menit',
    category: 'Stage 2',
    durationMinutes: 12,
    difficulty: 'intermediate',
    thumbnailColor: '#FEF6E8'
  }
];
