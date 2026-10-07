<script lang="ts">
  import type { Stage, Material, StageDisplayStatus } from '#lib/types/learning';
  import { getStageTheme } from '#lib/utils/stageTheme';

  interface Props {
    stage: Stage;
    materials: Material[];
    isCurrentStage?: boolean;
    onSelect?: (stageId: string) => void;
  }

  const { stage, materials, isCurrentStage = false, onSelect }: Props = $props();

  const theme = $derived(getStageTheme(stage.sequence));

  const completedCount = $derived(materials.filter((m) => m.status === 'completed').length);
  const totalCount = $derived(materials.length);
  const progressPct = $derived(totalCount > 0 ? Math.round((completedCount / totalCount) * 100) : 0);

  const displayStatus = $derived<StageDisplayStatus>(
    // Locked check: gate on status !== 'active' only (not on isActive).
    // All mock stages are status:'active', so no stage is locked by default.
    // This is intentional — the LMS spec says stages should remain open unless
    // business rules explicitly require locking. The 'locked' visual branch is
    // implemented and ready for future use when an inactive stage is introduced.
    stage.status !== 'active'
      ? 'locked'
      : completedCount === totalCount && totalCount > 0
        ? 'completed'
        : completedCount > 0
          ? 'in_progress'
          : 'available'
  );

  const ctaLabel = $derived(
    displayStatus === 'completed'
      ? 'Review'
      : displayStatus === 'in_progress'
        ? 'Lanjutkan Belajar'
        : 'Mulai Belajar'
  );

  const progressBarColor = $derived(displayStatus === 'completed' ? '#27AE78' : theme.color);

  function handleImageError(e: Event) {
    const img = e.target as HTMLImageElement;
    img.src = `https://picsum.photos/seed/stage${stage.sequence}/600/300`;
  }
</script>

<article
  class={[
    'bg-white rounded-[18px] overflow-hidden flex flex-col sm:flex-row shadow-[0_1px_4px_rgba(0,0,0,0.06)] hover:shadow-[0_4px_16px_rgba(28,80,167,0.10)] transition-all duration-200',
    isCurrentStage ? 'border-[2px] border-[#1C50A7]' : 'border border-[#E8EEF8]',
  ].join(' ')}
  aria-label={`Stage ${stage.sequence}: ${stage.title}`}
>
  <!-- ── Left: image section ──────────────────────────────────────── -->
  <div
    class={[
      'relative w-full sm:w-[160px] sm:shrink-0 h-[160px] sm:h-auto',
      displayStatus === 'locked' ? 'opacity-60' : '',
    ].join(' ')}
  >
    <img
      src={stage.image}
      alt={stage.title}
      class="w-full h-full object-cover"
      onerror={handleImageError}
    />
    <!-- Gradient overlay -->
    <div class="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent"></div>

    <!-- "Tahap Saat Ini" badge — top left when isCurrentStage -->
    {#if isCurrentStage}
      <div class="absolute top-0 left-0 bg-[#1C50A7] text-white text-[10px] font-bold px-2 py-0.5 rounded-br-md">
        Tahap Saat Ini
      </div>
    {/if}

    <!-- Stage number badge — bottom left -->
    <div class="absolute bottom-2 left-2 bg-black/60 text-white text-[11px] font-bold px-2 py-0.5 rounded">
      Stage {stage.sequence}
    </div>
  </div>

  <!-- ── Right: content section ──────────────────────────────────── -->
  <div class="p-5 flex flex-col flex-1 justify-between gap-3">

    <!-- Top section -->
    <div>
      <!-- Stage label row -->
      <div class="flex items-center gap-2 mb-1">
        <span class="text-[11px] font-medium text-gray-400 uppercase tracking-wide">
          Stage {stage.sequence}
        </span>
        {#if displayStatus === 'completed'}
          <span class="inline-flex items-center gap-1 text-[11px] font-semibold text-[#27AE78] bg-[#E8F8F2] rounded-full px-2 py-0.5">
            <svg width="10" height="10" viewBox="0 0 10 10" fill="none" aria-hidden="true">
              <polyline points="1.5,5 4,7.5 8.5,2" stroke="#27AE78" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            Selesai
          </span>
        {/if}
      </div>

      <!-- Title -->
      <h3 class="text-[17px] font-bold text-[#1A2B4A] leading-tight">{stage.title}</h3>

      <!-- Description -->
      <p class="text-[13px] text-gray-500 leading-snug line-clamp-2 mt-0.5">{stage.description}</p>
    </div>

    <!-- Middle section: progress -->
    <div>
      <div class="flex items-center justify-between mb-1">
        <span class="text-[12px] text-gray-400">
          {completedCount} dari {totalCount} materi
        </span>
        <span class="text-[12px] font-semibold" style="color: {progressBarColor}">
          {progressPct}%
        </span>
      </div>
      <div class="h-[6px] bg-gray-100 rounded-full overflow-hidden" role="progressbar" aria-valuenow={progressPct} aria-valuemin={0} aria-valuemax={100}>
        <div
          class="h-full rounded-full transition-all duration-500"
          style="width: {progressPct}%; background-color: {progressBarColor};"
        ></div>
      </div>
    </div>

    <!-- Bottom row: point + CTA -->
    <div class="flex items-center justify-between pt-2 border-t border-[#F0F4FA]">
      <!-- Point pill -->
      <span class="text-[12px] font-semibold text-[#D97706] bg-[#FEF3C7] rounded-full px-2.5 py-1">
        +{stage.pointReward} point
      </span>

      <!-- CTA button -->
      {#if displayStatus === 'locked'}
        <button
          type="button"
          disabled
          class="rounded-xl px-4 py-2 text-[13px] font-semibold bg-gray-100 text-gray-400 opacity-50 cursor-not-allowed flex items-center gap-1.5"
          aria-disabled="true"
        >
          <!-- Lock icon -->
          <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
            <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
          </svg>
          Terkunci
        </button>
      {:else if displayStatus === 'completed'}
        <button
          type="button"
          onclick={() => onSelect?.(stage.id)}
          class="rounded-xl px-4 py-2 text-[13px] font-semibold bg-white border border-[#1C50A7] text-[#1C50A7] hover:bg-[#EFF4FC] transition-colors"
        >
          {ctaLabel}
        </button>
      {:else}
        <button
          type="button"
          onclick={() => onSelect?.(stage.id)}
          class="rounded-xl px-4 py-2 text-[13px] font-semibold bg-[#1C50A7] text-white hover:bg-[#1845a0] transition-colors"
        >
          {ctaLabel}
        </button>
      {/if}
    </div>
  </div>
</article>
