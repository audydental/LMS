<script lang="ts">
  import { page } from '$app/state';
  import type { User, Stage, Material } from '#lib/types/learning';
  import { getUser } from '#lib/services/user';
  import { getStageById, getMaterialsByStage } from '#lib/services/learning';

  import Sidebar from '#lib/components/home/Sidebar.svelte';
  import TopBar from '#lib/components/home/TopBar.svelte';

  // ── State ────────────────────────────────────────────────────────────
  let user = $state<User | null>(null);
  let stage = $state<Stage | null>(null);
  let materials = $state<Material[]>([]);
  let loading = $state(true);
  let completed = $state(false);
  let completingLoading = $state(false);

  const stageId = $derived(page.params.stageId ?? '');
  const materialId = $derived(page.params.materialId ?? '');

  const currentMaterial = $derived(materials.find(m => m.id === materialId) ?? null);
  const currentIndex = $derived(materials.findIndex(m => m.id === materialId));
  const prevMaterial = $derived(currentIndex > 0 ? materials[currentIndex - 1] : null);
  const nextMaterial = $derived(currentIndex < materials.length - 1 ? materials[currentIndex + 1] : null);

  // Mark as completed on initial load if it already is
  $effect(() => {
    if (currentMaterial) {
      completed = currentMaterial.status === 'completed';
    }
  });

  // Generate realistic content from material title/description
  function generateContent(mat: Material): { intro: string; body: string[]; points: string[] } {
    const contentMap: Record<string, { intro: string; body: string[]; points: string[] }> = {
      'mat-101': {
        intro: 'Menyambut pasien adalah momen pertama yang membentuk kesan mereka terhadap klinik Audy Dental. Sebagai staf front office, kamu adalah wajah pertama yang dilihat pasien.',
        body: [
          'Gunakan salam yang hangat dan profesional: "Selamat datang di Audy Dental, ada yang bisa saya bantu?" Pertahankan kontak mata dan senyum yang tulus selama interaksi.',
          'Kesan pertama terbentuk dalam 7 detik pertama. Postur tubuh, nada suara, dan ekspresi wajah semuanya berperan penting dalam menciptakan pengalaman positif bagi pasien.',
          'Perhatikan kondisi pasien — apakah mereka tampak cemas, buru-buru, atau baru pertama kali datang. Sesuaikan pendekatan komunikasimu untuk memastikan setiap pasien merasa diterima.'
        ],
        points: ['Salam profesional dalam 3 detik pertama', 'Bahasa tubuh yang terbuka dan ramah', 'Adaptasi komunikasi berdasarkan kondisi pasien']
      }
    };

    return contentMap[mat.id] ?? {
      intro: mat.description,
      body: [
        `Materi ini membahas ${mat.title.toLowerCase()} secara mendalam. Pemahaman yang baik tentang topik ini akan meningkatkan kualitas kerja kamu di Audy Dental.`,
        'Dalam lingkungan klinik dental yang profesional, setiap aspek dari peranmu berkontribusi pada pengalaman pasien secara keseluruhan. Konsistensi dan perhatian terhadap detail adalah kunci.',
        'Terapkan prinsip-prinsip yang dipelajari secara konsisten dalam pekerjaan sehari-hari untuk membangun kebiasaan profesional yang kuat dan meningkatkan kepercayaan tim.'
      ],
      points: [
        `Memahami konsep dasar ${mat.title}`,
        'Menerapkan standar Audy Dental dalam pekerjaan',
        'Meningkatkan kualitas layanan secara berkelanjutan'
      ]
    };
  }

  $effect(() => {
    async function loadData() {
      if (!stageId || !materialId) return;
      try {
        loading = true;
        const [userData, stageData, materialsData] = await Promise.all([
          getUser(),
          getStageById(stageId),
          getMaterialsByStage(stageId)
        ]);
        user = userData;
        stage = stageData;
        materials = materialsData;
      } catch {
        // silently handle
      } finally {
        loading = false;
      }
    }
    loadData();
  });

  async function handleComplete() {
    if (completed || completingLoading) return;
    completingLoading = true;
    // Mock completion — in production this calls POST /api/progress/materials/:id/complete
    await new Promise(r => setTimeout(r, 800));
    completed = true;
    completingLoading = false;
  }
