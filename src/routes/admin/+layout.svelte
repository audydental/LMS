<script lang="ts">
  import type { LayoutProps } from './$types';
  import { page } from '$app/state';

  const { children }: LayoutProps = $props();

  const currentPath = $derived(page.url.pathname);

  const navItems = [
    { id: 'dashboard', href: '/admin', label: 'Dashboard', icon: 'M3 3h7v7H3z M3 13h7v7H3z M13 3h7v7h-7z M13 13h7v7h-7z' },
    { id: 'users', href: '/admin/users', label: 'Users', icon: 'M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2 M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8z M23 21v-2a4 4 0 0 0-3-3.87 M16 3.13a4 4 0 0 1 0 7.75' },
    { id: 'stages', href: '/admin/stages', label: 'Stages', icon: 'M12 2 2 7l10 5 10-5-10-5z M2 17l10 5 10-5 M2 12l10 5 10-5' },
    { id: 'materials', href: '/admin/materials', label: 'Materials', icon: 'M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z' },
    { id: 'assessments', href: '/admin/assessments', label: 'Assessments', icon: 'M9 11l3 3L22 4 M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11' },
    { id: 'reports', href: '/admin/reports', label: 'Reports', icon: 'M18 20V10 M12 20V4 M6 20v-6' },
    { id: 'audit', href: '/admin/audit-logs', label: 'Audit Logs', icon: 'M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z M14 2v6h6 M16 13H8 M16 17H8 M10 9H8' },
  ];

  function isActive(href: string): boolean {
    if (href === '/admin') return currentPath === '/admin';
    return currentPath.startsWith(href);
  }
</script>

<div class="flex min-h-screen bg-[#F4F7FD]">

  <!-- Admin Sidebar -->
  <aside class="fixed top-0 left-0 h-screen w-[240px] bg-white border-r border-[#E5E9F0] flex flex-col z-30">

    <!-- Logo -->
    <div class="px-5 pt-6 pb-4 border-b border-[#E8EEF8] shrink-0">
      <div class="flex items-baseline gap-1.5 mb-0.5">
        <span class="text-[#1C3A6B] font-extrabold italic text-[18px]" style="font-family: Georgia, serif;">Audy</span>
        <span class="text-[#1C3A6B] font-bold text-[10px] tracking-[0.18em]">DENTAL</span>
      </div>
      <span class="text-[11px] font-semibold text-[#DC2626] bg-red-50 rounded-md px-2 py-0.5">Admin Panel</span>
    </div>

    <!-- Navigation -->
    <nav class="flex-1 px-3 py-4 overflow-y-auto" aria-label="Admin navigation">
      <ul class="flex flex-col gap-0.5" role="list">
        {#each navItems as item}
          {@const active = isActive(item.href)}
          <li>
            <a
              href={item.href}
              class={['flex items-center gap-3 h-[42px] px-3 rounded-xl text-[13px] font-medium transition-colors', active ? 'bg-[#EFF4FC] text-[#1C50A7] font-semibold' : 'text-gray-500 hover:bg-gray-50 hover:text-gray-700'].join(' ')}
              aria-current={active ? 'page' : undefined}
            >
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke={active ? '#1C50A7' : '#9CA3AF'} stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <path d={item.icon}/>
              </svg>
              {item.label}
            </a>
          </li>
        {/each}
      </ul>
    </nav>

    <!-- Footer links -->
    <div class="px-3 py-4 border-t border-[#E8EEF8] shrink-0 flex flex-col gap-1">
      <a href="/" class="flex items-center gap-2.5 px-3 py-2 rounded-xl text-[12.5px] text-gray-400 hover:text-gray-600 hover:bg-gray-50 transition-colors">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
        Kembali ke Beranda
      </a>
      <a href="/auth/logout" class="flex items-center gap-2.5 px-3 py-2 rounded-xl text-[12.5px] text-gray-400 hover:text-red-600 hover:bg-red-50 transition-colors">
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
        Keluar
      </a>
    </div>
  </aside>

  <!-- Main content -->
  <div class="flex-1 pl-[240px] min-w-0">
    {@render children()}
  </div>
</div>
