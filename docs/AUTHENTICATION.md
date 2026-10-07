# Authentication

## Flow

```
User enters email + password
        ↓
POST /auth (SvelteKit form action)
        ↓
locals.supabase.auth.signInWithPassword()
        ↓
Supabase Auth validates credentials
        ↓
Session cookie set (httpOnly, secure)
        ↓
hooks.server.ts reads cookie on next request
        ↓
supabase.auth.getUser() validates JWT
        ↓
Profile loaded from `profiles` table
        ↓
event.locals.user + event.locals.profile available
        ↓
Role check → redirect to / (employee) or /admin (admin)
```

## Session Persistence

Supabase SSR stores the session in an httpOnly cookie. On every server request, `hooks.server.ts` validates the JWT and refreshes it if needed. No manual token storage in localStorage.

## Protected Routes

- `src/routes/(protected)/+layout.server.ts` — Redirects to `/auth` if no user
- `src/routes/admin/+layout.server.ts` — Returns 403 if role is not admin/super_admin

## Auth in Mock Mode

When `PUBLIC_SUPABASE_URL` is not configured, `hooks.server.ts` skips auth and sets `event.locals.user = null`. Pages still render using mock data. The `/auth` login page shows a "Supabase not configured" message.

## Logout

Navigate to `/auth/logout` — the server action calls `supabase.auth.signOut()` which clears the session cookie, then redirects to `/auth`.

## OAuth Callback

`/auth/callback` handles the Supabase auth code exchange (for OAuth flows or magic links). After exchanging the code for a session, redirects to `/`.

## Password Reset

Configure in Supabase Dashboard → Authentication → Email Templates. The reset link directs to `/auth/callback?next=/auth/reset-password`. (Reset password page implementation is a future task.)

## Security Notes

- Sessions are httpOnly cookies — not accessible to JavaScript
- JWT validation via `getUser()` not `getSession()` (more secure)
- Inactive users (`status = 'inactive'`) are rejected even with valid credentials
- Service role key is never used in browser code