</script>

<svelte:head>
  <title>{currentMaterial?.title ?? 'Materi'} — Audy Learning Centre</title>
</svelte:head>

<div class="flex h-screen bg-[#F4F7FD] overflow-hidden">
  <Sidebar activePage="learning" />

  <div class="flex flex-col flex-1 pl-[248px] min-w-0 h-screen overflow-hidden">

    <!-- TopBar -->
    <div class="sticky top-0 z-20 bg-[#F4F7FD] px-7 shrink-0">
      {#if user}
        <TopBar {user} notificationCount={0} />
      {:else}
        <div class="flex items-center justify-between py-4">
          <div class="h-10 w-[380px] bg-white border border-[#E8EEF8] rounded-xl animate-pulse"></div>
        </div>
      {/if}
    </div>

    <!-- Scrollable content -->
    <main class="flex-1 overflow-y-auto" aria-label="Konten materi">
      <div class="max-w-[800px] mx-auto px-6 py-5 pb-24">

        {#if loading}
          <div class="flex flex-col gap-4">
            <div class="h-4 w-64 bg-gray-100 rounded animate-pulse"></div>
            <div class="h-8 w-96 bg-gray-100 rounded animate-pulse"></div>
            <div class="h-[400px] bg-white rounded-2xl border border-[#E8EEF8] animate-pulse"></div>
          </div>

        {:else if currentMaterial}
          {@const content = generateContent(currentMaterial)}

          <!-- Breadcrumb -->
          <nav aria-label="Breadcrumb" class="mb-4">
            <ol class="flex items-center gap-1.5 text-[12px] flex-wrap">
              <li><a href="/learning" class="text-gray-400 hover:text-[#1C50A7] transition-colors">Learning</a></li>
              <li class="text-gray-300">/</li>
              <li><a href="/learning/stages/{stageId}" class="text-gray-400 hover:text-[#1C50A7] transition-colors">{stage?.title ?? 'Stage'}</a></li>
              <li class="text-gray-300">/</li>
              <li><span class="text-[#1C50A7] font-medium" aria-current="page">{currentMaterial.title}</span></li>
            </ol>
          </nav>

          <!-- Material header -->
          <div class="mb-6">
            <div class="flex items-start gap-4">
              <div class="w-10 h-10 rounded-full bg-[#1C50A7] text-white flex items-center justify-center text-[14px] font-bold shrink-0">
                {String(currentMaterial.sequence).padStart(2, '0')}
              </div>
              <div class="flex-1">
                <h1 class="text-[22px] font-bold text-[#1A2B4A] leading-tight">{currentMaterial.title}</h1>
                <div class="flex items-center gap-3 mt-2 flex-wrap">
                  <span class="text-[11px] font-semibold text-[#1C50A7] bg-[#EFF4FC] rounded-full px-2.5 py-1">MATERI</span>
                  <span class="text-[12px] text-gray-400">{currentMaterial.estimatedMinutes} menit</span>
                  <span class="text-[12px] font-semibold text-[#D97706]">+{currentMaterial.pointReward} point</span>
                  {#if completed}
                    <span class="text-[11px] font-semibold text-[#27AE78] bg-[#DCFCE7] rounded-full px-2.5 py-1">✓ Selesai</span>
                  {/if}
                </div>
                <p class="text-[13px] text-gray-500 mt-1.5">Materi {currentIndex + 1} dari {materials.length}</p>
              </div>
            </div>
          </div>

          <!-- Content card -->
          <div class="bg-white rounded-2xl border border-[#E8EEF8] p-8 mb-5">
            <h2 class="text-[16px] font-semibold text-[#1A2B4A] mb-4">Pengenalan</h2>
            <p class="text-[14px] text-gray-600 leading-relaxed mb-4">{content.intro}</p>
            {#each content.body as para}
              <p class="text-[14px] text-gray-600 leading-relaxed mb-4">{para}</p>
            {/each}

            <div class="mt-6 pt-6 border-t border-[#F0F4FA]">
              <h3 class="text-[14px] font-semibold text-[#1A2B4A] mb-3">Poin Pembelajaran</h3>
              <ul class="flex flex-col gap-2.5">
                {#each content.points as point}
                  <li class="flex items-start gap-2.5 text-[13px] text-gray-600">
                    <div class="w-5 h-5 rounded-full bg-[#EFF4FC] flex items-center justify-center shrink-0 mt-0.5">
                      <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="20 6 9 17 4 12"/></svg>
                    </div>
                    {point}
                  </li>
                {/each}
              </ul>
            </div>
          </div>

          <!-- Completion card -->
          <div class="bg-white rounded-2xl border border-[{completed ? '#DCFCE7' : '#E8EEF8'}] p-5 mb-6">
            <div class="flex items-center gap-3 mb-3">
              <div class="w-8 h-8 rounded-full flex items-center justify-center shrink-0" style="background-color: {completed ? '#DCFCE7' : '#F5F5F5'};">
                {#if completed}
                  <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#16A34A" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="20 6 9 17 4 12"/></svg>
                {:else}
                  <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><circle cx="12" cy="12" r="10"/></svg>
                {/if}
              </div>
              <p class="text-[13px] font-medium text-gray-700">
                {completed ? `Materi ini telah selesai! Kamu mendapat +${currentMaterial.pointReward} point.` : 'Tandai materi ini sebagai selesai untuk mendapatkan point.'}
              </p>
            </div>
            <button
              type="button"
              onclick={handleComplete}
              disabled={completed || completingLoading}
              class={[
                'w-full h-11 rounded-xl text-[14px] font-semibold transition-all flex items-center justify-center gap-2',
                completed
                  ? 'bg-[#DCFCE7] text-[#16A34A] cursor-default'
                  : 'bg-[#1C50A7] text-white hover:bg-[#1845a0] disabled:opacity-60'
              ].join(' ')}
            >
              {#if completingLoading}
                <div class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" aria-hidden="true"></div>
                Menyimpan...
              {:else if completed}
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><polyline points="20 6 9 17 4 12"/></svg>
                ✓ Selesai — +{currentMaterial.pointReward} Point Earned
              {:else}
                ✓ Tandai Selesai & Dapatkan +{currentMaterial.pointReward} Point
              {/if}
            </button>
          </div>

          <!-- Progress dots + prev/next -->
          <div class="flex items-center justify-between gap-4">
            <!-- Prev -->
            {#if prevMaterial}
              <a href="/learning/stages/{stageId}/materials/{prevMaterial.id}" class="flex items-center gap-2 text-[13px] font-medium text-gray-500 hover:text-[#1C50A7] transition-colors">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                Sebelumnya
              </a>
            {:else}
              <div></div>
            {/if}

            <!-- Progress dots -->
            <div class="flex items-center gap-1.5" aria-label="Progress materi">
              {#each materials as m, i}
                <div
                  class={['w-2 h-2 rounded-full transition-all', i === currentIndex ? 'w-4 bg-[#1C50A7]' : m.status === 'completed' ? 'bg-[#27AE78]' : 'bg-gray-200'].join(' ')}
                  aria-hidden="true"
                ></div>
              {/each}
            </div>

            <!-- Next -->
            {#if nextMaterial}
              <a href="/learning/stages/{stageId}/materials/{nextMaterial.id}" class="flex items-center gap-2 text-[13px] font-medium text-[#1C50A7] hover:text-[#1845a0] transition-colors">
                Selanjutnya
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
              </a>
            {:else}
              <a href="/learning/stages/{stageId}" class="flex items-center gap-2 text-[13px] font-medium text-[#1C50A7] hover:text-[#1845a0] transition-colors">
                Kembali ke Stage
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>
              </a>
            {/if}
          </div>
        {/if}
      </div>
    </main>
  </div>
</div>
