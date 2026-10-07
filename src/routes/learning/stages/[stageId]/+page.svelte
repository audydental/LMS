<script lang="ts">
  import { page } from '$app/state';
  import type { User, Stage, Material } from '#lib/types/learning';
  import { getUser } from '#lib/services/user';
  import { getStageById, getMaterialsByStage, getStages } from '#lib/services/learning';
  import { getStageTheme } from '#lib/utils/stageTheme';

  import Sidebar from '#lib/components/home/Sidebar.svelte';
  import TopBar from '#lib/components/home/TopBar.svelte';

  // ── State ────────────────────────────────────────────────────────────
  let user = $state<User | null>(null);
  let stage = $state<Stage | null>(null);
  let materials = $state<Material[]>([]);
  let allStages = $state<Stage[]>([]);
  let loading = $state(true);
  let error = $state<string | null>(null);

  let activeTab = $state<'overview' | 'materi' | 'kasus' | 'kuis' | 'lampiran'>('materi');
  let searchQuery = $state('');
  let materialFilter = $state<'all' | 'belum' | 'selesai'>('all');

  const stageId = $derived(page.params.stageId ?? '');
  const theme = $derived(stage ? getStageTheme(stage.sequence) : getStageTheme(1));

  // Derived material stats
  const completedMaterials = $derived(materials.filter(m => m.status === 'completed').length);
  const totalMaterials = $derived(materials.length);
  const progressPct = $derived(totalMaterials > 0 ? Math.round((completedMaterials / totalMaterials) * 100) : 0);
  const totalMinutes = $derived(materials.reduce((sum, m) => sum + m.estimatedMinutes, 0));

  // Filtered materials for the Materi tab
  const filteredMaterials = $derived(
    materials
      .filter(m => {
        if (materialFilter === 'belum') return m.status !== 'completed';
        if (materialFilter === 'selesai') return m.status === 'completed';
        return true;
      })
      .filter(m =>
        searchQuery.trim() === '' ||
        m.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
        m.description.toLowerCase().includes(searchQuery.toLowerCase())
      )
  );

  // First incomplete material for CTA
  const firstIncompleteMaterial = $derived(
    materials.find(m => m.status !== 'completed') ?? materials[0] ?? null
  );

  // Mock study case (will come from Supabase later)
  const mockCase = {
    id: 'sc-001',
    title: 'Kasus: Pasien Tidak Sabar',
    description: 'Pasien mengeluh sudah menunggu 30 menit dan ingin pulang. Bagaimana kamu menanganinya dengan profesional sambil tetap menjaga kepuasan pasien?',
    estimatedMinutes: 15,
    pointReward: 20,
    status: 'available' as const
  };

  // Mock quiz (sequence-independent — title derived dynamically in template)
  const mockQuiz = {
    id: 'quiz-001',
    title: 'Kuis Stage',
    questions: 5,
    passingScore: 80,
    pointReward: 20,
    status: 'not_started' as const
  };

  // Mock attachments
  const mockAttachments = [
    { id: 'att-001', fileName: 'SOP Pelayanan Pasien.pdf', type: 'PDF', sizeKb: 245, description: 'Panduan standar pelayanan pasien Audy Dental' },
    { id: 'att-002', fileName: 'Checklist Pembukaan Klinik.xlsx', type: 'Excel', sizeKb: 48, description: 'Template checklist harian pembukaan klinik' }
  ];

  $effect(() => {
    async function loadData() {
      if (!stageId) return;
      try {
        loading = true;
        error = null;
        const [userData, stageData, materialsData, stagesData] = await Promise.all([
          getUser(),
          getStageById(stageId),
          getMaterialsByStage(stageId),
          getStages()
        ]);
        user = userData;
        stage = stageData;
        materials = materialsData;
        allStages = stagesData;
      } catch {
        error = 'Stage tidak dapat dimuat.';
      } finally {
        loading = false;
      }
    }
    loadData();
  });

  function navigateToMaterial(materialId: string) {
    window.location.href = `/learning/stages/${stageId}/materials/${materialId}`;
  }

  function handleContinue() {
    if (firstIncompleteMaterial) navigateToMaterial(firstIncompleteMaterial.id);
  }
</script>

<svelte:head>
  <title>{stage?.title ?? 'Stage Detail'} — Audy Learning Centre</title>
</svelte:head>

