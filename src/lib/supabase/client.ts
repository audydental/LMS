/**
 * Supabase browser client factory.
 *
 * This file is intentionally minimal — it only gets used when Supabase is
 * configured. In mock/local-only development the app works without calling
 * createSupabaseBrowserClient().
 *
 * To use: ensure PUBLIC_SUPABASE_URL and PUBLIC_SUPABASE_PUBLISHABLE_KEY are
 * set in your .env file, then call createSupabaseBrowserClient() in components
 * that need real-time Supabase data.
 */

import { createBrowserClient } from '@supabase/ssr';

export function createSupabaseBrowserClient(supabaseUrl: string, supabaseKey: string) {
  return createBrowserClient(supabaseUrl, supabaseKey);
}
