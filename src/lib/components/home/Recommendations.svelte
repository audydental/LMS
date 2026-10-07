<script lang="ts">
  import type { Recommendation } from '#lib/types/learning';

  // Thumbnails using picsum.photos — reliable, no CORS issues in local dev
  const thumbnails: Record<string, string> = {
    'rec-001': 'https://picsum.photos/seed/r1/80/80',
    'rec-002': 'https://picsum.photos/seed/r2/80/80',
    'rec-003': 'https://picsum.photos/seed/r3/80/80'
  };

  interface Props {
    recommendations: Recommendation[];
    loading?: boolean;
  }

  const { recommendations, loading = false }: Props = $props();

  function handlePlay(rec: Recommendation) {
    console.log('Navigate to recommendation:', rec.id);
  }
</script>

<div class="flex flex-col gap-2">

  <!-- ── Header ────────────────────────────────────────────────────── -->
  <div class="flex items-center gap-2">
    <!-- Lightbulb icon — yellow -->
    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#F2AC44" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
      <path d="M15 14c.2-1 .7-1.7 1.5-2.5 1-.9 1.5-2.2 1.5-3.5A6 6 0 0 0 6 8c0 1 .2 2.2 1.5 3.5.7.7 1.3 1.5 1.5 2.5"/>
      <path d="M9 18h6"/>
      <path d="M10 22h4"/>
    </svg>
    <h3 class="text-[14px] font-semibold text-gray-900">Rekomendasi Untuk Anda</h3>
  </div>

  <!-- ── Loading skeletons ──────────────────────────────────────── -->
  {#if loading}
    {#each [1, 2, 3] as _}
      <div class="flex items-center gap-3 py-2">
        <div class="w-12 h-12 rounded-lg bg-gray-100 animate-pulse shrink-0"></div>
        <div class="flex-1 flex flex-col gap-1.5">
          <div class="h-3.5 w-4/5 bg-gray-100 rounded animate-pulse"></div>
          <div class="h-3 w-1/2 bg-gray-100 rounded animate-pulse"></div>
        </div>
      </div>
    {/each}

  <!-- ── Empty state ────────────────────────────────────────────── -->
  {:else if recommendations.length === 0}
    <div class="flex flex-col items-center py-6 text-center">
      <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="#C0CCDA" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="mb-2" aria-hidden="true">
        <circle cx="12" cy="12" r="10"/>
        <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/>
        <line x1="12" y1="17" x2="12.01" y2="17"/>
      </svg>
      <p class="text-[13px] text-gray-500 font-medium">Belum ada rekomendasi</p>
      <p class="text-[11px] text-gray-400 mt-0.5">Mulai belajar untuk mendapat saran konten.</p>
    </div>

  <!-- ── Recommendation list ────────────────────────────────────── -->
  {:else}
    <ul class="flex flex-col" role="list">
      {#each recommendations as rec, i (rec.id)}
        <li>
          {#if i > 0}
            <hr class="border-[#F0F4FA]" />
          {/if}
          <button
            type="button"
            onclick={() => handlePlay(rec)}
            class="w-full flex items-center gap-3 py-2.5 hover:bg-[#F8FAFF] rounded-xl px-2 -mx-2 transition-colors duration-150 text-left group"
            aria-label="Mulai belajar: {rec.title}"
          >
            <!-- Thumbnail image -->
            <div class="w-12 h-12 rounded-lg overflow-hidden shrink-0 bg-[#EFF4FC]">
              {#if thumbnails[rec.id]}
                <img
                  src={thumbnails[rec.id]}
                  alt={rec.title}
                  class="w-full h-full object-cover"
                  loading="lazy"
                  referrerpolicy="no-referrer"
                  onerror={(e) => { (e.currentTarget as HTMLImageElement).style.display='none' }}
                />
              {:else}
                <div class="w-full h-full flex items-center justify-center" style="background-color: {rec.thumbnailColor};">
                  <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="1.9" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
                    <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
                  </svg>
                </div>
              {/if}
            </div>

            <!-- Text info -->
            <div class="flex-1 min-w-0">
              <p class="text-[13px] font-medium text-gray-800 leading-snug line-clamp-1">
                {rec.title}
              </p>
              <p class="text-[11.5px] text-gray-400 mt-0.5">
                {rec.category} · {rec.durationMinutes} menit
              </p>
            </div>

            <!-- Chevron -->
            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#C0CCDA" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" class="shrink-0 group-hover:stroke-[#1C50A7] transition-colors" aria-hidden="true">
              <polyline points="9 18 15 12 9 6"/>
            </svg>
          </button>
        </li>
      {/each}
    </ul>
  {/if}

</div>
