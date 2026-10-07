<script lang="ts">
  // Sidebar — fixed left navigation panel
  // Props: activePage (default 'home') — matches one of the nav item ids

  interface Props {
    activePage?: string;
  }

  const { activePage = 'home' }: Props = $props();

  // -----------------------------------------------------------------------
  // Nav item definitions (inline SVG paths — Lucide-style, 24x24 viewBox)
  // -----------------------------------------------------------------------

  interface NavItem {
    id: string;
    label: string;
    iconPath: string;
    badge?: string;
    hasChevron?: boolean;
  }

  const primaryNav: NavItem[] = [
    {
      id: 'home',
      label: 'Home',
      iconPath: 'M3 9.5L12 3l9 6.5V20a1 1 0 0 1-1 1H5a1 1 0 0 1-1-1V9.5z M9 21V12h6v9',
    },
    {
      id: 'learning',
      label: 'Learning',
      iconPath: 'M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z',
      hasChevron: true,
    },
    {
      id: 'play-learn',
      label: 'Play & Learn',
      iconPath: 'M6 2v6l2 2-2 2v6l16-8L6 2z M6 8l8 4-8 4V8z',
      badge: 'Soon',
    },
    {
      id: 'product-knowledge',
      label: 'Product Knowledge',
      iconPath: 'M21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16z',
    },
    {
      id: 'practice',
      label: "Let's Practice",
      iconPath: 'M12 2a3 3 0 0 0-3 3v7a3 3 0 0 0 6 0V5a3 3 0 0 0-3-3z M19 10v2a7 7 0 1 1-14 0v-2 M12 19v3 M8 22h8',
      badge: 'Soon',
    },
    {
      id: 'tanya-jawab',
      label: 'Tanya Jawab',
      iconPath: 'M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z',
      badge: 'Soon',
    },
  ];

  const secondaryNav: NavItem[] = [
    {
      id: 'my-progress',
      label: 'My Progress',
      iconPath: 'M18 20V10 M12 20V4 M6 20v-6',
    },
    {
      id: 'my-score',
      label: 'My Score',
      iconPath: 'M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z',
    },
    {
      id: 'profile',
      label: 'Profile',
      iconPath: 'M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2 M12 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8z',
    },
  ];

  function handleNavClick(id: string) {
    console.log('Navigate to:', id);
  }
</script>

