/**
 * Supabase server client factory.
 *
 * Accepts supabaseUrl and supabaseKey explicitly so this module can be imported
 * without requiring $env imports at the module level (which need svelte-kit to
 * be fully set up with env vars). Callers (hooks.server.ts, +page.server.ts etc.)
 * pass the env values after loading them.
 */

import { createServerClient } from '@supabase/ssr';
import type { Cookies } from '@sveltejs/kit';

export function createSupabaseServerClient(
  cookies: Cookies,
  supabaseUrl?: string,
  supabaseKey?: string
) {
  const url = supabaseUrl ?? 'https://placeholder.supabase.co';
  const key = supabaseKey ?? 'placeholder-key';

  return createServerClient(url, key, {
    cookies: {
      getAll: () => cookies.getAll(),
      setAll: (cookiesToSet) => {
        cookiesToSet.forEach(({ name, value, options }) =>
          cookies.set(name, value, { path: '/', ...options })
        );
      }
    }
  });
}
