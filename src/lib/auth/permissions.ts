export type Role = 'employee' | 'admin' | 'super_admin';

const roleHierarchy: Record<Role, number> = {
  employee: 1,
  admin: 2,
  super_admin: 3
};

/** Returns true if userRole meets or exceeds the required role level. */
export function hasRole(
  userRole: Role | string | null | undefined,
  requiredRole: Role
): boolean {
  if (!userRole) return false;
  const level = roleHierarchy[userRole as Role] ?? 0;
  return level >= roleHierarchy[requiredRole];
}

/** Shorthand: true for admin or super_admin. */
export function isAdmin(role: Role | string | null | undefined): boolean {
  return hasRole(role, 'admin');
}

/** Shorthand: true for any authenticated role. */
export function isEmployee(role: Role | string | null | undefined): boolean {
  return hasRole(role, 'employee');
}

/**
 * Calculate the user's learning level from their average score.
 * Matches the existing home page level logic.
 */
export function calculateLevel(averageScore: number): {
  name: 'Keep Growing' | 'Level Up' | 'Power Team';
  color: string;
  bgColor: string;
} {
  if (averageScore >= 95)
    return { name: 'Power Team', color: '#D97706', bgColor: '#FEF3C7' };
  if (averageScore >= 85)
    return { name: 'Level Up', color: '#2E7BE8', bgColor: '#EBF3FE' };
  return { name: 'Keep Growing', color: '#1C50A7', bgColor: '#EFF4FC' };
}
