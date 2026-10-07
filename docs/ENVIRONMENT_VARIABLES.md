# Environment Variables

## Overview

| Variable | Purpose | Environment | Visibility | Where to get |
|---|---|---|---|---|
| `PUBLIC_SUPABASE_URL` | Supabase project API URL | All | Public (browser-safe) | Supabase Dashboard → Project Settings → API |
| `PUBLIC_SUPABASE_PUBLISHABLE_KEY` | Supabase anon/public key | All | Public (browser-safe) | Supabase Dashboard → Project Settings → API → anon key |
| `SUPABASE_SERVICE_ROLE_KEY` | Admin operations key | Server only | **PRIVATE — never expose** | Supabase Dashboard → Project Settings → API → service_role key |

## Local Development (.env)

Create a `.env` file in the project root (never commit it):

```env
PUBLIC_SUPABASE_URL=https://your-project-ref.supabase.co
PUBLIC_SUPABASE_PUBLISHABLE_KEY=your-anon-public-key
```

## Vercel Production

Set these in: Vercel Dashboard → Project → Settings → Environment Variables

| Variable | Environment |
|---|---|
| `PUBLIC_SUPABASE_URL` | Production, Preview, Development |
| `PUBLIC_SUPABASE_PUBLISHABLE_KEY` | Production, Preview, Development |

**Never put `SUPABASE_SERVICE_ROLE_KEY` in code or version control.**

## Mock Mode (No Supabase)

The app runs in mock mode automatically when Supabase env vars are absent or contain placeholder values. All pages work with mock data. Authentication is bypassed.
