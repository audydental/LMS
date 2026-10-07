-- ============================================================
-- AUDY LEARNING CENTRE — Initial Schema
-- ============================================================

-- ── Extensions ──────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ── updated_at trigger ──────────────────────────────────────
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- ── departments ─────────────────────────────────────────────
CREATE TABLE departments (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name        TEXT NOT NULL,
  description TEXT,
  status      TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','inactive')),
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER departments_updated_at
  BEFORE UPDATE ON departments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ── positions ────────────────────────────────────────────────
CREATE TABLE positions (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          TEXT NOT NULL,
  description   TEXT,
  department_id UUID REFERENCES departments(id) ON DELETE SET NULL,
  status        TEXT NOT NULL DEFAULT 'active' CHECK (status IN ('active','inactive')),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER positions_updated_at
  BEFORE UPDATE ON positions
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ── profiles (linked to auth.users) ─────────────────────────
CREATE TABLE profiles (
  id            UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  employee_id   TEXT UNIQUE,
  full_name     TEXT NOT NULL,
  email         TEXT UNIQUE NOT NULL,
  avatar_url    TEXT,
  department_id UUID REFERENCES departments(id) ON DELETE SET NULL,
  position_id   UUID REFERENCES positions(id) ON DELETE SET NULL,
  role          TEXT NOT NULL DEFAULT 'employee'
                  CHECK (role IN ('employee','admin','super_admin')),
  status        TEXT NOT NULL DEFAULT 'active'
                  CHECK (status IN ('active','inactive')),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE INDEX idx_profiles_email       ON profiles(email);
CREATE INDEX idx_profiles_employee_id ON profiles(employee_id);
CREATE INDEX idx_profiles_department  ON profiles(department_id);
CREATE INDEX idx_profiles_role        ON profiles(role);

-- ── stages ──────────────────────────────────────────────────
CREATE TABLE stages (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  sequence          INTEGER NOT NULL UNIQUE,
  code              TEXT UNIQUE,
  title             TEXT NOT NULL,
  description       TEXT,
  short_description TEXT,
  image_url         TEXT,
  estimated_minutes INTEGER NOT NULL DEFAULT 0,
  point_reward      INTEGER NOT NULL DEFAULT 0,
  status            TEXT NOT NULL DEFAULT 'draft'
                      CHECK (status IN ('draft','published','archived')),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER stages_updated_at
  BEFORE UPDATE ON stages
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE INDEX idx_stages_sequence ON stages(sequence);
CREATE INDEX idx_stages_status   ON stages(status);

-- ── materials ────────────────────────────────────────────────
CREATE TABLE materials (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  stage_id          UUID NOT NULL REFERENCES stages(id) ON DELETE CASCADE,
  sequence          INTEGER NOT NULL,
  title             TEXT NOT NULL,
  description       TEXT,
  content           TEXT,
  content_type      TEXT NOT NULL DEFAULT 'article'
                      CHECK (content_type IN ('video','article','pdf','document','link')),
  estimated_minutes INTEGER NOT NULL DEFAULT 5,
  point_reward      INTEGER NOT NULL DEFAULT 0,
  is_required       BOOLEAN NOT NULL DEFAULT true,
  status            TEXT NOT NULL DEFAULT 'draft'
                      CHECK (status IN ('draft','published','archived')),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(stage_id, sequence)
);

CREATE TRIGGER materials_updated_at
  BEFORE UPDATE ON materials
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE INDEX idx_materials_stage  ON materials(stage_id);
CREATE INDEX idx_materials_status ON materials(status);

-- ── learning_cases ───────────────────────────────────────────
CREATE TABLE learning_cases (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  stage_id          UUID NOT NULL REFERENCES stages(id) ON DELETE CASCADE,
  sequence          INTEGER NOT NULL DEFAULT 1,
  title             TEXT NOT NULL,
  description       TEXT,
  content           TEXT,
  estimated_minutes INTEGER NOT NULL DEFAULT 15,
  point_reward      INTEGER NOT NULL DEFAULT 0,
  is_required       BOOLEAN NOT NULL DEFAULT true,
  status            TEXT NOT NULL DEFAULT 'draft'
                      CHECK (status IN ('draft','published','archived')),
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER learning_cases_updated_at
  BEFORE UPDATE ON learning_cases
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ── material_attachments ─────────────────────────────────────
CREATE TABLE material_attachments (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  material_id  UUID NOT NULL REFERENCES materials(id) ON DELETE CASCADE,
  file_name    TEXT NOT NULL,
  file_path    TEXT NOT NULL,
  mime_type    TEXT,
  file_size_kb INTEGER,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ── user_material_progress ───────────────────────────────────
CREATE TABLE user_material_progress (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  material_id      UUID NOT NULL REFERENCES materials(id) ON DELETE CASCADE,
  status           TEXT NOT NULL DEFAULT 'not_started'
                     CHECK (status IN ('not_started','in_progress','completed')),
  progress_percent INTEGER NOT NULL DEFAULT 0
                     CHECK (progress_percent BETWEEN 0 AND 100),
  started_at       TIMESTAMPTZ,
  completed_at     TIMESTAMPTZ,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, material_id)
);

CREATE TRIGGER user_material_progress_updated_at
  BEFORE UPDATE ON user_material_progress
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE INDEX idx_progress_user     ON user_material_progress(user_id);
CREATE INDEX idx_progress_material ON user_material_progress(material_id);

-- ── user_case_progress ───────────────────────────────────────
CREATE TABLE user_case_progress (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  case_id      UUID NOT NULL REFERENCES learning_cases(id) ON DELETE CASCADE,
  status       TEXT NOT NULL DEFAULT 'not_started'
                 CHECK (status IN ('not_started','in_progress','completed')),
  started_at   TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE(user_id, case_id)
);

CREATE TRIGGER user_case_progress_updated_at
  BEFORE UPDATE ON user_case_progress
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ── point_transactions ───────────────────────────────────────
CREATE TABLE point_transactions (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  source_type TEXT NOT NULL
                CHECK (source_type IN (
                  'material_completion','case_completion',
                  'assessment_completion','bonus','adjustment'
                )),
  source_id   UUID,
  points      INTEGER NOT NULL,
  description TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_points_user ON point_transactions(user_id);

-- ── assessments ──────────────────────────────────────────────
CREATE TABLE assessments (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  stage_id      UUID NOT NULL REFERENCES stages(id) ON DELETE CASCADE,
  title         TEXT NOT NULL,
  description   TEXT,
  passing_score INTEGER NOT NULL DEFAULT 80,
  point_reward  INTEGER NOT NULL DEFAULT 0,
  status        TEXT NOT NULL DEFAULT 'draft'
                  CHECK (status IN ('draft','published','archived')),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TRIGGER assessments_updated_at
  BEFORE UPDATE ON assessments
  FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- ── assessment_questions ─────────────────────────────────────
CREATE TABLE assessment_questions (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  assessment_id   UUID NOT NULL REFERENCES assessments(id) ON DELETE CASCADE,
  question_text   TEXT NOT NULL,
  question_type   TEXT NOT NULL DEFAULT 'single_choice'
                    CHECK (question_type IN ('single_choice','multiple_choice','true_false')),
  sequence        INTEGER NOT NULL DEFAULT 1,
  points          INTEGER NOT NULL DEFAULT 1,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ── assessment_options ───────────────────────────────────────
-- SECURITY: is_correct is NEVER returned to the browser directly.
-- Always query via server-side only. Strip is_correct from employee-facing queries.
CREATE TABLE assessment_options (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  question_id UUID NOT NULL REFERENCES assessment_questions(id) ON DELETE CASCADE,
  option_text TEXT NOT NULL,
  is_correct  BOOLEAN NOT NULL DEFAULT false,
  sequence    INTEGER NOT NULL DEFAULT 1,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ── assessment_attempts ──────────────────────────────────────
CREATE TABLE assessment_attempts (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  assessment_id UUID NOT NULL REFERENCES assessments(id),
  user_id       UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  started_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  submitted_at  TIMESTAMPTZ,
  score         INTEGER,
  status        TEXT NOT NULL DEFAULT 'in_progress'
                  CHECK (status IN ('in_progress','submitted','passed','failed')),
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_attempts_user       ON assessment_attempts(user_id);
CREATE INDEX idx_attempts_assessment ON assessment_attempts(assessment_id);

-- ── assessment_answers ───────────────────────────────────────
CREATE TABLE assessment_answers (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  attempt_id         UUID NOT NULL REFERENCES assessment_attempts(id) ON DELETE CASCADE,
  question_id        UUID NOT NULL REFERENCES assessment_questions(id),
  selected_option_id UUID REFERENCES assessment_options(id),
  is_correct         BOOLEAN,
  points_earned      INTEGER NOT NULL DEFAULT 0,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- ── notifications ────────────────────────────────────────────
CREATE TABLE notifications (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  type       TEXT NOT NULL,
  title      TEXT NOT NULL,
  message    TEXT,
  is_read    BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_notifications_user ON notifications(user_id, is_read);

-- ── audit_logs ───────────────────────────────────────────────
CREATE TABLE audit_logs (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     UUID REFERENCES profiles(id) ON DELETE SET NULL,
  action      TEXT NOT NULL,
  entity_type TEXT,
  entity_id   UUID,
  old_data    JSONB,
  new_data    JSONB,
  ip_address  INET,
  user_agent  TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_audit_user    ON audit_logs(user_id);
CREATE INDEX idx_audit_created ON audit_logs(created_at DESC);

-- ── Function: auto-create profile on signup ──────────────────
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO profiles (id, full_name, email, role)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'role', 'employee')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
