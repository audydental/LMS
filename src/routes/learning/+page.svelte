<script lang="ts">
  import type { User, Stage, Material, LearningProgress } from '#lib/types/learning';
  import { getUser } from '#lib/services/user';
  import { getStages, getMaterialsByStage, getLearningProgress } from '#lib/services/learning';

  import Sidebar from '#lib/components/home/Sidebar.svelte';
  import TopBar from '#lib/components/home/TopBar.svelte';
  import LearningHeader from '#lib/components/learning/LearningHeader.svelte';
  import LearningSummary from '#lib/components/learning/LearningSummary.svelte';
  import LearningFilters from '#lib/components/learning/LearningFilters.svelte';
  import GrowthJourney from '#lib/components/learning/GrowthJourney.svelte';

  // ── State ──────────────────────────────────────────────────────────────
  let loading = $state(true);
  let error = $state<string | null>(null);
  let user = $state<User | null>(null);
  let stages = $state<Stage[]>([]);
  let materialsByStage = $state<Record<string, Material[]>>({});
  let progress = $state<LearningProgress | null>(null);
  let activeFilter = $state<'all' | 'in_progress' | 'completed'>('all');
  let selectedStageId = $state<string | null>(null);

  const fallbackProgress: LearningProgress = {
    totalStages: 0,
    completedStages: 0,
    inProgressStages: 0,
    totalMaterials: 0,
    completedMaterials: 0,
    overallProgressPct: 0,
    totalPointsEarned: 0,
    totalPointsAvailable: 0,
  };

  const filteredStages = $derived(
    activeFilter === 'all'
      ? stages
      : activeFilter === 'in_progress'
        ? stages.filter((s) => s.isActive && !s.isCompleted)
        : stages.filter((s) => s.isCompleted)
  );

  $effect(() => {
    async function loadAll() {
      try {
        loading = true;
        error = null;

        // Load user + stages + progress first
        const [userData, stagesData, progressData] = await Promise.all([
          getUser(),
          getStages(),
          getLearningProgress(),
        ]);

        user = userData;
        progress = progressData;
        stages = stagesData;

        // Load materials for each stage separately (avoids Promise.all spread typing issues)
        const materialsResults = await Promise.all(stagesData.map((s) => getMaterialsByStage(s.id)));
        const mbs: Record<string, Material[]> = {};
        stagesData.forEach((s, i) => {
          mbs[s.id] = materialsResults[i];
        });
        materialsByStage = mbs;
      } catch (err) {
        console.error('Failed to load learning page data:', err);
        error = 'Data belum dapat dimuat.';
      } finally {
        loading = false;
      }
    }
    loadAll();
  });

  function handleFilterChange(f: 'all' | 'in_progress' | 'completed') {
    activeFilter = f;
    selectedStageId = null;
  }

  function handleStageSelect(stageId: string) {
    selectedStageId = selectedStageId === stageId ? null : stageId;
  }
</script>

<!--
  Layout (matches home page):
  ┌──────────────┬─────────────────────────────────────┬──────────────┐
  │   Sidebar    │  TopBar (sticky)                    │              │
  │   (fixed)    ├─────────────────────────────────────┤  Right panel │
  │   248px      │  Main scrollable content            │  300px       │
  └──────────────┴─────────────────────────────────────┴──────────────┘
