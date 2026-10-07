# Production Checklist

## DATABASE
- [ ] Production Supabase project created
- [ ] Migrations applied: `20240101000001_initial_schema.sql`
- [ ] Migrations applied: `20240101000002_rls.sql`
- [ ] Development seed NOT applied to production
- [ ] RLS enabled on all tables (verified in Supabase Dashboard)
- [ ] Indexes created (included in migration 001)
- [ ] `handle_new_user` trigger working (auto-creates profile on signup)

## AUTH
- [ ] Supabase Auth enabled
- [ ] Email/password provider enabled
- [ ] Site URL configured: `https://your-domain.com`
- [ ] Redirect URL configured: `https://your-domain.com/auth/callback`
- [ ] Login page at `/auth` works
- [ ] Logout at `/auth/logout` works
- [ ] Session persists on page refresh
- [ ] Inactive user gets blocked at login

## ROLE-BASED ACCESS
- [ ] Employee cannot access `/admin` (redirected or 403)
- [ ] Admin can access `/admin`
- [ ] Employee cannot see admin controls on learning pages
- [ ] API routes return 401 when unauthenticated

## STORAGE (when needed)
- [ ] `learning-assets` bucket created
- [ ] Upload restricted to admins
- [ ] Download accessible to authenticated users
- [ ] No public unrestricted write access

## VERCEL
- [ ] GitHub repository connected
- [ ] `@sveltejs/adapter-vercel` installed and configured in vite.config.ts
- [ ] `PUBLIC_SUPABASE_URL` set in Vercel env vars
- [ ] `PUBLIC_SUPABASE_PUBLISHABLE_KEY` set in Vercel env vars
- [ ] Build command: `bun run build`
- [ ] Install command: `bun install`
- [ ] Production deployment successful
- [ ] Preview deployments working

## DOMAIN
- [ ] Custom domain configured in Vercel
- [ ] HTTPS / SSL active
- [ ] Supabase Site URL updated to production domain
- [ ] Auth redirect URLs updated

## APPLICATION FLOWS
- [ ] Employee login → Home page
- [ ] Admin login → Admin dashboard
- [ ] `/learning` shows all stages
- [ ] Stage cards link to `/learning/stages/[id]`
- [ ] Stage detail page loads stage + materials
- [ ] Material detail page renders content
- [ ] "Tandai Selesai" button calls completion API
- [ ] Points API returns correct data
- [ ] `/admin` dashboard loads
- [ ] `/admin/stages` shows stage list
- [ ] `/admin/users` shows user list
- [ ] API routes return proper JSON responses

## SECURITY
- [ ] No secrets committed to Git (check `.gitignore`)
- [ ] Service role key NOT in any frontend code
- [ ] RLS tested: employee cannot read another user's progress
- [ ] Assessment `is_correct` NOT returned to browser
- [ ] Admin routes protected server-side
- [ ] `.env` excluded from Git

## PERFORMANCE
- [ ] Home page loads under 3s
- [ ] Learning page loads under 3s
- [ ] No N+1 query patterns
- [ ] Images have `loading="lazy"`

## MOBILE
- [ ] Home page readable on mobile
- [ ] Learning page scrollable on mobile
- [ ] Stage detail tabs horizontally scrollable on mobile
- [ ] Admin pages usable on tablet

## BUILD
- [ ] `bun run check` passes (0 errors, 0 warnings)
- [ ] `bun run build` completes successfully
- [ ] No TypeScript errors
- [ ] No Svelte errors
