<script lang="ts">
  interface Props {
    stageCount: number;
    loading?: boolean;
  }

  const { stageCount, loading = false }: Props = $props();
</script>

<div class="flex items-start justify-between gap-4">
  <!-- Left: breadcrumb + heading -->
  <div class="flex flex-col">
    <nav aria-label="Breadcrumb">
      <ol class="flex items-center gap-1.5 text-[12px]">
        <li>
          <a
            href="/"
            class="text-gray-400 hover:text-[#1C50A7] transition-colors"
          >
            Home
          </a>
        </li>
        <li class="text-gray-300" aria-hidden="true">/</li>
        <li>
          <span class="text-[#1C50A7] font-medium" aria-current="page">Learning</span>
        </li>
      </ol>
    </nav>

    <h1 class="text-[26px] font-bold text-[#1A2B4A] leading-tight mt-1">
      Growth Journey
    </h1>
    <p class="text-[14px] text-[#5B7A9E] mt-1">
      Jelajahi perjalanan belajarmu dan kembangkan kemampuanmu selangkah demi selangkah.
    </p>
  </div>

  <!-- Right: stage count pill -->
  <div class="shrink-0 mt-1">
    {#if loading}
      <div class="h-8 w-24 bg-gray-100 rounded-xl animate-pulse"></div>
    {:else}
      <div class="bg-[#EFF4FC] rounded-xl px-3 py-2 flex items-center gap-2">
        <!-- Book icon -->
        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#1C50A7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z"/>
          <path d="M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z"/>
        </svg>
        <span class="text-[13px] font-semibold text-[#1C50A7]">{stageCount} Stage</span>
      </div>
    {/if}
  </div>
</div>
