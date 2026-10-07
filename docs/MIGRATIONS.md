# Database Migrations

## Migration Files

All migrations live in `supabase/migrations/` with timestamp-prefixed filenames:

| File | Contents |
|---|---|
| `20240101000001_initial_schema.sql` | All tables, indexes, triggers, auto-profile function |
| `20240101000002_rls.sql` | Row Level Security policies |
| `20240101000003_seed_data.sql` | **Dev only** — stages, materials, quiz data |

## Local Development

```bash
# Start local Supabase
bun run db:start
# or: supabase start

# Reset database (applies all migrations + seed)
bun run db:reset
# or: supabase db reset

# Stop local Supabase
bun run db:stop
```

## Creating a New Migration

```bash
supabase migration new your_migration_name
# Edit supabase/migrations/<timestamp>_your_migration_name.sql
supabase db reset  # test locally
```

## Applying to Production

```bash
# Link to your production Supabase project
supabase login
supabase link --project-ref YOUR_PROJECT_REF

# Push migrations (does NOT run seed files)
supabase db push
```

Or manually run SQL in the Supabase Dashboard → SQL Editor.

## Migration Workflow

```
Local development
      ↓
supabase migration new <name>
      ↓
Write SQL in new migration file
      ↓
supabase db reset (test locally)
      ↓
git commit migration file
      ↓
git push → GitHub
      ↓
supabase db push → Production
```

## Important Rules

1. **Never modify existing migrations** — create new ones instead
2. **Never run `20240101000003_seed_data.sql` on production**
3. Always test migrations locally before pushing to production
4. Commit migrations in the same PR as the feature that requires them
