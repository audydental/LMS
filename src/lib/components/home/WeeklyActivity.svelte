<script lang="ts">
  import type { ActivityDay } from '#lib/types/learning';

  interface Props {
    activity: ActivityDay[];
    loading?: boolean;
  }

  const { activity, loading = false }: Props = $props();

  const hasAnyActivity = $derived(activity.some((d) => d.completed > 0));

  function handleViewDetail() {
    console.log('Navigate to activity detail');
  }
</script>

<div class="flex flex-col gap-3">

  <!-- ── Header ────────────────────────────────────────────────────── -->
  <div class="flex items-center justify-between">
    <div class="flex items-center gap-2">
      <!-- Calendar icon -->
      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
        <line x1="16" y1="2" x2="16" y2="6"/>
        <line x1="8" y1="2" x2="8" y2="6"/>
        <line x1="3" y1="10" x2="21" y2="10"/>
      </svg>
      <h3 class="text-[14px] font-semibold text-gray-900">Aktivitas Minggu Ini</h3>
    </div>
    <button
      type="button"
      onclick={handleViewDetail}
      class="text-[12px] font-medium text-[#1C50A7] hover:underline focus:outline-none"
      aria-label="Lihat detail aktivitas"
    >
      Lihat detail →
    </button>
  </div>

  <!-- ── Loading skeleton ──────────────────────────────────────── -->
  {#if loading}
    <div class="flex justify-between gap-1">
      {#each [1,2,3,4,5,6,7] as _}
        <div class="flex flex-col items-center gap-1.5 flex-1">
          <div class="h-3 w-5 bg-gray-100 rounded animate-pulse"></div>
          <div class="w-7 h-7 bg-gray-100 rounded-full animate-pulse"></div>
          <div class="w-1.5 h-1.5 bg-gray-100 rounded-full animate-pulse"></div>
        </div>
      {/each}
    </div>

  <!-- ── Day columns ────────────────────────────────────────────── -->
  {:else}
    <div class="flex items-start justify-between gap-1" role="list" aria-label="Aktivitas mingguan">
      {#each activity as day (day.date.toISOString())}
        {@const isToday = day.date.toDateString() === new Date().toDateString()}
        <div class="flex flex-col items-center gap-1 flex-1" role="listitem" aria-label="{day.dayLabel}: {day.completed} aktivitas">

          <!-- Day label -->
          <span class="text-[10.5px] font-medium text-gray-400 leading-none">{day.dayLabel}</span>

          <!-- Date circle -->
          <div
            class={[
              'w-[30px] h-[30px] rounded-full flex items-center justify-center text-[12px] font-semibold leading-none',
              isToday
                ? 'bg-[#1C50A7] text-white'
                : 'text-gray-700'
            ].join(' ')}
          >
            {day.date.getDate()}
          </div>

          <!-- Activity dot -->
          <div
            class={[
              'w-[5px] h-[5px] rounded-full mt-0.5',
              day.completed > 0 ? 'bg-[#1C50A7]' : 'bg-transparent border border-gray-200'
            ].join(' ')}
            aria-hidden="true"
          ></div>
        </div>
      {/each}
    </div>

    <!-- ── Empty state ────────────────────────────────────────────── -->
    {#if !hasAnyActivity}
      <div class="flex flex-col items-center py-4 text-center gap-1">
        <!-- Search/empty icon -->
        <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#C0CCDA" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round" class="mb-1" aria-hidden="true">
          <circle cx="11" cy="11" r="8"/>
          <line x1="21" y1="21" x2="16.65" y2="16.65"/>
          <line x1="8" y1="11" x2="14" y2="11"/>
        </svg>
        <p class="text-[13px] font-medium text-gray-600">Belum ada aktivitas</p>
        <p class="text-[11.5px] text-gray-400 leading-snug max-w-[200px]">
          Mulai pelajari materi untuk melihat riwayat aktivitas Anda di sini.
        </p>
      </div>
    {/if}
  {/if}

</div>