-->
<div class="flex h-screen bg-[#F4F7FD] overflow-hidden">

  <!-- ── Fixed sidebar ────────────────────────────────────────────────── -->
  <Sidebar activePage="learning" />

  <!-- ── Right of sidebar ─────────────────────────────────────────────── -->
  <div class="flex flex-1 pl-[248px] min-w-0 h-screen overflow-hidden">

    <!-- ── Main column ──────────────────────────────────────────────── -->
    <div class="flex flex-col flex-1 min-w-0 h-screen overflow-hidden">

      <!-- Sticky TopBar -->
      <div class="sticky top-0 z-20 bg-[#F4F7FD] px-7 shrink-0">
        {#if user}
          <TopBar {user} notificationCount={0} />
        {:else}
          <div class="flex items-center justify-between py-4 gap-4">
            <div class="h-10 w-[380px] bg-white border border-[#E8EEF8] rounded-xl animate-pulse"></div>
            <div class="flex items-center gap-3">
              <div class="w-9 h-9 bg-gray-100 rounded-xl animate-pulse"></div>
              <div class="flex items-center gap-2.5">
                <div class="w-9 h-9 bg-gray-100 rounded-full animate-pulse"></div>
                <div class="flex flex-col gap-1.5">
                  <div class="h-3 w-28 bg-gray-100 rounded animate-pulse"></div>
                  <div class="h-2.5 w-20 bg-gray-100 rounded animate-pulse"></div>
                </div>
              </div>
            </div>
          </div>
        {/if}
      </div>

      <!-- Error state -->
      {#if error}
        <div class="flex-1 flex items-center justify-center p-12" aria-live="assertive">
          <div class="text-center max-w-sm">
            <div class="w-14 h-14 rounded-full bg-red-50 flex items-center justify-center mx-auto mb-4">
              <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#DC2626" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                <circle cx="12" cy="12" r="10"/>
                <line x1="12" y1="8" x2="12" y2="12"/>
                <line x1="12" y1="16" x2="12.01" y2="16"/>
              </svg>
            </div>
            <h2 class="text-[17px] font-semibold text-gray-800 mb-2">Oops, ada masalah</h2>
            <p class="text-[14px] text-gray-500 mb-5">{error}</p>
            <button
              type="button"
              onclick={() => location.reload()}
              class="bg-[#1C50A7] text-white rounded-xl px-5 py-2.5 text-[13.5px] font-semibold hover:bg-[#1845a0] transition-colors"
            >
              Coba Lagi
            </button>
          </div>
        </div>
      {:else}
        <!-- Scrollable main content -->
        <main class="flex-1 overflow-y-auto px-7 py-5 min-w-0" aria-label="Growth Journey">

          <!-- Page header -->
          <LearningHeader stageCount={stages.length} {loading} />

          <!-- Summary cards -->
          <div class="mt-5">
            <LearningSummary progress={progress ?? fallbackProgress} loading={loading || !progress} />
          </div>

          <!-- Filters -->
          <LearningFilters {activeFilter} onFilterChange={handleFilterChange} />

          <!-- Growth journey -->
          <GrowthJourney
            stages={filteredStages}
            {materialsByStage}
            {selectedStageId}
            onStageSelect={handleStageSelect}
            {loading}
          />

          <div class="h-8"></div>
        </main>
      {/if}
    </div>

    <!-- ── Right panel ───────────────────────────────────────────────── -->
    <aside
      class="w-[300px] shrink-0 bg-white border-l border-[#E8EEF8] px-4 py-5 hidden lg:flex flex-col gap-5 overflow-y-auto h-screen"
      aria-label="Panel progres belajar"
    >

      <!-- Widget 1: Progress Belajar -->
      <section>
        <p class="text-[13px] font-semibold text-[#1A2B4A] mb-3">Progress Belajar</p>
        {#if loading || !progress}
          <div class="h-24 bg-gray-100 rounded-xl animate-pulse"></div>
        {:else}
          <div>
            <div class="flex items-baseline justify-between mb-1">
              <span class="text-[28px] font-bold text-[#1C50A7] leading-none">
                {progress.overallProgressPct}%
              </span>
              <span class="text-[12px] text-gray-400">selesai</span>
            </div>
            <div
              class="w-full h-[8px] bg-gray-100 rounded-full overflow-hidden"
              role="progressbar"
              aria-valuenow={progress.overallProgressPct}
              aria-valuemin={0}
              aria-valuemax={100}
              aria-label="Progress keseluruhan"
            >
              <div
                class="h-full bg-[#1C50A7] rounded-full transition-all duration-700"
                style="width: {progress.overallProgressPct}%"
              ></div>
            </div>
            <p class="text-[12px] text-gray-400 mt-1.5">
              {progress.completedMaterials} dari {progress.totalMaterials} materi selesai
            </p>
          </div>
        {/if}
      </section>

      <!-- Divider -->
      <div class="border-t border-[#F0F4FA]"></div>

      <!-- Widget 2: Point Belajar -->
      <section>
        <p class="text-[13px] font-semibold text-[#1A2B4A] mb-2">Point Belajar</p>
        {#if loading || !progress}
          <div class="h-16 bg-gray-100 rounded-xl animate-pulse"></div>
        {:else}
          <div class="flex items-center gap-3">
            <div class="w-10 h-10 rounded-full bg-[#FFF3C4] flex items-center justify-center shrink-0">
              <svg width="19" height="19" viewBox="0 0 24 24" fill="none" stroke="none" aria-hidden="true">
                <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2" fill="#F2AC44"/>
              </svg>
            </div>
            <div>
              <p class="text-[22px] font-bold text-[#1A2B4A] leading-none">
                {progress.totalPointsEarned}
                <span class="text-[14px] font-medium text-gray-400">/ {progress.totalPointsAvailable}</span>
              </p>
              <p class="text-[11px] text-gray-400 mt-0.5">point yang telah diraih</p>
            </div>
          </div>
        {/if}
      </section>

      <!-- Divider -->
      <div class="border-t border-[#F0F4FA]"></div>

      <!-- Widget 3: Daftar Stage -->
      <section>
        <p class="text-[13px] font-semibold text-[#1A2B4A] mb-2">Daftar Stage</p>
        {#if loading}
          <div class="flex flex-col gap-2">
            {#each [1, 2, 3, 4] as _}
              <div class="h-8 bg-gray-100 rounded-lg animate-pulse"></div>
            {/each}
          </div>
        {:else}
          <ul role="list">
            {#each stages as s (s.id)}
              <li class="flex items-center gap-2 py-2 border-b border-[#F0F4FA] last:border-0">
                <!-- Sequence badge -->
                <span class="text-[10px] font-bold text-[#1C50A7] bg-[#EFF4FC] rounded-md px-1.5 py-0.5 shrink-0">
                  S{s.sequence}
                </span>
                <!-- Title -->
                <span class="text-[12px] text-gray-700 flex-1 truncate">{s.title}</span>
                <!-- Completion indicator -->
                {#if s.isCompleted}
                  <svg width="14" height="14" viewBox="0 0 14 14" fill="none" aria-label="Selesai" aria-hidden="true">
                    <circle cx="7" cy="7" r="7" fill="#27AE78"/>
                    <polyline points="3.5,7 6,9.5 10.5,4.5" stroke="white" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                {:else if s.isActive}
                  <div class="w-2 h-2 rounded-full bg-[#1C50A7] shrink-0" aria-label="Sedang berjalan"></div>
                {/if}
              </li>
            {/each}
          </ul>
        {/if}
      </section>

    </aside>

  </div>
</div>
