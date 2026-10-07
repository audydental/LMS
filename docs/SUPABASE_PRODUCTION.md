# Supabase Production Setup

## 1. Create a Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in.
2. Click **New Project**.
3. Fill in: Project name (`audy-learning-centre`), Database password (save it securely), Region (closest to users).
4. Wait ~2 minutes for the project to initialize.

## 2. Get Your Credentials

Go to **Project Settings → API**:
- `Project URL` → `PUBLIC_SUPABASE_URL`
- `anon (public)` → `PUBLIC_SUPABASE_PUBLISHABLE_KEY`
- `service_role` → Keep secret, server-only, never expose

## 3. Run Database Migrations

Using Supabase CLI:

```bash
# Install Supabase CLI
npm install -g supabase

# Link to your project
supabase login
supabase link --project-ref YOUR_PROJECT_REF

# Push migrations to production
supabase db push
```

Or manually via Supabase SQL Editor:
1. Go to **SQL Editor** in the Supabase Dashboard.
2. Run each migration file in order:
   - `supabase/migrations/20240101000001_initial_schema.sql`
   - `supabase/migrations/20240101000002_rls.sql`
   - `supabase/migrations/20240101000003_seed_data.sql` (dev/staging only)

## 4. Configure Auth

In **Authentication → URL Configuration**:
- **Site URL**: `https://your-production-domain.com`
- **Redirect URLs**: 
  - `https://your-production-domain.com/auth/callback`
  - `http://localhost:5173/auth/callback` (for local dev)

## 5. Create the First Admin User

**NEVER use development seed for production.**

Create admin manually:
1. Go to **Authentication → Users** in Supabase Dashboard.
2. Click **Invite user** or **Add user**.
3. After user is created, run in SQL Editor:
   ```sql
   UPDATE profiles
   SET role = 'super_admin', full_name = 'Admin Name'
   WHERE email = 'admin@audydental.com';
   ```

## 6. Create Storage Bucket

In **Storage**:
1. Create bucket named `learning-assets`
2. Make it **Private** (not public)
3. Add RLS policy for authenticated access

## 7. Verify RLS

In **Authentication → Policies**, confirm all tables have RLS enabled and policies configured.

## 8. Production Checklist

- [ ] Migrations applied
- [ ] RLS enabled on all tables
- [ ] Auth URLs configured
- [ ] First admin created
- [ ] Storage bucket created
- [ ] Env vars set in Vercel
- [ ] Test login works
- [ ] Test employee can't access admin routes