<aside class="fixed top-0 left-0 h-screen w-[248px] bg-white border-r border-[#E5E9F0] flex flex-col z-30 overflow-hidden">

  <!-- ── Logo ─────────────────────────────────────────────────────────── -->
  <div class="px-5 pt-6 pb-5 shrink-0">
    <div class="flex flex-col leading-tight">
      <!-- "Audy" in italic bold, "DENTAL" small caps — matches reference -->
      <div class="flex items-baseline gap-1">
        <span class="text-[#1C3A6B] font-extrabold italic text-[20px] leading-none tracking-tight" style="font-family: Georgia, 'Times New Roman', serif;">Audy</span>
        <span class="text-[#1C3A6B] font-bold text-[11px] tracking-[0.18em] leading-none">DENTAL</span>
      </div>
      <span class="text-[#1C50A7] text-[12px] font-medium leading-tight mt-0.5 tracking-wide">Learning Centre</span>
    </div>
  </div>

  <!-- ── Primary Navigation ─────────────────────────────────────────── -->
  <nav class="px-3 flex-1 overflow-y-auto" aria-label="Main navigation">
    <ul class="space-y-0.5" role="list">
      {#each primaryNav as item (item.id)}
        {@const isActive = activePage === item.id}
        <li>
          <button
            type="button"
            onclick={() => handleNavClick(item.id)}
            class={[
              'w-full flex items-center gap-2.5 h-[44px] px-3 rounded-xl text-[13.5px] font-medium transition-colors duration-150 text-left',
              isActive
                ? 'bg-[#EFF4FC] text-[#1C50A7] font-semibold'
                : 'text-gray-500 hover:bg-gray-50 hover:text-gray-700',
            ].join(' ')}
            aria-current={isActive ? 'page' : undefined}
          >
            <!-- Icon -->
            <svg width="17" height="17" viewBox="0 0 24 24" fill="none"
              stroke={isActive ? '#1C50A7' : '#9CA3AF'}
              stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round"
              aria-hidden="true" class="shrink-0">
              <path d={item.iconPath}/>
            </svg>
            <!-- Label -->
            <span class="flex-1 truncate">{item.label}</span>
            <!-- "Soon" badge -->
            {#if item.badge}
              <span class="text-[10px] font-semibold text-[#D97706] bg-[#FEF3C7] rounded-full px-1.5 py-0.5 leading-none shrink-0">
                {item.badge}
              </span>
            {/if}
            <!-- Chevron for items with sub-menu -->
            {#if item.hasChevron}
              <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#C0CCDA" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" class="shrink-0">
                <polyline points="6 9 12 15 18 9"/>
              </svg>
            {/if}
          </button>
        </li>
      {/each}
    </ul>

    <!-- ── Divider ───────────────────────────────────────────────────── -->
    <div class="my-3 border-t border-gray-100" role="separator"></div>

    <!-- ── Secondary Navigation ─────────────────────────────────────── -->
    <ul class="space-y-0.5" role="list">
      {#each secondaryNav as item (item.id)}
        {@const isActive = activePage === item.id}
        <li>
          <button
            type="button"
            onclick={() => handleNavClick(item.id)}
            class={[
              'w-full flex items-center gap-3 h-11 px-3 rounded-xl text-[13.5px] font-medium transition-colors duration-150 text-left',
              isActive
                ? 'bg-[#EFF6FF] text-[#1C50A7] font-semibold'
                : 'text-gray-500 hover:bg-gray-50 hover:text-gray-700',
            ].join(' ')}
            aria-current={isActive ? 'page' : undefined}
          >
            <svg
              width="17"
              height="17"
              viewBox="0 0 24 24"
              fill="none"
              stroke={isActive ? '#1C50A7' : '#9CA3AF'}
              stroke-width="1.9"
              stroke-linecap="round"
              stroke-linejoin="round"
              aria-hidden="true"
              class="shrink-0"
            >
              <path d={item.iconPath}/>
            </svg>
            <span class="truncate">{item.label}</span>
          </button>
        </li>
      {/each}
    </ul>
  </nav>

  <!-- ── Help Card ─────────────────────────────────────────────────────── -->
  <div class="px-3 pb-5 shrink-0">
    <div class="bg-[#EFF4FC] rounded-xl p-3.5 flex items-center justify-between gap-3">
      <!-- Headphone icon in blue circle -->
      <div class="w-8 h-8 rounded-full bg-[#1C50A7] flex items-center justify-center shrink-0">
        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="M3 18v-6a9 9 0 0 1 18 0v6"/>
          <path d="M21 19a2 2 0 0 1-2 2h-1a2 2 0 0 1-2-2v-3a2 2 0 0 1 2-2h3zM3 19a2 2 0 0 0 2 2h1a2 2 0 0 0 2-2v-3a2 2 0 0 0-2-2H3z"/>
        </svg>
      </div>
      <!-- Text -->
      <div class="flex-1 min-w-0">
        <p class="text-[13px] font-bold text-[#1A2B4A] leading-tight">Butuh bantuan?</p>
        <p class="text-[11px] text-gray-500 leading-snug">Hubungi tim Learning</p>
      </div>
      <!-- Chevron button -->
      <button
        type="button"
        onclick={() => console.log('Contact support')}
        class="w-8 h-8 rounded-full bg-white shadow-sm flex items-center justify-center shrink-0"
        aria-label="Hubungi tim support"
      >
        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <polyline points="9 18 15 12 9 6"/>
        </svg>
      </button>
    </div>
  </div>

</aside>
