<script lang="ts">
  import type { Stage, Material } from '#lib/types/learning';
  import JourneyStage from './JourneyStage.svelte';
  import StageMaterialList from './StageMaterialList.svelte';

  interface Props {
    stages: Stage[];
    materialsByStage: Record<string, Material[]>;
    selectedStageId?: string | null;
    onStageSelect?: (stageId: string) => void;
    loading?: boolean;
  }

  const { stages, materialsByStage, selectedStageId = null, onStageSelect, loading = false }: Props = $props();

  // Find the current stage: first active + not completed, or first active
  const currentStageId = $derived(
    (() => {
      const inProgress = stages.find((s) => s.isActive && !s.isCompleted);
      if (inProgress) return inProgress.id;
      const firstActive = stages.find((s) => s.isActive);
      return firstActive?.id ?? null;
    })()
  );

  function getMarginLeft(sequence: number): number {
    return Math.min((sequence - 1) * 40, 160);
  }

  function handleSelect(stageId: string) {
    onStageSelect?.(stageId);
  }
</script>

{#if loading}
  <!-- Loading skeletons -->
  <div class="flex flex-col gap-4">
    {#each [1, 2, 3, 4] as _}
      <div class="h-[140px] bg-white rounded-[18px] border border-[#E8EEF8] animate-pulse"></div>
    {/each}
  </div>

{:else if stages.length === 0}
  <!-- Empty state -->
  <div class="flex flex-col items-center justify-center py-16 text-center">
    <div class="w-14 h-14 rounded-full bg-[#EFF4FC] flex items-center justify-center mb-4">
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
        <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
      </svg>
    </div>
    <p class="text-[15px] font-semibold text-gray-600">Belum ada stage</p>
    <p class="text-[13px] text-gray-400 mt-1">Stage pembelajaran akan segera ditambahkan.</p>
  </div>

{:else}
  <!-- Desktop staircase layout -->
  <div class="hidden md:flex flex-col gap-4" aria-label="Daftar stage pembelajaran">
    {#each stages as stage (stage.id)}
      {@const marginLeft = getMarginLeft(stage.sequence)}
      {@const maxWidth = `calc(100% - ${marginLeft}px)`}
      <div style="margin-left: {marginLeft}px; max-width: {maxWidth};">
        <JourneyStage
          {stage}
          materials={materialsByStage[stage.id] ?? []}
          isCurrentStage={stage.id === currentStageId}
          onSelect={handleSelect}
        />
        {#if selectedStageId === stage.id}
          <StageMaterialList materials={materialsByStage[stage.id] ?? []} />
        {/if}
      </div>
    {/each}
  </div>

  <!-- Mobile vertical layout -->
  <div class="flex md:hidden flex-col" aria-label="Daftar stage pembelajaran">
    {#each stages as stage, i (stage.id)}
      <div class="flex gap-3">
        <!-- Left connector column -->
        <div class="flex flex-col items-center">
          <!-- Sequence circle -->
          <div
            class="w-8 h-8 rounded-full flex items-center justify-center text-[12px] font-bold shrink-0 text-white"
            style="background-color: {stage.id === currentStageId ? '#1C50A7' : '#C8D8ED'};"
          >
            {stage.sequence}
          </div>
          <!-- Connector line (not for last item) -->
          {#if i < stages.length - 1}
            <div class="flex-1 w-[2px] bg-[#E8EEF8] my-1 min-h-[16px]"></div>
          {/if}
        </div>

        <!-- Right: stage card + optional materials -->
        <div class="flex-1 pb-4">
          <JourneyStage
            {stage}
            materials={materialsByStage[stage.id] ?? []}
            isCurrentStage={stage.id === currentStageId}
            onSelect={handleSelect}
          />
          {#if selectedStageId === stage.id}
            <StageMaterialList materials={materialsByStage[stage.id] ?? []} />
          {/if}
        </div>
      </div>
    {/each}
  </div>
{/if}
