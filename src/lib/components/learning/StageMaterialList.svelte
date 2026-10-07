<script lang="ts">
  import type { Material } from '#lib/types/learning';

  interface Props {
    materials: Material[];
    loading?: boolean;
  }

  const { materials, loading = false }: Props = $props();
</script>

<div class="mt-3 bg-white rounded-2xl border border-[#E8EEF8] overflow-hidden">
  <!-- Header -->
  <div class="flex items-center justify-between px-5 py-3.5 border-b border-[#E8EEF8]">
    <span class="text-[13px] font-semibold text-[#1A2B4A]">Materi dalam Stage ini</span>
    {#if !loading}
      <span class="text-[11px] font-semibold text-[#1C50A7] bg-[#EFF4FC] px-2 py-0.5 rounded-full">
        {materials.length} materi
      </span>
    {/if}
  </div>

  {#if loading}
    <!-- Loading skeleton -->
    <ul role="list">
      {#each [1, 2, 3] as _}
        <li class="flex items-center gap-3 px-5 py-3 border-b border-[#F0F4FA] last:border-0">
          <div class="w-5 h-5 rounded-full bg-gray-100 animate-pulse shrink-0"></div>
          <div class="flex-1 h-4 bg-gray-100 rounded animate-pulse"></div>
          <div class="w-24 h-3 bg-gray-100 rounded animate-pulse shrink-0"></div>
        </li>
      {/each}
    </ul>
  {:else}
    <ul role="list">
      {#each materials as material, i (material.id)}
        <li
          role="listitem"
          class={[
            'flex items-center gap-3 px-5 py-3 hover:bg-[#F8FAFF] transition-colors',
            i < materials.length - 1 ? 'border-b border-[#F0F4FA]' : '',
          ].join(' ')}
        >
          <!-- Status icon -->
          <div class="shrink-0 w-5 h-5">
            {#if material.status === 'completed'}
              <!-- Filled green circle with checkmark -->
              <svg width="20" height="20" viewBox="0 0 20 20" fill="none" aria-hidden="true">
                <circle cx="10" cy="10" r="10" fill="#27AE78"/>
                <polyline points="5,10 8.5,13.5 15,7" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
              </svg>
            {:else}
              <!-- Gray outline circle -->
              <svg width="20" height="20" viewBox="0 0 20 20" fill="none" aria-hidden="true">
                <circle cx="10" cy="10" r="9" stroke="#CBD5E1" stroke-width="1.5" fill="none"/>
              </svg>
            {/if}
          </div>

          <!-- Title -->
          <p class="flex-1 text-[13px] font-medium text-gray-800">{material.title}</p>

          <!-- Meta -->
          <span class="text-[12px] text-gray-400 shrink-0">
            {material.estimatedMinutes} menit · +{material.pointReward} pt
          </span>
        </li>
      {/each}
    </ul>
  {/if}
</div>
