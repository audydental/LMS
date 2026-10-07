<script lang="ts">
  import type { Stage } from '#lib/types/learning';
  import { getStageTheme } from '#lib/utils/stageTheme';
  import StageCard from './StageCard.svelte';

  interface Props {
    stages: Stage[];
    loading?: boolean;
  }

  const { stages, loading = false }: Props = $props();

  // Only active stages, sorted by sequence
  const activeStages = $derived(
    stages
      .filter((s) => s.status === 'active')
      .sort((a, b) => a.sequence - b.sequence)
  );

  function handleViewAll() {
    console.log('Navigate to all stages');
  }
</script>

<section class="mt-6" aria-labelledby="growth-journey-heading">

  <!-- ── Section header ─────────────────────────────────────────── -->
  <div class="flex items-center justify-between mb-4">
    <div>
      <h2 id="growth-journey-heading" class="text-[20px] font-bold text-[#1A2B4A] leading-tight">
        Growth Journey
      </h2>
      {#if !loading}
        <p class="text-[13px] text-gray-500 mt-0.5">
          {activeStages.length} stage pembelajaran untuk mengenal peran Anda sampai naik level.
        </p>
      {:else}
        <div class="h-4 w-64 bg-gray-100 rounded animate-pulse mt-1"></div>
      {/if}
    </div>

    <button
      type="button"
      onclick={handleViewAll}
      class="shrink-0 text-[13px] font-medium text-[#1C50A7] hover:underline focus:outline-none focus:underline flex items-center gap-1"
      aria-label="Lihat semua stage pembelajaran"
    >
      Lihat semua stage
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <line x1="5" y1="12" x2="19" y2="12"/>
        <polyline points="12 5 19 12 12 19"/>
      </svg>
    </button>
  </div>

  <!-- ── Loading skeletons ──────────────────────────────────────── -->
  {#if loading}
    <div class="flex gap-4 overflow-hidden">
      {#each [1, 2, 3] as _}
        <div class="min-w-[280px] w-[280px] shrink-0 rounded-[18px] border border-[#E8EEF8] bg-white overflow-hidden">
          <div class="h-[148px] bg-gray-100 animate-pulse"></div>
          <div class="p-4 flex flex-col gap-3">
            <div class="h-4 w-3/4 bg-gray-100 rounded animate-pulse"></div>
            <div class="h-3 w-full bg-gray-100 rounded animate-pulse"></div>
            <div class="h-3 w-2/3 bg-gray-100 rounded animate-pulse"></div>
            <div class="h-[5px] w-full bg-gray-100 rounded animate-pulse mt-2"></div>
          </div>
        </div>
      {/each}
    </div>

  <!-- ── Empty state ────────────────────────────────────────────── -->
  {:else if activeStages.length === 0}
    <div class="flex flex-col items-center justify-center py-12 text-center bg-white rounded-2xl border border-[#E8EEF8]">
      <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#C0CCDA" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="mb-3" aria-hidden="true">
        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
        <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
      </svg>
      <p class="text-[14px] font-medium text-gray-500">Belum ada stage pembelajaran</p>
      <p class="text-[12px] text-gray-400 mt-1">Stage akan muncul di sini setelah admin menambahkannya.</p>
    </div>

  <!-- ── Stage cards — horizontal scroll ───────────────────────── -->
  {:else}
    <div
      class="flex gap-4 overflow-x-auto pb-2 -mx-1 px-1"
      style="scrollbar-width: thin; scrollbar-color: #C8D8ED transparent;"
      role="list"
      aria-label="Daftar stage pembelajaran"
    >
      {#each activeStages as stage (stage.id)}
        <div role="listitem">
          <StageCard {stage} theme={getStageTheme(stage.sequence)} />
        </div>
      {/each}
    </div>
  {/if}

</section>
