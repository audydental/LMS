-- ============================================================
-- AUDY LEARNING CENTRE — Development Seed Data
-- WARNING: DO NOT run against production database.
-- ============================================================

-- Departments
INSERT INTO departments (id, name, description) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Head Office', 'Kantor pusat Audy Dental Group'),
  ('00000000-0000-0000-0000-000000000002', 'Klinik Utama', 'Klinik gigi utama'),
  ('00000000-0000-0000-0000-000000000003', 'Operasional', 'Tim operasional dan support')
ON CONFLICT (id) DO NOTHING;

-- Positions
INSERT INTO positions (id, name, department_id) VALUES
  ('00000000-0000-0000-0001-000000000001', 'Front Office', '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0001-000000000002', 'Dokter Gigi', '00000000-0000-0000-0000-000000000002'),
  ('00000000-0000-0000-0001-000000000003', 'Perawat Gigi', '00000000-0000-0000-0000-000000000002'),
  ('00000000-0000-0000-0001-000000000004', 'Manajer Klinik', '00000000-0000-0000-0000-000000000002'),
  ('00000000-0000-0000-0001-000000000005', 'HRD', '00000000-0000-0000-0000-000000000001')
ON CONFLICT (id) DO NOTHING;

-- Stages
INSERT INTO stages (id, sequence, code, title, short_description, description, image_url, estimated_minutes, point_reward, status) VALUES
  ('10000000-0000-0000-0000-000000000001', 1, 'STAGE-01', 'Start Your Journey',
   'Fondasi Karier di Audy',
   'Kenali peranmu. Tumbuhkan fondasi dasar dalam pelayanan klinik gigi.',
   'https://picsum.photos/seed/dental1/600/300', 52, 100, 'published'),
  ('10000000-0000-0000-0000-000000000002', 2, 'STAGE-02', 'Level Up Your Role',
   'Tingkatkan Kompetensi Peranmu',
   'Pahami cara kerjanya untuk meningkatkan kualitas layanan dan kolaborasi tim.',
   'https://picsum.photos/seed/dental2/600/300', 59, 150, 'published'),
  ('10000000-0000-0000-0000-000000000003', 3, 'STAGE-03', 'The Real Power Team',
   'Kolaborasi & Kepemimpinan Tim',
   'Proud to be part of Audy Dental Group. Kolaborasi, leadership, dan kontribusi nyata.',
   'https://picsum.photos/seed/dental3/600/300', 72, 200, 'published'),
  ('10000000-0000-0000-0000-000000000004', 4, 'STAGE-04', 'Leadership Excellence',
   'Memimpin dengan Dampak',
   'Kembangkan kemampuan kepemimpinan dan siap menjadi agen perubahan.',
   'https://picsum.photos/seed/dental4/600/300', 88, 250, 'published')
ON CONFLICT (id) DO NOTHING;

-- Materials — Stage 1
INSERT INTO materials (id, stage_id, sequence, title, description, content_type, estimated_minutes, point_reward, status) VALUES
  ('20000000-0000-0000-0000-000000000101', '10000000-0000-0000-0000-000000000001', 1, 'Greeting & Patient Communication', 'Pelajari cara menyambut pasien dengan hangat dan profesional.', 'article', 8, 10, 'published'),
  ('20000000-0000-0000-0000-000000000102', '10000000-0000-0000-0000-000000000001', 2, 'Patient Registration', 'Proses pendaftaran pasien baru dan lama secara efisien.', 'article', 10, 10, 'published'),
  ('20000000-0000-0000-0000-000000000103', '10000000-0000-0000-0000-000000000001', 3, 'Clinic Opening SOP', 'Standar prosedur pembukaan klinik setiap hari.', 'article', 12, 10, 'published'),
  ('20000000-0000-0000-0000-000000000104', '10000000-0000-0000-0000-000000000001', 4, 'Patient Service Standards', 'Standar pelayanan pasien Audy Dental Group.', 'article', 10, 10, 'published'),
  ('20000000-0000-0000-0000-000000000105', '10000000-0000-0000-0000-000000000001', 5, 'Basic Clinic Workflow', 'Alur kerja dasar klinik dari buka hingga tutup.', 'article', 12, 10, 'published')
