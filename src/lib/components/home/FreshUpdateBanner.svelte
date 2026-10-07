<script lang="ts">
  import type { FreshUpdate } from '#lib/types/learning';

  interface Props {
    update: FreshUpdate;
  }

  const { update }: Props = $props();

  function handleAction() {
    console.log('Fresh update action clicked');
  }
</script>

<!--
  Fresh Update Banner — light blue gradient bg, text on left, image on right,
  circular arrow button over the right side.
-->
<div
  class="relative overflow-hidden rounded-2xl flex items-stretch"
  style="min-height: 108px; background: linear-gradient(135deg, #DBE9F9 0%, #C8DCF0 100%);"
  aria-label="Fresh Update: {update.title}"
>
  <!-- ── Left: text content ────────────────────────────────────────── -->
  <div class="flex flex-col justify-center gap-1.5 px-6 py-5 flex-1 z-10 min-w-0">

    <!-- "Fresh Update" label with star icon -->
    <div class="flex items-center gap-1.5">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="#F2AC44" stroke="none" aria-hidden="true">
        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/>
      </svg>
      <span class="text-[11px] font-bold text-[#F2AC44] uppercase tracking-widest">
        {update.label}
      </span>
    </div>

    <!-- Headline -->
    <p class="text-[20px] font-bold text-[#1C3A6B] leading-tight">{update.title}</p>

    <!-- Subtitle -->
    <p class="text-[13px] text-[#5B7A9E]">{update.subtitle}</p>
  </div>

  <!-- ── Right: image section ──────────────────────────────────────── -->
  <div class="w-[44%] max-w-[280px] shrink-0 relative hidden sm:block overflow-hidden">
    <!-- Left fade overlay so image blends into the blue bg -->
    <div
      class="absolute inset-y-0 left-0 w-24 z-10 pointer-events-none"
      style="background: linear-gradient(to right, #CBE0F5 0%, transparent 100%);"
      aria-hidden="true"
    ></div>
    <img
      src={update.imageUrl || 'https://picsum.photos/seed/clinic1/800/200'}
      alt="Klinik Audy Dental"
      class="w-full h-full object-cover"
      loading="eager"
      referrerpolicy="no-referrer"
      onerror={(e) => { (e.currentTarget as HTMLImageElement).style.display='none' }}
    />
  </div>

  <!-- ── Circular arrow button — overlaid on right side ────────────── -->
  <div class="absolute right-4 top-1/2 -translate-y-1/2 z-20">
    <button
      type="button"
      onclick={handleAction}
      class="w-10 h-10 rounded-full bg-white shadow-md flex items-center justify-center focus:outline-none focus-visible:ring-2 focus-visible:ring-[#1C50A7]"
      aria-label="Lihat informasi terbaru"
    >
      <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
        <polyline points="9 18 15 12 9 6"/>
      </svg>
    </button>
  </div>
</div>
