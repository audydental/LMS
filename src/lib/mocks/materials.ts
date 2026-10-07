import type { Material } from '#lib/types/learning';

export const mockMaterials: Material[] = [
  // Stage 1 — Start Your Journey
  { id: 'mat-101', stageId: 'stage-001', title: 'Greeting & Patient Communication', description: 'Pelajari cara menyambut pasien dengan hangat dan profesional.', estimatedMinutes: 8, pointReward: 10, sequence: 1, status: 'available' },
  { id: 'mat-102', stageId: 'stage-001', title: 'Patient Registration', description: 'Proses pendaftaran pasien baru dan lama secara efisien.', estimatedMinutes: 10, pointReward: 10, sequence: 2, status: 'available' },
  { id: 'mat-103', stageId: 'stage-001', title: 'Clinic Opening SOP', description: 'Standar prosedur pembukaan klinik setiap hari.', estimatedMinutes: 12, pointReward: 10, sequence: 3, status: 'available' },
  { id: 'mat-104', stageId: 'stage-001', title: 'Patient Service Standards', description: 'Standar pelayanan pasien Audy Dental Group.', estimatedMinutes: 10, pointReward: 10, sequence: 4, status: 'available' },
  { id: 'mat-105', stageId: 'stage-001', title: 'Basic Clinic Workflow', description: 'Alur kerja dasar klinik dari buka hingga tutup.', estimatedMinutes: 12, pointReward: 10, sequence: 5, status: 'available' },

  // Stage 2 — Level Up Your Role
  { id: 'mat-201', stageId: 'stage-002', title: 'Professional Communication', description: 'Komunikasi profesional dengan pasien dan rekan kerja.', estimatedMinutes: 10, pointReward: 15, sequence: 1, status: 'available' },
  { id: 'mat-202', stageId: 'stage-002', title: 'Handling Patient Concerns', description: 'Teknik menangani keluhan dan kekhawatiran pasien.', estimatedMinutes: 12, pointReward: 15, sequence: 2, status: 'available' },
  { id: 'mat-203', stageId: 'stage-002', title: 'Cross Department Collaboration', description: 'Kolaborasi efektif antar departemen di klinik.', estimatedMinutes: 10, pointReward: 15, sequence: 3, status: 'available' },
  { id: 'mat-204', stageId: 'stage-002', title: 'Service Quality', description: 'Standar kualitas layanan Audy Dental Group.', estimatedMinutes: 12, pointReward: 15, sequence: 4, status: 'available' },
  { id: 'mat-205', stageId: 'stage-002', title: 'Problem Solving', description: 'Pendekatan sistematis dalam menyelesaikan masalah.', estimatedMinutes: 15, pointReward: 15, sequence: 5, status: 'available' },

  // Stage 3 — The Real Power Team
  { id: 'mat-301', stageId: 'stage-003', title: 'Team Collaboration', description: 'Membangun sinergi tim yang kuat dan produktif.', estimatedMinutes: 12, pointReward: 20, sequence: 1, status: 'available' },
  { id: 'mat-302', stageId: 'stage-003', title: 'Leadership Fundamentals', description: 'Dasar-dasar kepemimpinan di lingkungan klinik.', estimatedMinutes: 15, pointReward: 20, sequence: 2, status: 'available' },
  { id: 'mat-303', stageId: 'stage-003', title: 'Performance Ownership', description: 'Memiliki rasa tanggung jawab atas performa kerja.', estimatedMinutes: 15, pointReward: 20, sequence: 3, status: 'available' },
  { id: 'mat-304', stageId: 'stage-003', title: 'Advanced Patient Experience', description: 'Menciptakan pengalaman pasien yang luar biasa.', estimatedMinutes: 15, pointReward: 20, sequence: 4, status: 'available' },
  { id: 'mat-305', stageId: 'stage-003', title: 'Continuous Improvement', description: 'Budaya kaizen dan peningkatan berkelanjutan.', estimatedMinutes: 15, pointReward: 20, sequence: 5, status: 'available' },

  // Stage 4 — Leadership Excellence
  { id: 'mat-401', stageId: 'stage-004', title: 'Strategic Leadership', description: 'Kepemimpinan strategis untuk pertumbuhan tim.', estimatedMinutes: 15, pointReward: 25, sequence: 1, status: 'available' },
  { id: 'mat-402', stageId: 'stage-004', title: 'Coaching & Mentoring', description: 'Teknik coaching dan mentoring untuk pengembangan tim.', estimatedMinutes: 20, pointReward: 25, sequence: 2, status: 'available' },
  { id: 'mat-403', stageId: 'stage-004', title: 'Change Management', description: 'Mengelola perubahan organisasi dengan efektif.', estimatedMinutes: 18, pointReward: 25, sequence: 3, status: 'available' },
  { id: 'mat-404', stageId: 'stage-004', title: 'Decision Making', description: 'Pengambilan keputusan berbasis data dan intuisi.', estimatedMinutes: 15, pointReward: 25, sequence: 4, status: 'available' },
  { id: 'mat-405', stageId: 'stage-004', title: 'Building High Performance Teams', description: 'Membangun tim berperforma tinggi di Audy Dental.', estimatedMinutes: 20, pointReward: 25, sequence: 5, status: 'available' },
];
