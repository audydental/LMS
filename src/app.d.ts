/// <reference types="node" />

import type { SupabaseClient, User } from '@supabase/supabase-js';

declare global {
  namespace App {
    interface Locals {
      supabase: SupabaseClient;
      user: User | null;
      profile: {
        id: string;
        full_name: string;
        role: 'employee' | 'admin' | 'super_admin';
        status: string;
        department_id: string | null;
        position_id: string | null;
        avatar_url: string | null;
        employee_id: string | null;
      } | null;
    }
    interface PageData {
      user?: User | null;
      profile?: App.Locals['profile'];
    }
  }
}

export {};
