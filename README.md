# Audy Learning Centre

Internal Learning Management System (LMS) for Audy Dental Group employees.

## Stack

| Layer | Technology |
|---|---|
| Frontend | SvelteKit 5 (Svelte 5 runes), TypeScript, Tailwind CSS v4 |
| Runtime | Bun |
| Database | Supabase PostgreSQL |
| Auth | Supabase Auth (cookie-based SSR) |
| Storage | Supabase Storage |
| Deployment | Vercel |
| Repository | GitHub |

## Quick Start (Local Development)

```bash
# Install dependencies
bun install

# Type check
bun run check

# Start development server (mock mode — no Supabase required)
bun run dev
# Open http://localhost:5173
```

**No Supabase credentials needed for local development.** The app runs with mock data automatically.

## Connect Supabase (Optional for local)

1. Copy `.env.example` to `.env`
2. Fill in your Supabase credentials:
   ```
   PUBLIC_SUPABASE_URL=https://xxx.supabase.co
   PUBLIC_SUPABASE_PUBLISHABLE_KEY=your-anon-key
   ```
3. Run migrations: see [docs/MIGRATIONS.md](docs/MIGRATIONS.md)

## Project Structure

```
src/
├── routes/
│   ├── +page.svelte              # Home dashboard
│   ├── auth/                     # Login, logout, callback
│   ├── learning/                 # Learning module
│   │   └── stages/[stageId]/     # Stage detail
│   │       └── materials/[id]/   # Material reading
│   ├── admin/                    # Admin panel
│   └── api/                      # Server API routes
├── lib/
│   ├── components/home/          # Home page components
│   ├── components/learning/      # Learning page components
│   ├── mocks/                    # Mock data (local dev)
│   ├── services/                 # Data access layer
│   ├── supabase/                 # Supabase client factories
│   ├── auth/                     # RBAC utilities
│   ├── types/                    # TypeScript interfaces
│   └── utils/                    # Helpers
supabase/
├── config.toml                   # Supabase CLI config
└── migrations/                   # Database migrations
docs/                             # Documentation
```

## Pages

| Route | Description |
|---|---|
| `/` | Employee Home Dashboard |
| `/auth` | Login page |
| `/learning` | Growth Journey (all stages) |
| `/learning/stages/[id]` | Stage detail with tabs |
| `/learning/stages/[id]/materials/[id]` | Material reading |
| `/admin` | Admin Dashboard |
| `/admin/stages` | Stage management |
| `/admin/users` | User management |

## Available Scripts

```bash
bun run dev          # Development server
bun run build        # Production build
bun run preview      # Preview production build
bun run check        # TypeScript + Svelte type check
bun run db:start     # Start local Supabase
bun run db:reset     # Reset database with migrations
bun run db:migrate   # Push migrations to connected project
```

## Documentation

| Doc | Description |
|---|---|
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | System architecture overview |
| [DATABASE.md](docs/DATABASE.md) | Schema, relationships, RLS |
| [AUTHENTICATION.md](docs/AUTHENTICATION.md) | Auth flow and security |
| [RBAC.md](docs/RBAC.md) | Roles and permissions |
| [MIGRATIONS.md](docs/MIGRATIONS.md) | Database migration workflow |
| [ENVIRONMENT_VARIABLES.md](docs/ENVIRONMENT_VARIABLES.md) | All env variables |
| [SUPABASE_PRODUCTION.md](docs/SUPABASE_PRODUCTION.md) | Supabase setup guide |
| [VERCEL_PRODUCTION.md](docs/VERCEL_PRODUCTION.md) | Vercel deployment guide |
| [PRODUCTION_DEPLOYMENT.md](docs/PRODUCTION_DEPLOYMENT.md) | End-to-end deploy guide |
| [PRODUCTION_CHECKLIST.md](docs/PRODUCTION_CHECKLIST.md) | Pre-launch checklist |

## Roles

| Role | Access |
|---|---|
| `employee` | Home, Learning, own progress |
| `admin` | + Admin panel, content management |
| `super_admin` | + User role management |

## Production Deployment

See [docs/PRODUCTION_DEPLOYMENT.md](docs/PRODUCTION_DEPLOYMENT.md) for the complete step-by-step guide.

**TL;DR:**
1. Push to GitHub
2. Create Supabase project, run migrations, create admin user
3. Import to Vercel, set env vars, deploy
4. Update Supabase auth redirect URLs

## Manual Steps Required

The following require your accounts and cannot be automated:
- Creating the Supabase production project
- Running migrations against production
- Setting environment variables in Vercel
- Creating the first admin user in Supabase Auth
- Configuring the custom domain DNS