ON CONFLICT (id) DO NOTHING;

-- Materials — Stage 2
INSERT INTO materials (id, stage_id, sequence, title, description, content_type, estimated_minutes, point_reward, status) VALUES
  ('20000000-0000-0000-0000-000000000201', '10000000-0000-0000-0000-000000000002', 1, 'Professional Communication', 'Komunikasi profesional dengan pasien dan rekan kerja.', 'article', 10, 15, 'published'),
  ('20000000-0000-0000-0000-000000000202', '10000000-0000-0000-0000-000000000002', 2, 'Handling Patient Concerns', 'Teknik menangani keluhan dan kekhawatiran pasien.', 'article', 12, 15, 'published'),
  ('20000000-0000-0000-0000-000000000203', '10000000-0000-0000-0000-000000000002', 3, 'Cross Department Collaboration', 'Kolaborasi efektif antar departemen di klinik.', 'article', 10, 15, 'published'),
  ('20000000-0000-0000-0000-000000000204', '10000000-0000-0000-0000-000000000002', 4, 'Service Quality', 'Standar kualitas layanan Audy Dental Group.', 'article', 12, 15, 'published'),
  ('20000000-0000-0000-0000-000000000205', '10000000-0000-0000-0000-000000000002', 5, 'Problem Solving', 'Pendekatan sistematis dalam menyelesaikan masalah.', 'article', 15, 15, 'published')
ON CONFLICT (id) DO NOTHING;

-- Materials — Stage 3
INSERT INTO materials (id, stage_id, sequence, title, description, content_type, estimated_minutes, point_reward, status) VALUES
  ('20000000-0000-0000-0000-000000000301', '10000000-0000-0000-0000-000000000003', 1, 'Team Collaboration', 'Membangun sinergi tim yang kuat dan produktif.', 'article', 12, 20, 'published'),
  ('20000000-0000-0000-0000-000000000302', '10000000-0000-0000-0000-000000000003', 2, 'Leadership Fundamentals', 'Dasar-dasar kepemimpinan di lingkungan klinik.', 'article', 15, 20, 'published'),
  ('20000000-0000-0000-0000-000000000303', '10000000-0000-0000-0000-000000000003', 3, 'Performance Ownership', 'Memiliki rasa tanggung jawab atas performa kerja.', 'article', 15, 20, 'published'),
  ('20000000-0000-0000-0000-000000000304', '10000000-0000-0000-0000-000000000003', 4, 'Advanced Patient Experience', 'Menciptakan pengalaman pasien yang luar biasa.', 'article', 15, 20, 'published'),
  ('20000000-0000-0000-0000-000000000305', '10000000-0000-0000-0000-000000000003', 5, 'Continuous Improvement', 'Budaya kaizen dan peningkatan berkelanjutan.', 'article', 15, 20, 'published')
ON CONFLICT (id) DO NOTHING;

-- Materials — Stage 4
INSERT INTO materials (id, stage_id, sequence, title, description, content_type, estimated_minutes, point_reward, status) VALUES
  ('20000000-0000-0000-0000-000000000401', '10000000-0000-0000-0000-000000000004', 1, 'Strategic Leadership', 'Kepemimpinan strategis untuk pertumbuhan tim.', 'article', 15, 25, 'published'),
  ('20000000-0000-0000-0000-000000000402', '10000000-0000-0000-0000-000000000004', 2, 'Coaching & Mentoring', 'Teknik coaching dan mentoring untuk pengembangan tim.', 'article', 20, 25, 'published'),
  ('20000000-0000-0000-0000-000000000403', '10000000-0000-0000-0000-000000000004', 3, 'Change Management', 'Mengelola perubahan organisasi dengan efektif.', 'article', 18, 25, 'published'),
  ('20000000-0000-0000-0000-000000000404', '10000000-0000-0000-0000-000000000004', 4, 'Decision Making', 'Pengambilan keputusan berbasis data dan intuisi.', 'article', 15, 25, 'published'),
  ('20000000-0000-0000-0000-000000000405', '10000000-0000-0000-0000-000000000004', 5, 'Building High Performance Teams', 'Membangun tim berperforma tinggi di Audy Dental.', 'article', 20, 25, 'published')
