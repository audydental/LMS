<script lang="ts">
  // TopBar — search + user info row at the top of the main content area
  import type { User } from '#lib/types/learning';

  interface Props {
    user: User;
    notificationCount?: number;
  }

  const { user, notificationCount = 0 }: Props = $props();

  // Derive initials from firstName + lastName
  const initials = $derived(
    ((user.firstName?.[0] ?? '') + (user.lastName?.[0] ?? '')).toUpperCase() || '?'
  );

  const hasNotifications = $derived(notificationCount > 0);

  function handleSearch(e: Event) {
    e.preventDefault();
  }

  function handleNotificationsClick() {
    console.log('Open notifications');
  }

  function handleUserMenuClick() {
    console.log('Open user menu');
  }
</script>

<header class="flex items-center justify-between py-4 gap-4">

  <!-- ── Search ─────────────────────────────────────────────────────── -->
  <form
    onsubmit={handleSearch}
    class="relative flex items-center w-full max-w-[400px]"
    role="search"
  >
    <!-- Magnifying glass icon -->
    <span class="absolute left-3 text-gray-400 pointer-events-none" aria-hidden="true">
      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="11" cy="11" r="8"/>
        <line x1="21" y1="21" x2="16.65" y2="16.65"/>
      </svg>
    </span>

    <input
      type="search"
      placeholder="Cari materi, topik, atau kata kunci..."
      class="w-full pl-9 pr-16 py-2.5 bg-white border border-[#E8EEF8] rounded-xl text-[13.5px] text-gray-700 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#1C50A7]/20 focus:border-[#1C50A7] transition-colors duration-150"
      aria-label="Cari materi"
    />

    <!-- Keyboard shortcut badge -->
    <kbd class="absolute right-3 flex items-center gap-0.5 text-[11px] font-medium text-gray-400 bg-white border border-gray-200 rounded px-1.5 py-0.5 pointer-events-none select-none">
      ⌘K
    </kbd>
  </form>

  <!-- ── Right side: notifications + divider + user ─────────────────── -->
  <div class="flex items-center gap-3 shrink-0">

    <!-- Notification bell -->
    <button
      type="button"
      onclick={handleNotificationsClick}
      class="relative p-1.5 text-gray-400 hover:text-gray-600 transition-colors duration-150"
      aria-label="Notifikasi"
    >
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/>
        <path d="M13.73 21a2 2 0 0 1-3.46 0"/>
      </svg>
      {#if hasNotifications}
        <span
          class="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full"
          aria-label={`${notificationCount} notifikasi`}
        ></span>
      {/if}
    </button>

    <!-- Vertical divider -->
    <div class="w-px h-6 bg-[#E8EEF8]"></div>

    <!-- User block -->
    <button
      type="button"
      onclick={handleUserMenuClick}
      class="flex items-center gap-2.5 hover:bg-gray-50 rounded-xl px-2 py-1.5 transition-colors duration-150"
      aria-label="Menu pengguna"
      aria-haspopup="true"
    >
      <!-- Avatar circle with initials -->
      {#if user.avatarUrl}
        <img
          src={user.avatarUrl}
          alt={user.name}
          class="w-9 h-9 rounded-full object-cover shrink-0"
        />
      {:else}
        <div
          class="w-9 h-9 rounded-full bg-[#1C50A7] text-white flex items-center justify-center text-[13px] font-semibold shrink-0 select-none"
          aria-hidden="true"
        >
          {initials}
        </div>
      {/if}

      <!-- Name + position -->
      <div class="flex flex-col leading-tight text-left">
        <span class="text-[13.5px] font-semibold text-gray-800 leading-none">{user.name}</span>
        <span class="text-[11.5px] text-gray-500 mt-0.5">
          {user.position} · {user.department}
        </span>
      </div>

      <!-- Chevron down -->
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" class="ml-0.5">
        <polyline points="6 9 12 15 18 9"/>
      </svg>
    </button>

  </div>
</header>
