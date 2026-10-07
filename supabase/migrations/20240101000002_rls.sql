-- ============================================================
-- AUDY LEARNING CENTRE — Row Level Security Policies
-- ============================================================

-- Enable RLS on all application tables
ALTER TABLE profiles              ENABLE ROW LEVEL SECURITY;
ALTER TABLE departments           ENABLE ROW LEVEL SECURITY;
ALTER TABLE positions             ENABLE ROW LEVEL SECURITY;
ALTER TABLE stages                ENABLE ROW LEVEL SECURITY;
ALTER TABLE materials             ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_cases        ENABLE ROW LEVEL SECURITY;
ALTER TABLE material_attachments  ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_material_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_case_progress    ENABLE ROW LEVEL SECURITY;
ALTER TABLE point_transactions    ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessments           ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessment_questions  ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessment_options    ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessment_attempts   ENABLE ROW LEVEL SECURITY;
ALTER TABLE assessment_answers    ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications         ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs            ENABLE ROW LEVEL SECURITY;

-- ── Helper: check if calling user is admin ───────────────────
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM profiles
    WHERE id = auth.uid()
    AND role IN ('admin','super_admin')
    AND status = 'active'
  );
$$ LANGUAGE sql SECURITY DEFINER STABLE;

-- ── profiles ─────────────────────────────────────────────────
CREATE POLICY "profiles_select_own"
  ON profiles FOR SELECT
  USING (auth.uid() = id OR is_admin());

CREATE POLICY "profiles_update_own"
  ON profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (
    auth.uid() = id
    -- Prevent self-elevation: role must remain unchanged unless admin
    AND (role = (SELECT role FROM profiles WHERE id = auth.uid()) OR is_admin())
  );

CREATE POLICY "profiles_admin_all"
  ON profiles FOR ALL
  USING (is_admin());

-- ── departments & positions — all authenticated can read ─────
CREATE POLICY "departments_read"
  ON departments FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "departments_admin"
  ON departments FOR ALL USING (is_admin());

CREATE POLICY "positions_read"
  ON positions FOR SELECT USING (auth.uid() IS NOT NULL);

CREATE POLICY "positions_admin"
  ON positions FOR ALL USING (is_admin());

-- ── stages — employees see published; admins see all ─────────
CREATE POLICY "stages_read_published"
  ON stages FOR SELECT
  USING (
    (status = 'published' AND auth.uid() IS NOT NULL)
    OR is_admin()
  );

CREATE POLICY "stages_admin_write"
  ON stages FOR INSERT UPDATE DELETE
  USING (is_admin());

-- ── materials ────────────────────────────────────────────────
CREATE POLICY "materials_read_published"
  ON materials FOR SELECT
  USING (
    (status = 'published' AND auth.uid() IS NOT NULL)
    OR is_admin()
  );

CREATE POLICY "materials_admin_write"
  ON materials FOR INSERT UPDATE DELETE
  USING (is_admin());

-- ── learning_cases ───────────────────────────────────────────
CREATE POLICY "cases_read_published"
  ON learning_cases FOR SELECT
  USING (
    (status = 'published' AND auth.uid() IS NOT NULL)
    OR is_admin()
  );

CREATE POLICY "cases_admin_write"
  ON learning_cases FOR INSERT UPDATE DELETE
  USING (is_admin());

-- ── material_attachments — read if related material published ─
CREATE POLICY "attachments_read"
  ON material_attachments FOR SELECT
  USING (
    is_admin()
    OR EXISTS (
      SELECT 1 FROM materials
      WHERE id = material_id AND status = 'published'
    )
  );

CREATE POLICY "attachments_admin_write"
  ON material_attachments FOR INSERT UPDATE DELETE
  USING (is_admin());

-- ── user_material_progress — own rows only ───────────────────
CREATE POLICY "progress_own"
  ON user_material_progress FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "progress_admin_read"
  ON user_material_progress FOR SELECT
  USING (is_admin());

-- ── user_case_progress ───────────────────────────────────────
CREATE POLICY "case_progress_own"
  ON user_case_progress FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "case_progress_admin_read"
  ON user_case_progress FOR SELECT
  USING (is_admin());

-- ── point_transactions — read own; admins read all ───────────
CREATE POLICY "points_read_own"
  ON point_transactions FOR SELECT
  USING (auth.uid() = user_id OR is_admin());

-- Points are only inserted server-side (no direct client INSERT policy)

-- ── assessments ──────────────────────────────────────────────
CREATE POLICY "assessments_read_published"
  ON assessments FOR SELECT
  USING (
    (status = 'published' AND auth.uid() IS NOT NULL)
    OR is_admin()
  );

CREATE POLICY "assessments_admin_write"
  ON assessments FOR INSERT UPDATE DELETE
  USING (is_admin());

-- ── assessment_questions ─────────────────────────────────────
CREATE POLICY "questions_read"
  ON assessment_questions FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "questions_admin_write"
  ON assessment_questions FOR INSERT UPDATE DELETE
  USING (is_admin());

-- ── assessment_options ───────────────────────────────────────
-- SECURITY NOTE: is_correct field is stripped at the API layer, not here.
-- RLS allows authenticated reads; the server-side API omits is_correct.
CREATE POLICY "options_read"
  ON assessment_options FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "options_admin_write"
  ON assessment_options FOR INSERT UPDATE DELETE
  USING (is_admin());

-- ── assessment_attempts — own rows only ──────────────────────
CREATE POLICY "attempts_own"
  ON assessment_attempts FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "attempts_admin_read"
  ON assessment_attempts FOR SELECT
  USING (is_admin());

-- ── assessment_answers — via own attempts ────────────────────
CREATE POLICY "answers_own"
  ON assessment_answers FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM assessment_attempts
      WHERE id = attempt_id AND user_id = auth.uid()
    )
  );

CREATE POLICY "answers_admin_read"
  ON assessment_answers FOR SELECT
  USING (is_admin());

-- ── notifications — own only ─────────────────────────────────
CREATE POLICY "notifications_own"
  ON notifications FOR ALL
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ── audit_logs — admins only ─────────────────────────────────
CREATE POLICY "audit_admin_read"
  ON audit_logs FOR SELECT
  USING (is_admin());
