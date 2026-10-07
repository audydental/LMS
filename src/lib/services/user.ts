import type { User } from '#lib/types/learning';
import { mockUser } from '#lib/mocks/user';

// TODO: replace with supabase.from('users').select().single()
export async function getUser(): Promise<User> {
  await new Promise((resolve) => setTimeout(resolve, 200));
  return mockUser;
}
