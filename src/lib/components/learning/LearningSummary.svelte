<script lang="ts">
  import type { LearningProgress } from '#lib/types/learning';

  interface Props {
    progress: LearningProgress;
    loading?: boolean;
  }

  const { progress, loading = false }: Props = $props();
</script>

{#if loading}
  <!-- Skeleton -->
  <div class="grid grid-cols-2 lg:grid-cols-4 gap-[14px] mb-6">
    {#each [1, 2, 3, 4] as _}
      <div class="bg-white rounded-[14px] border border-[#E8EEF8] p-4 h-[110px] animate-pulse">
        <div class="flex justify-between">
          <div class="flex flex-col gap-2 flex-1">
            <div class="h-3 w-20 bg-gray-100 rounded"></div>
            <div class="h-7 w-10 bg-gray-100 rounded"></div>
          </div>
          <div class="w-10 h-10 bg-gray-100 rounded-full"></div>
        </div>
        <div class="h-3 w-24 bg-gray-100 rounded mt-3"></div>
      </div>
    {/each}
  </div>
{:else}
  <div class="grid grid-cols-2 lg:grid-cols-4 gap-[14px] mb-6">

    <!-- Card 1: Total Stage -->
    <div class="bg-white rounded-[14px] border border-[#E8EEF8] p-4 flex flex-col justify-between min-h-[110px]">
      <div class="flex items-start justify-between gap-2">
        <div>
          <p class="text-[12px] font-medium text-gray-400 mb-1">Total Stage</p>
          <p class="text-[28px] font-bold text-[#1A2B4A] leading-none">{progress.totalStages}</p>
        </div>
        <div class="w-10 h-10 rounded-full bg-[#EFF4FC] flex items-center justify-center shrink-0">
          <!-- Layers / stack icon -->
          <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <polygon points="12 2 2 7 12 12 22 7 12 2"/>
            <polyline points="2 17 12 22 22 17"/>
            <polyline points="2 12 12 17 22 12"/>
          </svg>
        </div>
      </div>
      <p class="text-[12px] text-gray-400 mt-2">Stage tersedia</p>
    </div>

    <!-- Card 2: Completed -->
    <div class="bg-white rounded-[14px] border border-[#E8EEF8] p-4 flex flex-col justify-between min-h-[110px]">
      <div class="flex items-start justify-between gap-2">
        <div>
          <p class="text-[12px] font-medium text-gray-400 mb-1">Completed</p>
          <p class="text-[28px] font-bold leading-none" style="color: {progress.completedStages > 0 ? '#27AE78' : '#1A2B4A'}">
            {progress.completedStages}
          </p>
        </div>
        <div class="w-10 h-10 rounded-full bg-[#E8F8F2] flex items-center justify-center shrink-0">
          <!-- Checkmark circle icon -->
          <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="#27AE78" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
            <polyline points="22 4 12 14.01 9 11.01"/>
          </svg>
        </div>
      </div>
      <p class="text-[12px] text-gray-400 mt-2">Stage selesai</p>
    </div>

    <!-- Card 3: In Progress -->
    <div class="bg-white rounded-[14px] border border-[#E8EEF8] p-4 flex flex-col justify-between min-h-[110px]">
      <div class="flex items-start justify-between gap-2">
        <div>
          <p class="text-[12px] font-medium text-gray-400 mb-1">In Progress</p>
          <p class="text-[28px] font-bold text-[#1A2B4A] leading-none">{progress.inProgressStages}</p>
        </div>
        <div class="w-10 h-10 rounded-full bg-[#EFF4FC] flex items-center justify-center shrink-0">
          <!-- Clock icon -->
          <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <circle cx="12" cy="12" r="10"/>
            <polyline points="12 6 12 12 16 14"/>
          </svg>
        </div>
      </div>
      <p class="text-[12px] text-gray-400 mt-2">Sedang berjalan</p>
    </div>

    <!-- Card 4: Total Point -->
    <div class="bg-white rounded-[14px] border border-[#E8EEF8] p-4 flex flex-col justify-between min-h-[110px]">
      <div class="flex items-start justify-between gap-2">
        <div>
          <p class="text-[12px] font-medium text-gray-400 mb-1">Total Point</p>
          <p class="text-[28px] font-bold text-[#1A2B4A] leading-none">{progress.totalPointsEarned}</p>
        </div>
        <div class="w-10 h-10 rounded-full bg-[#FFF3C4] flex items-center justify-center shrink-0">
          <!-- Star filled -->
          <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="none" aria-hidden="true">
            <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" fill="#F2AC44"/>
          </svg>
        </div>
      </div>
      <p class="text-[12px] text-gray-400 mt-2">
        {progress.totalPointsEarned} / {progress.totalPointsAvailable} point
      </p>
    </div>

  </div>
{/if}
