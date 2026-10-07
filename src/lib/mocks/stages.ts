import type { Stage } from '#lib/types/learning';

// Using picsum.photos with fixed seeds — reliable for local dev, no CORS issues.
// Seeds chosen to give clean, professional-looking photos.
export const mockStages: Stage[] = [
  {
    id: 'stage-001',
    sequence: 1,
    title: 'Start Your Journey',
    subtitle: 'Fondasi Karier di Audy',
    description: 'Kenali peranmu. Tumbuhkan fondasi dasar dalam pelayanan klinik gigi.',
    image: 'https://picsum.photos/seed/dental1/600/300',
    isActive: true,
    isCompleted: false,
    progress: 0,
    totalMaterials: 5,
    completedMaterials: 0,
    pointReward: 100,
    status: 'active'
  },
  {
    id: 'stage-002',
    sequence: 2,
    title: 'Level Up Your Role',
    subtitle: 'Tingkatkan Kompetensi Peranmu',
    description: 'Pahami cara kerjanya untuk meningkatkan kualitas layanan dan kolaborasi tim.',
    image: 'https://picsum.photos/seed/dental2/600/300',
    isActive: false,
    isCompleted: false,
    progress: 0,
    totalMaterials: 5,
    completedMaterials: 0,
    pointReward: 150,
    status: 'active'
  },
  {
    id: 'stage-003',
    sequence: 3,
    title: 'The Real Power Team',
    subtitle: 'Kolaborasi & Kepemimpinan Tim',
    description: 'Proud to be part of Audy Dental Group. Kolaborasi, leadership, dan kontribusi nyata.',
    image: 'https://picsum.photos/seed/dental3/600/300',
    isActive: false,
    isCompleted: false,
    progress: 0,
    totalMaterials: 5,
    completedMaterials: 0,
    pointReward: 200,
    status: 'active'
  },
  {
    id: 'stage-004',
    sequence: 4,
    title: 'Leadership Excellence',
    subtitle: 'Memimpin dengan Dampak',
    description: 'Kembangkan kemampuan kepemimpinan dan siap menjadi agen perubahan.',
    image: 'https://picsum.photos/seed/dental4/600/300',
    isActive: false,
    isCompleted: false,
    progress: 0,
    totalMaterials: 5,
    completedMaterials: 0,
    pointReward: 250,
    status: 'active'
  }
];
