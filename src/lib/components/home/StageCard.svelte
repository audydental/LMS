<script lang="ts">
  import type { Stage } from '#lib/types/learning';
  import type { StageTheme } from '#lib/utils/stageTheme';

  interface Props {
    stage: Stage;
    theme: StageTheme;
  }

  const { stage, theme }: Props = $props();

  function handleContinue() {
    console.log('Navigate to stage materials:', stage.id);
  }
</script>

<article
  class="rounded-[18px] bg-white border border-[#E8EEF8] overflow-hidden flex flex-col min-w-[280px] w-[280px] shrink-0 shadow-[0_1px_4px_rgba(0,0,0,0.06)] hover:shadow-[0_4px_16px_rgba(28,80,167,0.10)] transition-shadow duration-200"
  aria-label="Stage {stage.sequence}: {stage.title}"
>
  <!-- ── Photo section ───────────────────────────────────────────── -->
  <div class="relative h-[148px] bg-[#C8DCF0] overflow-hidden">
    <img
      src={stage.image}
      alt="Stage {stage.sequence} — {stage.title}"
      class="w-full h-full object-cover"
      loading="lazy"
      referrerpolicy="no-referrer"
      onerror={(e) => { (e.currentTarget as HTMLImageElement).style.display='none' }}
    />
    <!-- Gradient overlay -->
    <div
      class="absolute inset-0 bg-gradient-to-t from-black/25 via-transparent to-transparent"
      aria-hidden="true"
    ></div>

    <!-- Stage badge — overlaid on bottom-left of photo -->
    <span
      class="absolute bottom-3 left-3 text-[11px] font-semibold px-2.5 py-1 rounded-md leading-none text-white bg-[#1C50A7]"
    >
      Stage {stage.sequence}
    </span>
  </div>

  <!-- ── Card content ────────────────────────────────────────────── -->
  <div class="flex flex-col flex-1 p-4 gap-2">
    <!-- Title -->
    <h3 class="text-[16px] font-semibold text-gray-900 leading-snug">
      {stage.title}
    </h3>

    <!-- Description -->
    <p class="text-[13px] text-gray-500 leading-relaxed line-clamp-2 flex-1">
      {stage.description}
    </p>

    <!-- Material progress row -->
    <div class="mt-1">
      <div class="flex items-center justify-between mb-1.5">
        <span class="text-[12px] text-gray-400">
          {stage.completedMaterials} dari {stage.totalMaterials} materi
        </span>
        <span class="text-[12px] font-medium" style="color: {theme.color}">
          {stage.progress}%
        </span>
      </div>
      <!-- Progress bar -->
      <div class="w-full h-[5px] bg-gray-100 rounded-full overflow-hidden">
        <div
          class="h-full rounded-full transition-all duration-500"
          style="width: {stage.progress}%; background-color: {theme.color};"
          role="progressbar"
          aria-valuenow={stage.progress}
          aria-valuemin={0}
          aria-valuemax={100}
          aria-label="{stage.progress}% selesai"
        ></div>
      </div>
    </div>

    <!-- CTA row -->
    <div class="flex items-center justify-between mt-2 pt-2 border-t border-[#F0F4FA]">
      <button
        type="button"
        onclick={handleContinue}
        class="text-[13px] font-semibold text-[#1C50A7] hover:underline focus:outline-none focus:underline"
        aria-label="Lanjutkan belajar stage {stage.sequence}: {stage.title}"
      >
        Lanjutkan Belajar
      </button>
      <!-- Circular arrow button -->
      <button
        type="button"
        onclick={handleContinue}
        class="w-8 h-8 rounded-full bg-[#1C50A7] flex items-center justify-center transition-opacity hover:opacity-80 focus:outline-none focus-visible:ring-2 focus-visible:ring-offset-1"
        aria-hidden="true"
        tabindex="-1"
      >
        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <line x1="5" y1="12" x2="19" y2="12"/>
          <polyline points="12 5 19 12 12 19"/>
        </svg>
      </button>
    </div>
  </div>
</article>
