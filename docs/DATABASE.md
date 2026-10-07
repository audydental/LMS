# Database Schema

## Tables

### Core
| Table | Purpose |
|---|---|
| `profiles` | User profiles linked to `auth.users` |
| `departments` | Company departments |
| `positions` | Job positions within departments |

### Learning Content
| Table | Purpose |
|---|---|
| `stages` | Learning stages (sequence-ordered) |
| `materials` | Learning materials within stages |
| `learning_cases` | Case studies within stages |
| `material_attachments` | File metadata for material downloads |

### Progress & Gamification
| Table | Purpose |
|---|---|
| `user_material_progress` | Per-user material completion state |
| `user_case_progress` | Per-user case study completion state |
| `point_transactions` | Immutable point history log |

### Assessments
| Table | Purpose |
|---|---|
| `assessments` | Quiz definitions per stage |
| `assessment_questions` | Questions within a quiz |
| `assessment_options` | Answer options (is_correct hidden from browser) |
| `assessment_attempts` | User quiz attempts |
| `assessment_answers` | Per-question answers within an attempt |

### System
| Table | Purpose |
|---|---|
| `notifications` | User notifications |
| `audit_logs` | Admin action audit trail |

## Key Relationships

```
auth.users (Supabase managed)
    └── profiles (1:1)
            ├── user_material_progress (1:many)
            ├── user_case_progress (1:many)
            ├── point_transactions (1:many)
            ├── assessment_attempts (1:many)
            └── notifications (1:many)

stages (1:many)
    ├── materials (1:many)
    │       └── user_material_progress (1:many)
    ├── learning_cases (1:many)
    └── assessments (1:1)
            ├── assessment_questions (1:many)
            │       └── assessment_options (1:many)
            └── assessment_attempts (1:many)
                    └── assessment_answers (1:many)
```

## RLS Policies Summary

| Table | Employee | Admin |
|---|---|---|
| `profiles` | Own row only | All rows |
| `stages` | Published only | All |
| `materials` | Published only | All |
| `user_material_progress` | Own rows only | Read all |
| `point_transactions` | Read own | Read all |
| `assessment_options` | Read (no `is_correct`) | All |
| `notifications` | Own rows only | — |
| `audit_logs` | No access | Read all |

## Migrations

All schema changes are in `supabase/migrations/`:
1. `20240101000001_initial_schema.sql` — Tables, indexes, triggers
2. `20240101000002_rls.sql` — RLS policies
3. `20240101000003_seed_data.sql` — Dev seed data (not for production)

## Assessment Security

`assessment_options.is_correct` is stored in the database but **never returned to the browser** directly. The API layer selects options without the `is_correct` column for employee-facing endpoints. Score calculation happens server-side only.
