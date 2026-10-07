# Architecture

## Overview

```
┌─────────────────────────────────────────────────────┐
│                  AUDY LEARNING CENTRE                │
├─────────────────────────────────────────────────────┤
│                       VERCEL                        │
│                  (CDN + Edge Network)               │
├─────────────────────────────────────────────────────┤
│               SvelteKit Application                 │
│  ┌──────────────────┐   ┌────────────────────────┐  │
│  │   Browser UI     │   │   SvelteKit Server     │  │
│  │  (Svelte 5)      │   │   (API Routes +        │  │
│  │  Tailwind CSS    │   │    Server Load)         │  │
│  └──────────────────┘   └────────────────────────┘  │
├─────────────────────────────────────────────────────┤
│                  SUPABASE SERVICES                  │
│  ┌──────────┐  ┌──────────┐  ┌────────────────┐    │
│  │ PostgreSQL│  │   Auth   │  │    Storage     │    │
│  │  + RLS   │  │  (JWT)   │  │ (learning-     │    │
│  │          │  │          │  │  assets)        │    │
│  └──────────┘  └──────────┘  └────────────────┘    │
└─────────────────────────────────────────────────────┘
```

## Key Design Decisions

### 1. SvelteKit as Full-Stack Framework
No separate Express/NestJS backend. SvelteKit server routes handle all API logic, keeping the architecture simple and well-suited to Vercel deployment.

### 2. Supabase SSR Auth
Cookie-based session management via `@supabase/ssr`. The `hooks.server.ts` runs on every request to attach the Supabase client and resolve the authenticated user into `event.locals`.

### 3. Mock/Production Dual Mode
All services check whether Supabase is configured. Without credentials, the app runs entirely on mock data — useful for local development and UI review without a Supabase project.

### 4. RBAC at Three Layers
- **UI**: Components hide admin controls for employees
- **Server routes**: Check `locals.profile.role` before any mutation
- **Database**: RLS policies enforce access at the data layer

### 5. Path Aliases
- `#lib/*` — Node.js subpath import (works in hooks.server.ts)
- `$lib/*` — Vite alias (works in all other SvelteKit files)

## Routes

| Route | Access | Description |
|---|---|---|
| `/` | Authenticated | Home dashboard |
| `/auth` | Public | Login page |
| `/auth/logout` | Any | Sign out |
| `/auth/callback` | Any | OAuth callback |
| `/learning` | Employee | Growth Journey overview |
| `/learning/stages/[stageId]` | Employee | Stage detail with tabs |
| `/learning/stages/[stageId]/materials/[materialId]` | Employee | Material reading experience |
| `/admin` | Admin | Admin dashboard |
| `/admin/stages` | Admin | Stage management |
| `/admin/users` | Admin | User management |
| `/admin/materials` | Admin | Material management |
| `/api/dashboard/summary` | Authenticated | Dashboard data |
| `/api/stages` | Authenticated | Stages list |
| `/api/progress/materials/[id]/complete` | Authenticated | Mark material complete |
| `/api/notifications` | Authenticated | User notifications |

## Component Architecture

```
src/lib/
├── components/
│   ├── home/           # Home page components
│   └── learning/       # Learning page components
├── mocks/              # Mock data (swapped for Supabase in prod)
├── services/           # Data access layer (mock → Supabase)
├── supabase/           # Supabase client factories
├── auth/               # RBAC utilities
├── types/              # TypeScript interfaces
└── utils/              # Helpers (greeting, level, stageTheme)
```