<div class="flex h-screen bg-[#F4F7FD] overflow-hidden">
  <Sidebar activePage="learning" />

  <div class="flex flex-1 pl-[248px] min-w-0 h-screen overflow-hidden">

    <!-- Main column -->
    <div class="flex flex-col flex-1 min-w-0 h-screen overflow-hidden">

      <!-- Sticky TopBar -->
      <div class="sticky top-0 z-20 bg-[#F4F7FD] px-7 shrink-0">
        {#if user}
          <TopBar {user} notificationCount={0} />
        {:else}
          <div class="flex items-center justify-between py-4">
            <div class="h-10 w-[380px] bg-white border border-[#E8EEF8] rounded-xl animate-pulse"></div>
          </div>
        {/if}
      </div>

      <!-- Error -->
      {#if error}
        <div class="flex-1 flex items-center justify-center p-12">
          <div class="text-center max-w-sm">
            <p class="text-[17px] font-semibold text-gray-800 mb-3">{error}</p>
            <a href="/learning" class="inline-block bg-[#1C50A7] text-white rounded-xl px-5 py-2.5 text-[13.5px] font-semibold hover:bg-[#1845a0] transition-colors">
              Kembali ke Learning
            </a>
          </div>
        </div>

      {:else}
        <!-- Scrollable main -->
        <main class="flex-1 overflow-y-auto min-w-0" aria-label="Detail Stage">

          {#if loading}
            <!-- Hero skeleton -->
            <div class="mx-7 mt-5 h-[200px] rounded-2xl bg-[#1C50A7]/20 animate-pulse"></div>
            <div class="px-7 mt-6 grid grid-cols-4 gap-4">
              {#each [1,2,3,4] as _}
                <div class="h-[90px] bg-white rounded-xl border border-[#E8EEF8] animate-pulse"></div>
              {/each}
            </div>
          {:else if stage}
            <!-- ── Breadcrumb ─────────────────────────────────── -->
            <nav class="px-7 pt-5 pb-2" aria-label="Breadcrumb">
              <ol class="flex items-center gap-1.5 text-[12px]">
                <li><a href="/" class="text-gray-400 hover:text-[#1C50A7] transition-colors">Home</a></li>
                <li class="text-gray-300">/</li>
                <li><a href="/learning" class="text-gray-400 hover:text-[#1C50A7] transition-colors">Learning</a></li>
                <li class="text-gray-300">/</li>
                <li><span class="text-[#1C50A7] font-medium" aria-current="page">{stage.title}</span></li>
              </ol>
            </nav>

            <!-- ── Stage Hero ─────────────────────────────────── -->
            <div class="mx-7 mt-2 rounded-2xl overflow-hidden" style="background-color: {theme.badgeBg}; min-height: 190px;">
              <div class="relative flex items-stretch" style="min-height: 190px;">
                <!-- Left: text -->
                <div class="flex flex-col justify-center gap-3 p-6 flex-1 z-10">
                  <span class="inline-flex self-start items-center text-[11px] font-bold px-2.5 py-1 rounded-md bg-white/20 text-white">
                    STAGE {String(stage.sequence).padStart(2, '0')}
                  </span>
                  <div>
                    <h1 class="text-[22px] font-bold text-white leading-tight">{stage.title}</h1>
                    <p class="text-[13px] text-white/80 mt-1 line-clamp-2 max-w-md">{stage.description}</p>
                  </div>
                  <!-- Progress -->
                  <div>
                    <div class="flex items-center justify-between mb-1.5">
                      <span class="text-[12px] text-white/70">{completedMaterials} / {totalMaterials} materi selesai</span>
                      <span class="text-[12px] font-bold text-white">{progressPct}%</span>
                    </div>
                    <div class="w-full h-[6px] rounded-full bg-white/20 overflow-hidden max-w-sm">
                      <div class="h-full rounded-full bg-white transition-all duration-700" style="width: {progressPct}%;" role="progressbar" aria-valuenow={progressPct} aria-valuemin={0} aria-valuemax={100}></div>
                    </div>
                  </div>
                </div>
                <!-- Right: image -->
                <div class="relative w-[260px] shrink-0 hidden sm:block overflow-hidden">
                  <div class="absolute inset-y-0 left-0 w-24 z-10 pointer-events-none" style="background: linear-gradient(to right, {theme.badgeBg}, transparent);" aria-hidden="true"></div>
                  <img src={stage.image} alt={stage.title} class="w-full h-full object-cover opacity-80" loading="lazy" referrerpolicy="no-referrer" onerror={(e) => { (e.currentTarget as HTMLImageElement).style.display='none'; }} />
                </div>
              </div>
            </div>

            <!-- ── 4 Stat mini cards ──────────────────────────── -->
            <div class="px-7 mt-4 grid grid-cols-2 lg:grid-cols-4 gap-3">
              <!-- Point -->
              <div class="bg-white rounded-xl border border-[#E8EEF8] px-4 py-3 flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-[#FFF3C4] flex items-center justify-center shrink-0">
                  <svg width="15" height="15" viewBox="0 0 24 24" fill="#F2AC44" stroke="none" aria-hidden="true"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                </div>
                <div>
                  <p class="text-[11px] text-gray-400">Point Tersedia</p>
                  <p class="text-[15px] font-bold text-[#1A2B4A]">+{stage.pointReward}</p>
                </div>
              </div>
              <!-- Time -->
              <div class="bg-white rounded-xl border border-[#E8EEF8] px-4 py-3 flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-[#EFF4FC] flex items-center justify-center shrink-0">
                  <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                </div>
                <div>
                  <p class="text-[11px] text-gray-400">Estimasi Waktu</p>
                  <p class="text-[15px] font-bold text-[#1A2B4A]">{totalMinutes} menit</p>
                </div>
              </div>
              <!-- Materi Selesai -->
              <div class="bg-white rounded-xl border border-[#E8EEF8] px-4 py-3 flex items-center gap-3">
                <div class="w-8 h-8 rounded-full bg-[#EFF4FC] flex items-center justify-center shrink-0">
                  <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/><path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/></svg>
                </div>
                <div>
                  <p class="text-[11px] text-gray-400">Materi Selesai</p>
                  <p class="text-[15px] font-bold text-[#1A2B4A]">{completedMaterials}/{totalMaterials}</p>
                </div>
              </div>
              <!-- Status -->
              <div class="bg-white rounded-xl border border-[#E8EEF8] px-4 py-3 flex items-center gap-3">
                <div class="w-8 h-8 rounded-full flex items-center justify-center shrink-0" style="background-color: {progressPct === 100 ? '#DCFCE7' : progressPct > 0 ? '#EFF4FC' : '#F5F5F5'};">
                  <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="{progressPct === 100 ? '#16A34A' : progressPct > 0 ? '#1C50A7' : '#9CA3AF'}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    {#if progressPct === 100}
                      <polyline points="20 6 9 17 4 12"/>
                    {:else}
                      <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
                    {/if}
                  </svg>
                </div>
                <div>
                  <p class="text-[11px] text-gray-400">Status</p>
                  <p class="text-[13px] font-semibold" style="color: {progressPct === 100 ? '#16A34A' : progressPct > 0 ? '#1C50A7' : '#6B7280'}">
                    {progressPct === 100 ? 'Selesai' : progressPct > 0 ? 'Sedang Berjalan' : 'Belum Mulai'}
                  </p>
                </div>
              </div>
            </div>

            <!-- ── Tabs ───────────────────────────────────────── -->
            <div class="px-7 mt-6">
              <div class="flex gap-0 border-b border-[#E8EEF8] overflow-x-auto" role="tablist">
                {#each [
                  { id: 'overview', label: 'Overview', count: null },
                  { id: 'materi', label: 'Materi', count: totalMaterials },
                  { id: 'kasus', label: 'Studi Kasus', count: 1 },
                  { id: 'kuis', label: 'Kuis', count: 1 },
                  { id: 'lampiran', label: 'Lampiran', count: 2 }
                ] as tab}
                  <button
                    type="button"
                    role="tab"
                    aria-selected={activeTab === tab.id}
                    onclick={() => { activeTab = tab.id as typeof activeTab; }}
                    class={[
                      'flex items-center gap-1.5 px-4 py-3 text-[13px] font-medium whitespace-nowrap border-b-2 transition-colors',
                      activeTab === tab.id
                        ? 'border-[#1C50A7] text-[#1C50A7]'
                        : 'border-transparent text-gray-500 hover:text-gray-700'
                    ].join(' ')}
                  >
                    {tab.label}
                    {#if tab.count !== null}
                      <span class={[
                        'text-[11px] font-bold rounded-full px-1.5 py-0.5 leading-none',
                        activeTab === tab.id ? 'bg-[#EFF4FC] text-[#1C50A7]' : 'bg-gray-100 text-gray-500'
                      ].join(' ')}>{tab.count}</span>
                    {/if}
                  </button>
                {/each}
              </div>
            </div>

            <!-- ── Tab Content ────────────────────────────────── -->
            <div class="px-7 py-5 pb-24">

              <!-- OVERVIEW -->
              {#if activeTab === 'overview'}
                <div class="max-w-2xl flex flex-col gap-6">
                  <div>
                    <h2 class="text-[15px] font-semibold text-[#1A2B4A] mb-2">Tentang Stage Ini</h2>
                    <p class="text-[14px] text-gray-600 leading-relaxed">{stage.description}</p>
                  </div>
                  <div>
                    <h2 class="text-[15px] font-semibold text-[#1A2B4A] mb-3">Yang Akan Kamu Pelajari</h2>
                    <ul class="flex flex-col gap-2">
                      {#each materials.slice(0, 4) as mat}
                        <li class="flex items-start gap-2.5 text-[13px] text-gray-600">
                          <div class="w-5 h-5 rounded-full bg-[#EFF4FC] flex items-center justify-center shrink-0 mt-0.5">
                            <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="20 6 9 17 4 12"/></svg>
                          </div>
                          {mat.title}
                        </li>
                      {/each}
                    </ul>
                  </div>
                  <div class="flex gap-6 flex-wrap">
                    <div class="flex items-center gap-2 text-[13px] text-gray-500">
                      <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>
                      Estimasi {totalMinutes} menit belajar
                    </div>
                    <div class="flex items-center gap-2 text-[13px] text-gray-500">
                      <svg width="15" height="15" viewBox="0 0 24 24" fill="#F2AC44" stroke="none" aria-hidden="true"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>
                      +{stage.pointReward} point tersedia
                    </div>
                  </div>
                  {#if firstIncompleteMaterial}
                    <button type="button" onclick={handleContinue} class="self-start bg-[#1C50A7] text-white rounded-xl px-5 py-2.5 text-[13.5px] font-semibold hover:bg-[#1845a0] transition-colors flex items-center gap-2">
                      {completedMaterials > 0 ? 'Lanjutkan Belajar' : 'Mulai Belajar'}
                      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                    </button>
                  {/if}
                </div>

              <!-- MATERI TAB -->
              {:else if activeTab === 'materi'}
                <!-- Search + Filter -->
                <div class="flex flex-col sm:flex-row gap-3 mb-5">
                  <div class="relative flex-1 max-w-sm">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-3 top-1/2 -translate-y-1/2 pointer-events-none" aria-hidden="true"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    <input type="search" bind:value={searchQuery} placeholder="Cari materi..." class="w-full pl-9 pr-4 h-10 bg-white border border-[#E8EEF8] rounded-xl text-[13px] focus:outline-none focus:ring-2 focus:ring-[#1C50A7]/20 focus:border-[#1C50A7]" aria-label="Cari materi" />
                  </div>
                  <div class="flex gap-2">
                    {#each [{ id: 'all', label: 'Semua' }, { id: 'belum', label: 'Belum Mulai' }, { id: 'selesai', label: 'Selesai' }] as f}
                      <button type="button" onclick={() => { materialFilter = f.id as typeof materialFilter; }} class={['px-3 h-10 rounded-xl text-[12px] font-medium border transition-colors', materialFilter === f.id ? 'bg-[#1C50A7] text-white border-[#1C50A7]' : 'bg-white text-gray-500 border-[#E8EEF8] hover:border-[#1C50A7]'].join(' ')}>
                        {f.label}
                      </button>
                    {/each}
                  </div>
                </div>

                <!-- Material list -->
                {#if filteredMaterials.length === 0}
                  <div class="flex flex-col items-center py-12 text-center">
                    <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#C0CCDA" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" class="mb-3" aria-hidden="true"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                    <p class="text-[14px] font-medium text-gray-500">Tidak ada materi ditemukan</p>
                  </div>
                {:else}
                  <div class="flex flex-col gap-3">
                    {#each filteredMaterials as mat, i (mat.id)}
                      <div class="bg-white rounded-xl border border-[#E8EEF8] p-4 flex items-center gap-4 hover:shadow-sm transition-shadow">
                        <!-- Sequence -->
                        <div class="w-9 h-9 rounded-full flex items-center justify-center text-[12px] font-bold shrink-0 text-white" style="background-color: {mat.status === 'completed' ? '#27AE78' : theme.badgeBg};">
                          {#if mat.status === 'completed'}
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="20 6 9 17 4 12"/></svg>
                          {:else}
                            {String(mat.sequence).padStart(2, '0')}
                          {/if}
                        </div>
                        <!-- Content -->
                        <div class="flex-1 min-w-0">
                          <p class="text-[14px] font-semibold text-[#1A2B4A] leading-snug">{mat.title}</p>
                          <p class="text-[12px] text-gray-400 mt-0.5 line-clamp-1">{mat.description}</p>
                          <div class="flex items-center gap-3 mt-1">
                            <span class="text-[11px] text-gray-400">{mat.estimatedMinutes} menit</span>
                            <span class="text-[11px] font-semibold text-[#D97706]">+{mat.pointReward} point</span>
                          </div>
                        </div>
                        <!-- CTA -->
                        <div class="shrink-0">
                          {#if mat.status === 'completed'}
                            <div class="flex items-center gap-2">
                              <span class="text-[11px] font-semibold text-[#27AE78] bg-[#DCFCE7] rounded-full px-2.5 py-1">✓ Selesai</span>
                              <button type="button" onclick={() => navigateToMaterial(mat.id)} class="text-[12px] font-medium text-gray-400 hover:text-[#1C50A7] border border-[#E8EEF8] rounded-lg px-3 py-1.5 transition-colors">Review</button>
                            </div>
                          {:else}
                            <button type="button" onclick={() => navigateToMaterial(mat.id)} class="bg-[#1C50A7] text-white rounded-xl px-4 py-2 text-[12.5px] font-semibold hover:bg-[#1845a0] transition-colors flex items-center gap-1.5">
                              Mulai
                              <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                            </button>
                          {/if}
                        </div>
                      </div>
                    {/each}
                  </div>
                {/if}

              <!-- STUDI KASUS TAB -->
              {:else if activeTab === 'kasus'}
                <div class="max-w-2xl">
                  <div class="bg-white rounded-xl border border-[#E8EEF8] p-5">
                    <div class="flex items-start gap-4">
                      <div class="w-10 h-10 rounded-xl bg-[#FEF6E8] flex items-center justify-center shrink-0">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#F2AC44" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></svg>
                      </div>
                      <div class="flex-1">
                        <p class="text-[14px] font-semibold text-[#1A2B4A]">{mockCase.title}</p>
                        <p class="text-[13px] text-gray-500 mt-1 leading-relaxed">{mockCase.description}</p>
                        <div class="flex items-center gap-3 mt-2">
                          <span class="text-[12px] text-gray-400">{mockCase.estimatedMinutes} menit</span>
                          <span class="text-[12px] font-semibold text-[#D97706]">+{mockCase.pointReward} point</span>
                        </div>
                      </div>
                    </div>
                    <div class="mt-4 pt-4 border-t border-[#F0F4FA]">
                      <button type="button" class="bg-[#1C50A7] text-white rounded-xl px-4 py-2 text-[13px] font-semibold hover:bg-[#1845a0] transition-colors">
                        Mulai Studi Kasus →
                      </button>
                    </div>
                  </div>
                </div>

              <!-- KUIS TAB -->
              {:else if activeTab === 'kuis'}
                <div class="max-w-2xl">
                  <div class="bg-white rounded-xl border border-[#E8EEF8] p-5">
                    <div class="flex items-start gap-4">
                      <div class="w-10 h-10 rounded-xl bg-[#EFF4FC] flex items-center justify-center shrink-0">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M9 11l3 3L22 4"/><path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"/></svg>
                      </div>
                      <div class="flex-1">
                        <div class="flex items-start justify-between gap-2">
                          <p class="text-[14px] font-semibold text-[#1A2B4A]">Kuis Stage {stage.sequence}</p>
                          <span class="text-[11px] font-semibold text-gray-400 bg-gray-100 rounded-full px-2.5 py-1 shrink-0">Belum dikerjakan</span>
                        </div>
                        <div class="flex items-center gap-3 mt-2 flex-wrap">
                          <span class="text-[12px] text-gray-400">{mockQuiz.questions} pertanyaan</span>
                          <span class="text-[12px] text-gray-400">Nilai minimum: {mockQuiz.passingScore}</span>
                          <span class="text-[12px] font-semibold text-[#D97706]">+{mockQuiz.pointReward} point</span>
                        </div>
                      </div>
                    </div>
                    <div class="mt-4 pt-4 border-t border-[#F0F4FA]">
                      <button type="button" class="bg-[#1C50A7] text-white rounded-xl px-4 py-2 text-[13px] font-semibold hover:bg-[#1845a0] transition-colors">
                        Mulai Kuis →
                      </button>
                    </div>
                  </div>
                </div>

              <!-- LAMPIRAN TAB -->
              {:else if activeTab === 'lampiran'}
                <div class="max-w-2xl flex flex-col gap-3">
                  {#each mockAttachments as att}
                    <div class="bg-white rounded-xl border border-[#E8EEF8] p-4 flex items-center gap-4">
                      <div class="w-10 h-10 rounded-xl flex items-center justify-center shrink-0 text-[10px] font-bold" style="background-color: {att.type === 'PDF' ? '#FEF2F2' : '#F0FDF4'}; color: {att.type === 'PDF' ? '#DC2626' : '#16A34A'};">
                        {att.type}
                      </div>
                      <div class="flex-1 min-w-0">
                        <p class="text-[13px] font-medium text-[#1A2B4A] truncate">{att.fileName}</p>
                        <p class="text-[12px] text-gray-400">{att.description} · {att.sizeKb}KB</p>
                      </div>
                      <button type="button" class="shrink-0 text-[12.5px] font-medium text-[#1C50A7] border border-[#E8EEF8] rounded-lg px-3 py-1.5 hover:bg-[#EFF4FC] transition-colors">
                        Lihat
                      </button>
                    </div>
                  {/each}
                </div>
              {/if}

            </div>

            <!-- ── Sticky bottom CTA ───────────────────────────── -->
            {#if firstIncompleteMaterial}
              <div class="sticky bottom-0 bg-white/95 backdrop-blur-sm border-t border-[#E8EEF8] px-7 py-3 flex items-center justify-between gap-4 z-10">
                <div class="min-w-0">
                  <p class="text-[11px] text-gray-400">Lanjutkan dari</p>
                  <p class="text-[13px] font-semibold text-[#1A2B4A] truncate">{firstIncompleteMaterial.title}</p>
                </div>
                <button type="button" onclick={handleContinue} class="shrink-0 bg-[#1C50A7] text-white rounded-xl px-5 py-2.5 text-[13.5px] font-semibold hover:bg-[#1845a0] transition-colors flex items-center gap-2">
                  {completedMaterials > 0 ? 'Lanjutkan Belajar' : 'Mulai Belajar'}
                  <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
                </button>
              </div>
            {/if}
          {/if}
        </main>
      {/if}
    </div>

    <!-- ── Right panel: Stage navigation ─────────────────────── -->
    <aside class="w-[280px] shrink-0 bg-white border-l border-[#E8EEF8] px-4 py-5 hidden lg:flex flex-col gap-3 overflow-y-auto h-screen" aria-label="Navigasi stage">
      <p class="text-[13px] font-semibold text-[#1A2B4A]">Semua Stage</p>
      {#if allStages.length === 0}
        <div class="flex flex-col gap-2">
          {#each [1,2,3,4] as _}
            <div class="h-14 bg-gray-100 rounded-xl animate-pulse"></div>
          {/each}
        </div>
      {:else}
        <ul role="list" class="flex flex-col gap-2">
          {#each allStages as s (s.id)}
            {@const isCurrentStage = s.id === stageId}
            {@const stageTheme = getStageTheme(s.sequence)}
            <li>
              <a
                href="/learning/stages/{s.id}"
                class={['flex items-center gap-3 px-3 py-3 rounded-xl transition-colors', isCurrentStage ? 'bg-[#EFF4FC] border border-[#1C50A7]/20' : 'hover:bg-gray-50'].join(' ')}
                aria-current={isCurrentStage ? 'page' : undefined}
              >
                <span class="w-7 h-7 rounded-full text-[11px] font-bold flex items-center justify-center shrink-0 text-white" style="background-color: {stageTheme.badgeBg};">
                  {s.sequence}
                </span>
                <div class="flex-1 min-w-0">
                  <p class="text-[12.5px] font-medium {isCurrentStage ? 'text-[#1C50A7]' : 'text-gray-700'} truncate">{s.title}</p>
                  <p class="text-[11px] text-gray-400">{s.progress}% selesai</p>
                </div>
                {#if isCurrentStage}
                  <div class="w-1.5 h-1.5 rounded-full bg-[#1C50A7] shrink-0"></div>
                {/if}
              </a>
            </li>
          {/each}
        </ul>
      {/if}
    </aside>

  </div>
</div>
