<script lang="ts">
  import type { PointData, ScoreData, Stage } from '#lib/types/learning';
  import { calculateLevel } from '#lib/utils/level';

  interface Props {
    points: PointData;
    score: ScoreData;
    stages: Stage[];
    loading?: boolean;
  }

  const { points, score, stages, loading = false }: Props = $props();

  const level = $derived(calculateLevel(score.average));

  function handleViewScore() {
    console.log('Navigate to score/power team page');
  }
</script>

{#if loading}
  <!-- Skeleton -->
  <div class="grid grid-cols-2 lg:grid-cols-4 gap-4">
    {#each [1, 2, 3, 4] as _}
      <div class="bg-white rounded-[14px] border border-[#E8EEF8] p-4 h-[120px] animate-pulse">
        <div class="flex justify-between">
          <div class="flex flex-col gap-2 flex-1">
            <div class="h-3 w-24 bg-gray-100 rounded"></div>
            <div class="h-7 w-12 bg-gray-100 rounded"></div>
          </div>
          <div class="w-10 h-10 bg-gray-100 rounded-full"></div>
        </div>
        <div class="h-3 w-32 bg-gray-100 rounded mt-3"></div>
      </div>
    {/each}
  </div>

{:else}
  <div class="grid grid-cols-2 lg:grid-cols-4 gap-[14px]">

    <!-- ── Card 1: Total Point ──────────────────────────────────────── -->
    <div class="bg-white rounded-[14px] border border-[#E8EEF8] p-4 flex flex-col justify-between min-h-[110px]">
      <div class="flex items-start justify-between gap-2">
        <div>
          <p class="text-[12px] font-medium text-gray-400 mb-1">Total Point</p>
          <p class="text-[28px] font-bold text-[#1A2B4A] leading-none">{points.current}</p>
        </div>
        <!-- Filled gold star icon -->
        <div class="w-10 h-10 rounded-full bg-[#FFF3C4] flex items-center justify-center shrink-0">
          <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="none" aria-hidden="true">
            <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" fill="#F2AC44" stroke="none"/>
          </svg>
        </div>
      </div>
      <div class="mt-2 flex items-center justify-between gap-1 flex-wrap">
        <span class="text-[11.5px] text-gray-400">{points.current} / {points.target} poin</span>
        <span class="text-[11px] font-semibold text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded-full">
          +{points.weeklyGain} poin minggu ini
        </span>
      </div>
    </div>

    <!-- ── Card 2: Rata-rata Nilai ──────────────────────────────────── -->
    <div class="bg-white rounded-[14px] border border-[#E8EEF8] p-4 flex flex-col justify-between min-h-[110px]">
      <div class="flex items-start justify-between gap-2">
        <div>
          <p class="text-[12px] font-medium text-gray-400 mb-1">Rata-rata Nilai</p>
          <p class="text-[28px] font-bold text-[#1A2B4A] leading-none">
            {score.average === 0 ? '0' : score.average}
          </p>
        </div>
        <!-- Bar chart icon — blue, with chevron -->
        <div class="flex items-center gap-1">
          <div class="w-10 h-10 rounded-full bg-[#EFF4FC] flex items-center justify-center shrink-0">
            <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
              <line x1="18" y1="20" x2="18" y2="10"/>
              <line x1="12" y1="20" x2="12" y2="4"/>
              <line x1="6" y1="20" x2="6" y2="14"/>
              <line x1="2" y1="20" x2="22" y2="20"/>
            </svg>
          </div>
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#C0CCDA" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <polyline points="9 18 15 12 9 6"/>
          </svg>
        </div>
      </div>
      <p class="text-[12px] text-gray-400 mt-2">
        Dari {score.quizCompleted} kuis yang dikerjakan
      </p>
    </div>

    <!-- ── Card 3: Level Anda ───────────────────────────────────────── -->
    <div class="bg-white rounded-[14px] border border-[#E8EEF8] p-4 flex flex-col justify-between min-h-[110px]">
      <div class="flex items-start justify-between gap-2">
        <div>
          <p class="text-[12px] font-medium text-gray-400 mb-1">Level Anda</p>
          <p class="text-[18px] font-bold text-[#1C50A7] leading-none">
            {level.name}
          </p>
        </div>
        <!-- Flame icon -->
        <div class="w-10 h-10 rounded-full flex items-center justify-center shrink-0" style="background-color: {level.bgColor};">
          <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="{level.color}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/>
          </svg>
        </div>
      </div>
      <!-- Progress bar within current level -->
      <div class="mt-3">
        <div class="w-full h-[5px] bg-gray-100 rounded-full overflow-hidden">
          <div
            class="h-full rounded-full transition-all duration-700"
            style="width: {level.progress}%; background-color: {level.color};"
            role="progressbar"
            aria-valuenow={level.progress}
            aria-valuemin={0}
            aria-valuemax={100}
            aria-label="Progress level {level.progress}%"
          ></div>
        </div>
      </div>
    </div>

    <!-- ── Card 4: Power Team ───────────────────────────────────────── -->
    <div class="bg-white rounded-[14px] border border-[#E8EEF8] p-4 flex flex-col justify-between min-h-[110px]">
      <div class="flex items-start justify-between gap-2">
        <div>
          <p class="text-[12px] font-medium text-gray-400 mb-1">Power Team</p>
          <p class="text-[28px] font-bold text-[#1A2B4A] leading-none">0 <span class="text-[14px] font-medium text-gray-400">poin</span></p>
        </div>
        <!-- Team / users icon — blue -->
        <div class="w-10 h-10 rounded-full bg-[#EFF4FC] flex items-center justify-center shrink-0">
          <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/>
            <circle cx="9" cy="7" r="4"/>
            <path d="M23 21v-2a4 4 0 0 0-3-3.87"/>
            <path d="M16 3.13a4 4 0 0 1 0 7.75"/>
          </svg>
        </div>
      </div>
      <button
        type="button"
        onclick={handleViewScore}
        class="mt-2 text-[12px] font-semibold text-[#1C50A7] hover:underline focus:outline-none focus:underline flex items-center gap-1 w-fit"
        aria-label="Lihat detail Power Team"
      >
        Lihat detail
        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <line x1="5" y1="12" x2="19" y2="12"/>
          <polyline points="12 5 19 12 12 19"/>
        </svg>
      </button>
    </div>

  </div>
{/if}
