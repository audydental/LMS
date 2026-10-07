<script lang="ts">
  import type { User, Stage, PointData, ScoreData, ActivityDay, Recommendation, FreshUpdate } from '#lib/types/learning';

  import { getUser } from '#lib/services/user';
  import { getStages } from '#lib/services/stages';
  import { getPoints } from '#lib/services/points';
  import { getScore } from '#lib/services/scores';
  import { getWeeklyActivity } from '#lib/services/activity';
  import { getRecommendations } from '#lib/services/recommendations';
  import { getFreshUpdates } from '#lib/services/freshUpdates';

  import Sidebar from '#lib/components/home/Sidebar.svelte';
  import TopBar from '#lib/components/home/TopBar.svelte';
  import FreshUpdateBanner from '#lib/components/home/FreshUpdateBanner.svelte';
  import Greeting from '#lib/components/home/Greeting.svelte';
  import SummaryCards from '#lib/components/home/SummaryCards.svelte';
  import GrowthJourney from '#lib/components/home/GrowthJourney.svelte';
  import WeeklyActivity from '#lib/components/home/WeeklyActivity.svelte';
  import Recommendations from '#lib/components/home/Recommendations.svelte';

  // ── State ────────────────────────────────────────────────────────────
  let loading = $state(true);
  let error = $state<string | null>(null);

  let user = $state<User | null>(null);
  let stages = $state<Stage[]>([]);
  let points = $state<PointData | null>(null);
  let score = $state<ScoreData | null>(null);
  let activity = $state<ActivityDay[]>([]);
  let recommendations = $state<Recommendation[]>([]);
  let freshUpdates = $state<FreshUpdate[]>([]);

  const fallbackUpdate: FreshUpdate = {
    id: 'fallback',
    title: 'Kabar Terbaru Untukmu',
    subtitle: 'Ada 2 informasi penting minggu ini',
    label: 'Fresh Update',
    count: 2,
    imageUrl: 'https://picsum.photos/seed/clinic1/800/200',
  };

  $effect(() => {
    async function loadAll() {
      try {
        loading = true;
        error = null;

        const [
          userData, stagesData, pointsData, scoreData,
          activityData, recommendationsData, freshUpdatesData,
        ] = await Promise.all([
          getUser(), getStages(), getPoints(), getScore(),
          getWeeklyActivity(), getRecommendations(), getFreshUpdates(),
        ]);

        user = userData;
        stages = stagesData;
        points = pointsData;
        score = scoreData;
        activity = activityData;
        recommendations = recommendationsData;
        freshUpdates = freshUpdatesData;
      } catch (err) {
        console.error('Failed to load home page data:', err);
        error = 'Data belum dapat dimuat.';
      } finally {
        loading = false;
      }
    }
    loadAll();
  });
</script>

<!--
  Layout:
  ┌──────────────┬────────────────────────────────────┬──────────────┐
  │              │  TopBar (sticky)                   │              │
  │   Sidebar    ├────────────────────────────────────┤  Right panel │
  │   (fixed)    │  Main scrollable content           │  (h-screen)  │
  │              │                                    │              │
  └──────────────┴────────────────────────────────────┴──────────────┘
-->
<div class="flex h-screen bg-[#F4F7FD] overflow-hidden">

  <!-- ── Fixed sidebar ──────────────────────────────────────────────── -->
  <Sidebar activePage="home" />

  <!-- ── Right of sidebar ───────────────────────────────────────────── -->
  <div class="flex flex-1 pl-[248px] min-w-0 h-screen overflow-hidden">

    <!-- ── Main column: topbar + scrollable content ───────────────── -->
    <div class="flex flex-col flex-1 min-w-0 h-screen overflow-hidden">

      <!-- Sticky topbar — no border, transparent bg matches page bg -->
      <div class="sticky top-0 z-20 bg-[#F4F7FD] px-7 shrink-0">
        {#if user}
          <TopBar {user} notificationCount={2} />
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
        <main class="flex-1 overflow-y-auto px-7 py-5 min-w-0" aria-label="Konten utama">

          <!-- Fresh Update Banner — always shown, use fallback if no data -->
          {#if loading}
            <div class="h-[108px] rounded-2xl animate-pulse" style="background: linear-gradient(135deg, #DBE9F9 0%, #C8DCF0 100%);"></div>
          {:else}
            <FreshUpdateBanner update={freshUpdates.length > 0 ? freshUpdates[0] : fallbackUpdate} />
          {/if}

          <!-- Greeting -->
          <div class="mt-5">
            {#if loading}
              <div class="flex flex-col gap-2">
                <div class="h-7 w-72 bg-gray-100 rounded animate-pulse"></div>
                <div class="h-4 w-96 bg-gray-100 rounded animate-pulse"></div>
              </div>
            {:else if user}
              <Greeting {user} />
            {/if}
          </div>

          <!-- Summary Cards -->
          <div class="mt-5">
            {#if loading || !points || !score}
              <SummaryCards
                points={{ current: 0, target: 200, weeklyGain: 0 }}
                score={{ average: 0, quizCompleted: 0 }}
                {stages}
                loading={true}
              />
            {:else}
              <SummaryCards {points} {score} {stages} />
            {/if}
          </div>

          <!-- Growth Journey -->
          <GrowthJourney {stages} loading={loading} />

          <div class="h-8"></div>
        </main>
      {/if}
    </div>

    <!-- ── Right panel: white, full height, left border ──────────── -->
    <aside
      class="w-[300px] shrink-0 bg-white border-l border-[#E8EEF8] flex flex-col gap-5 overflow-y-auto h-screen px-4 py-5 hidden lg:flex"
      aria-label="Panel samping"
    >
      <WeeklyActivity {activity} loading={loading} />
      <Recommendations recommendations={recommendations} loading={loading} />
    </aside>

  </div>
</div>
