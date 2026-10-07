import { createSupabaseServerClient } from '#lib/supabase/server';

// Read env vars at module load time — safe in Node/Bun server environment
const SUPABASE_URL = process.env.PUBLIC_SUPABASE_URL;
const SUPABASE_KEY = process.env.PUBLIC_SUPABASE_PUBLISHABLE_KEY;
const SUPABASE_CONFIGURED = !!(SUPABASE_URL && SUPABASE_KEY && !SUPABASE_URL.includes('placeholder'));

export async function handle({ event, resolve }: { event: any; resolve: any }) {
  const supabase = createSupabaseServerClient(event.cookies, SUPABASE_URL, SUPABASE_KEY);
  event.locals.supabase = supabase;

  if (SUPABASE_CONFIGURED) {
    // Only attempt real auth when Supabase is actually configured
    const {
      data: { user }
    } = await supabase.auth.getUser();

    event.locals.user = user ?? null;

    if (user) {
      const { data: profile } = await supabase
        .from('profiles')
        .select('id, full_name, role, status, department_id, position_id, avatar_url, employee_id')
        .eq('id', user.id)
        .single();

      event.locals.profile = profile ?? null;
    } else {
      event.locals.profile = null;
    }
  } else {
    // Mock mode — no real auth
    event.locals.user = null;
    event.locals.profile = null;
  }

  return resolve(event, {
    filterSerializedResponseHeaders: (name: string) =>
      name === 'content-range' || name === 'x-supabase-api-version'
  });
}
