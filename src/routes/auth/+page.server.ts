import { fail, redirect } from '@sveltejs/kit';
import { z } from 'zod';
import type { Actions, PageServerLoad } from './$types';

const loginSchema = z.object({
  email: z.string().email('Email tidak valid'),
  password: z.string().min(6, 'Password minimal 6 karakter')
});

const SUPABASE_CONFIGURED = !!(
  process.env.PUBLIC_SUPABASE_URL &&
  !process.env.PUBLIC_SUPABASE_URL.includes('placeholder')
);

export const load: PageServerLoad = async ({ locals }) => {
  // Redirect already-authenticated users
  if (locals.user) {
    const role = locals.profile?.role;
    throw redirect(303, role === 'admin' || role === 'super_admin' ? '/admin' : '/');
  }
  return {};
};

export const actions: Actions = {
  default: async ({ request, locals }) => {
    if (!SUPABASE_CONFIGURED) {
      // Dev mode: allow any login for testing
      return fail(503, { error: 'Supabase tidak terkonfigurasi. Aplikasi berjalan dalam mode mock.' });
    }

    const formData = await request.formData();
    const raw = { email: formData.get('email'), password: formData.get('password') };

    const result = loginSchema.safeParse(raw);
    if (!result.success) {
      return fail(400, { error: result.error.issues[0].message });
    }

    const { email, password } = result.data;
    const { error } = await locals.supabase.auth.signInWithPassword({ email, password });

    if (error) {
      return fail(401, { error: 'Email atau password salah. Silakan coba lagi.' });
    }

    const {
      data: { user }
    } = await locals.supabase.auth.getUser();

    if (!user) {
      return fail(500, { error: 'Terjadi kesalahan. Silakan coba lagi.' });
    }

    const { data: profile } = await locals.supabase
      .from('profiles')
      .select('role, status')
      .eq('id', user.id)
      .single();

    if (profile?.status === 'inactive') {
      await locals.supabase.auth.signOut();
      return fail(403, { error: 'Akun Anda tidak aktif. Hubungi administrator.' });
    }

    const isAdmin = profile?.role === 'admin' || profile?.role === 'super_admin';
    throw redirect(303, isAdmin ? '/admin' : '/');
  }
};
