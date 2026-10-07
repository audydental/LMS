# Role-Based Access Control (RBAC)

## Roles

| Role | Description |
|---|---|
| `employee` | Standard learner — can access learning content and own progress |
| `admin` | Content manager — manages stages, materials, users |
| `super_admin` | Full platform administrator — all admin capabilities plus user role management |

## Permission Matrix

| Feature | Employee | Admin | Super Admin |
|---|---|---|---|
| View Home page | ✓ | ✓ | ✓ |
| View Learning page | ✓ | ✓ | ✓ |
| View Stage detail | ✓ | ✓ | ✓ |
| Complete materials | ✓ | ✓ | ✓ |
| View own progress | ✓ | ✓ | ✓ |
| View own points | ✓ | ✓ | ✓ |
| View Admin dashboard | ✗ | ✓ | ✓ |
| Manage stages | ✗ | ✓ | ✓ |
| Manage materials | ✗ | ✓ | ✓ |
| Manage users | ✗ | ✓ | ✓ |
| View all users' progress | ✗ | ✓ | ✓ |
| Adjust points | ✗ | ✓ | ✓ |
| Change user roles | ✗ | ✗ | ✓ |
| View audit logs | ✗ | ✓ | ✓ |

## Implementation

### 1. UI Layer
Admin controls (Edit, Delete, Publish, Add Material) are never rendered in employee views. Components check role from `$page.data.profile?.role`.

### 2. Server Layer
Protected routes check role in `+layout.server.ts`:
```typescript
// admin guard
if (!isAdmin(locals.profile?.role)) throw error(403, 'Akses ditolak');
```

API routes check `locals.user` and `locals.profile.role` before any operation.

### 3. Database Layer (RLS)
Row Level Security policies enforce access at the database level regardless of application code. See `DATABASE.md` for policy details.

## Utility Functions

Located in `src/lib/auth/permissions.ts`:

```typescript
hasRole(userRole, 'admin')    // true if admin or super_admin
isAdmin(role)                  // shorthand for hasRole(role, 'admin')
isEmployee(role)               // true for any authenticated role
calculateLevel(averageScore)   // Keep Growing / Level Up / Power Team
```

## Role Elevation

Only `super_admin` can change a user's role. This is enforced by the RLS `profiles_update_own` policy which prevents self-elevation and requires admin status for role changes.
