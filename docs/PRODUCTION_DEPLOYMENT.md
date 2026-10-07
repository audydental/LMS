# Production Deployment Guide

## Prerequisites

- Node.js / Bun installed locally
- Git installed
- GitHub account
- Supabase account ([supabase.com](https://supabase.com))
- Vercel account ([vercel.com](https://vercel.com))

---

## Step 1: Prepare Local Build

```bash
cd "Audy Learning Centre"
bun install
bun run check        # Must show 0 errors
bun run build        # Must succeed
```

---

## Step 2: Push to GitHub

```bash
git init
git add .
git commit -m "feat: production-ready Audy Learning Centre"
git remote add origin https://github.com/YOUR_ORG/audy-learning-centre.git
git push -u origin main
```

---

## Step 3: Create Supabase Project

1. Go to [supabase.com](https://supabase.com) → New Project
2. Name: `audy-learning-centre`, choose nearest region
3. Save the database password securely (you won't see it again)
4. Wait ~2 minutes for setup

---

## Step 4: Run Database Migrations

In **Supabase Dashboard → SQL Editor**, run in order:

1. Contents of `supabase/migrations/20240101000001_initial_schema.sql`
2. Contents of `supabase/migrations/20240101000002_rls.sql`
3. **Do NOT run** `20240101000003_seed_data.sql` in production

---

## Step 5: Get Supabase Credentials

Go to **Project Settings → API**:
- Copy **Project URL** (`PUBLIC_SUPABASE_URL`)
- Copy **anon public key** (`PUBLIC_SUPABASE_PUBLISHABLE_KEY`)

---

## Step 6: Configure Supabase Auth

Go to **Authentication → URL Configuration**:
- **Site URL**: `https://your-vercel-domain.vercel.app` (update after Vercel deploy)
- **Redirect URLs**: `https://your-vercel-domain.vercel.app/auth/callback`

---

## Step 7: Create First Admin User

In **Supabase Dashboard → Authentication → Users**:
1. Click "Add user" → enter admin email + password
2. After user is created, go to **SQL Editor** and run:
   ```sql
   UPDATE profiles
   SET role = 'super_admin', full_name = 'Admin Audy'
   WHERE email = 'admin@yourdomain.com';
   ```

---

## Step 8: Deploy to Vercel

1. Go to [vercel.com](https://vercel.com) → New Project
2. Import your GitHub repository
3. Framework: SvelteKit (auto-detected)
4. Build Command: `bun run build`
5. Install Command: `bun install`

**Set Environment Variables** (in Vercel → Settings → Environment Variables):
```
PUBLIC_SUPABASE_URL      = https://xxx.supabase.co
PUBLIC_SUPABASE_PUBLISHABLE_KEY = eyJhbGci...
```
Apply to: Production + Preview

6. Click **Deploy**

---

## Step 9: Update Supabase Auth URLs

After Vercel assigns your URL (e.g. `audy-learning-centre.vercel.app`):

In Supabase → Authentication → URL Configuration:
- **Site URL**: `https://audy-learning-centre.vercel.app`
- **Redirect URLs**: `https://audy-learning-centre.vercel.app/auth/callback`

---

## Step 10: Configure Custom Domain (Optional)

In Vercel → Project → Domains:
1. Add domain: `learning.audydental.com`
2. Follow DNS configuration instructions
3. Update Supabase Site URL to the custom domain

---

## Step 11: Verify Production

- [ ] `https://your-domain.com` loads (Home page)
- [ ] `https://your-domain.com/auth` shows login
- [ ] Login with admin credentials → redirected to `/admin`
- [ ] Login with employee credentials → redirected to `/`
- [ ] `/learning` shows stages
- [ ] `/learning/stages/[id]` shows stage detail
- [ ] "Tandai Selesai" on material works
- [ ] `/admin` dashboard loads

---

## Rollback Procedure

To roll back to a previous deployment:
1. Vercel Dashboard → Deployments → find previous working deployment → **Promote to Production**

For database rollbacks:
- Write a migration that reverses the changes
- Apply via `supabase db push`
- Never delete production data without a backup

---

## Backup Strategy

- **Database**: Supabase provides automatic daily backups on Pro plan. Configure in Supabase Dashboard → Project Settings → Backups.
- **Code**: Git history is your code backup.
- **Storage**: Back up the `learning-assets` bucket contents periodically.

---

## Troubleshooting

**Build fails on Vercel**:
- Run `bun run build` locally first to reproduce
- Check all environment variables are set

**Authentication not working**:
- Verify `PUBLIC_SUPABASE_URL` and key are correct
- Check Supabase redirect URLs include your domain
- Ensure `AUTH_CALLBACK` route exists at `/auth/callback`

**500 errors after deployment**:
- Check Vercel function logs
- Verify Supabase project is active and not paused

**Data not showing**:
- Verify migrations ran successfully
- Check RLS policies are not blocking queries
- Test with Supabase Studio SQL Editor
