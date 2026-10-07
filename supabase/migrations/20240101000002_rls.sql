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
    AND (role = (SELECT role FROM profiles WHERE id = auth.uid()) OR is_admin())
  );

CREATE POLICY "profiles_admin_insert"
  ON profiles FOR INSERT
  WITH CHECK (is_admin());

CREATE POLICY "profiles_admin_delete"
  ON profiles FOR DELETE
  USING (is_admin());

-- ── departments ──────────────────────────────────────────────
CREATE POLICY "departments_select"
  ON departments FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "departments_admin_insert"
  ON departments FOR INSERT
  WITH CHECK (is_admin());

CREATE POLICY "departments_admin_update"
  ON departments FOR UPDATE
  USING (is_admin());

CREATE POLICY "departments_admin_delete"
  ON departments FOR DELETE
  USING (is_admin());

-- ── positions ────────────────────────────────────────────────
CREATE POLICY "positions_select"
  ON positions FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "positions_admin_insert"
  ON positions FOR INSERT
  WITH CHECK (is_admin());

CREATE POLICY "positions_admin_update"
  ON positions FOR UPDATE
  USING (is_admin());

CREATE POLICY "positions_admin_delete"
  ON positions FOR DELETE
  USING (is_admin());

-- ── stages ───────────────────────────────────────────────────
CREATE POLICY "stages_select_published"
  ON stages FOR SELECT
  USING (
    (status = 'published' AND auth.uid() IS NOT NULL)
    OR is_admin()
  );

CREATE POLICY "stages_admin_insert"
  ON stages FOR INSERT
  WITH CHECK (is_admin());

CREATE POLICY "stages_admin_update"
  ON stages FOR UPDATE
  USING (is_admin());

CREATE POLICY "stages_admin_delete"
  ON stages FOR DELETE
  USING (is_admin());

-- ── materials ────────────────────────────────────────────────
CREATE POLICY "materials_select_published"
  ON materials FOR SELECT
  USING (
    (status = 'published' AND auth.uid() IS NOT NULL)
    OR is_admin()
  );

CREATE POLICY "materials_admin_insert"
  ON materials FOR INSERT
  WITH CHECK (is_admin());

CREATE POLICY "materials_admin_update"
  ON materials FOR UPDATE
  USING (is_admin());

CREATE POLICY "materials_admin_delete"
  ON materials FOR DELETE
  USING (is_admin());

-- ── learning_cases ───────────────────────────────────────────
CREATE POLICY "cases_select_published"
  ON learning_cases FOR SELECT
  USING (
    (status = 'published' AND auth.uid() IS NOT NULL)
    OR is_admin()
  );

CREATE POLICY "cases_admin_insert"
  ON learning_cases FOR INSERT
  WITH CHECK (is_admin());

CREATE POLICY "cases_admin_update"
  ON learning_cases FOR UPDATE
  USING (is_admin());

CREATE POLICY "cases_admin_delete"
  ON learning_cases FOR DELETE
  USING (is_admin());

-- ── material_attachments ─────────────────────────────────────
CREATE POLICY "attachments_select"
  ON material_attachments FOR SELECT
  USING (
    is_admin()
    OR EXISTS (
      SELECT 1 FROM materials
      WHERE id = material_id AND status = 'published'
    )
  );

CREATE POLICY "attachments_admin_insert"
  ON material_attachments FOR INSERT
  WITH CHECK (is_admin());

CREATE POLICY "attachments_admin_update"
  ON material_attachments FOR UPDATE
  USING (is_admin());

CREATE POLICY "attachments_admin_delete"
  ON material_attachments FOR DELETE
  USING (is_admin());

-- ── user_material_progress ───────────────────────────────────
CREATE POLICY "progress_select"
  ON user_material_progress FOR SELECT
  USING (auth.uid() = user_id OR is_admin());

CREATE POLICY "progress_insert"
  ON user_material_progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "progress_update"
  ON user_material_progress FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "progress_delete"
  ON user_material_progress FOR DELETE
  USING (auth.uid() = user_id);

-- ── user_case_progress ───────────────────────────────────────
CREATE POLICY "case_progress_select"
  ON user_case_progress FOR SELECT
  USING (auth.uid() = user_id OR is_admin());

CREATE POLICY "case_progress_insert"
  ON user_case_progress FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "case_progress_update"
  ON user_case_progress FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "case_progress_delete"
  ON user_case_progress FOR DELETE
  USING (auth.uid() = user_id);

-- ── point_transactions ───────────────────────────────────────
-- Read own or admin; insert only via server (no direct client insert)
CREATE POLICY "points_select"
  ON point_transactions FOR SELECT
  USING (auth.uid() = user_id OR is_admin());

-- ── assessments ──────────────────────────────────────────────
CREATE POLICY "assessments_select_published"
  ON assessments FOR SELECT
  USING (
    (status = 'published' AND auth.uid() IS NOT NULL)
    OR is_admin()
  );

CREATE POLICY "assessments_admin_insert"
  ON assessments FOR INSERT
  WITH CHECK (is_admin());

CREATE POLICY "assessments_admin_update"
  ON assessments FOR UPDATE
  USING (is_admin());

CREATE POLICY "assessments_admin_delete"
  ON assessments FOR DELETE
  USING (is_admin());

-- ── assessment_questions ─────────────────────────────────────
CREATE POLICY "questions_select"
  ON assessment_questions FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "questions_admin_insert"
  ON assessment_questions FOR INSERT
  WITH CHECK (is_admin());

CREATE POLICY "questions_admin_update"
  ON assessment_questions FOR UPDATE
  USING (is_admin());

CREATE POLICY "questions_admin_delete"
  ON assessment_questions FOR DELETE
  USING (is_admin());

-- ── assessment_options ───────────────────────────────────────
-- SECURITY NOTE: is_correct is NEVER returned to browser — stripped at API layer
CREATE POLICY "options_select"
  ON assessment_options FOR SELECT
  USING (auth.uid() IS NOT NULL);

CREATE POLICY "options_admin_insert"
  ON assessment_options FOR INSERT
  WITH CHECK (is_admin());

CREATE POLICY "options_admin_update"
  ON assessment_options FOR UPDATE
  USING (is_admin());

CREATE POLICY "options_admin_delete"
  ON assessment_options FOR DELETE
  USING (is_admin());

-- ── assessment_attempts ──────────────────────────────────────
CREATE POLICY "attempts_select"
  ON assessment_attempts FOR SELECT
  USING (auth.uid() = user_id OR is_admin());

CREATE POLICY "attempts_insert"
  ON assessment_attempts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "attempts_update"
  ON assessment_attempts FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- ── assessment_answers ───────────────────────────────────────
CREATE POLICY "answers_select"
  ON assessment_answers FOR SELECT
  USING (
    is_admin()
    OR EXISTS (
      SELECT 1 FROM assessment_attempts
      WHERE id = attempt_id AND user_id = auth.uid()
    )
  );

CREATE POLICY "answers_insert"
  ON assessment_answers FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM assessment_attempts
      WHERE id = attempt_id AND user_id = auth.uid()
    )
  );

-- ── notifications ────────────────────────────────────────────
CREATE POLICY "notifications_select"
  ON notifications FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "notifications_insert"
  ON notifications FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "notifications_update"
  ON notifications FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "notifications_delete"
  ON notifications FOR DELETE
  USING (auth.uid() = user_id);

-- ── audit_logs ───────────────────────────────────────────────
-- Admins can read; inserts happen server-side only
CREATE POLICY "audit_admin_select"
  ON audit_logs FOR SELECT
  USING (is_admin());