ON CONFLICT (id) DO NOTHING;

-- Assessment — Stage 1
INSERT INTO assessments (id, stage_id, title, passing_score, point_reward, status) VALUES
  ('30000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', 'Kuis Stage 1 — Start Your Journey', 80, 20, 'published')
ON CONFLICT (id) DO NOTHING;

INSERT INTO assessment_questions (id, assessment_id, question_text, question_type, sequence, points) VALUES
  ('40000000-0000-0000-0000-000000000001', '30000000-0000-0000-0000-000000000001', 'Apa yang harus dilakukan saat menyambut pasien baru?', 'single_choice', 1, 20),
  ('40000000-0000-0000-0000-000000000002', '30000000-0000-0000-0000-000000000001', 'Dalam berapa detik kesan pertama terbentuk?', 'single_choice', 2, 20),
  ('40000000-0000-0000-0000-000000000003', '30000000-0000-0000-0000-000000000001', 'SOP adalah singkatan dari?', 'single_choice', 3, 20),
  ('40000000-0000-0000-0000-000000000004', '30000000-0000-0000-0000-000000000001', 'Senyum termasuk komunikasi non-verbal.', 'true_false', 4, 20),
  ('40000000-0000-0000-0000-000000000005', '30000000-0000-0000-0000-000000000001', 'Langkah pertama alur kerja klinik adalah?', 'single_choice', 5, 20)
ON CONFLICT (id) DO NOTHING;

INSERT INTO assessment_options (id, question_id, option_text, is_correct, sequence) VALUES
  ('50000000-0000-0000-0001-000000000001', '40000000-0000-0000-0000-000000000001', 'Menyapa dengan senyum dan salam hangat', true,  1),
  ('50000000-0000-0000-0001-000000000002', '40000000-0000-0000-0000-000000000001', 'Langsung meminta kartu identitas', false, 2),
  ('50000000-0000-0000-0001-000000000003', '40000000-0000-0000-0000-000000000001', 'Mengarahkan ke kursi tanpa berbicara', false, 3),
  ('50000000-0000-0000-0002-000000000001', '40000000-0000-0000-0000-000000000002', '7 detik', true,  1),
  ('50000000-0000-0000-0002-000000000002', '40000000-0000-0000-0000-000000000002', '30 detik', false, 2),
  ('50000000-0000-0000-0002-000000000003', '40000000-0000-0000-0000-000000000002', '1 menit', false, 3),
  ('50000000-0000-0000-0003-000000000001', '40000000-0000-0000-0000-000000000003', 'Standard Operating Procedure', true,  1),
  ('50000000-0000-0000-0003-000000000002', '40000000-0000-0000-0000-000000000003', 'Standard Office Protocol', false, 2),
  ('50000000-0000-0000-0003-000000000003', '40000000-0000-0000-0000-000000000003', 'Service Operations Plan', false, 3),
  ('50000000-0000-0000-0004-000000000001', '40000000-0000-0000-0000-000000000004', 'Benar', true,  1),
  ('50000000-0000-0000-0004-000000000002', '40000000-0000-0000-0000-000000000004', 'Salah', false, 2),
  ('50000000-0000-0000-0005-000000000001', '40000000-0000-0000-0000-000000000005', 'Pembukaan klinik dan persiapan', true,  1),
  ('50000000-0000-0000-0005-000000000002', '40000000-0000-0000-0000-000000000005', 'Menutup klinik', false, 2),
  ('50000000-0000-0000-0005-000000000003', '40000000-0000-0000-0000-000000000005', 'Pembayaran pasien', false, 3)
ON CONFLICT (id) DO NOTHING;

-- Learning Case — Stage 1
INSERT INTO learning_cases (id, stage_id, sequence, title, description, estimated_minutes, point_reward, status) VALUES
  ('60000000-0000-0000-0000-000000000001', '10000000-0000-0000-0000-000000000001', 1,
   'Kasus: Pasien Tidak Sabar',
   'Pasien mengeluh sudah menunggu 30 menit dan ingin pulang. Bagaimana kamu menanganinya dengan profesional sambil tetap menjaga kepuasan pasien?',
   15, 20, 'published')
ON CONFLICT (id) DO NOTHING;
