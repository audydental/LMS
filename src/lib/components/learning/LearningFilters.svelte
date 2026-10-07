<script lang="ts">
  type FilterValue = 'all' | 'in_progress' | 'completed';

  interface Props {
    activeFilter?: FilterValue;
    onFilterChange?: (f: FilterValue) => void;
  }

  const { activeFilter = 'all', onFilterChange }: Props = $props();

  const filters: { value: FilterValue; label: string }[] = [
    { value: 'all', label: 'Semua' },
    { value: 'in_progress', label: 'Sedang Berjalan' },
    { value: 'completed', label: 'Selesai' },
  ];
</script>

<div class="flex items-center gap-2 flex-wrap mb-5" role="group" aria-label="Filter stage">
  {#each filters as filter (filter.value)}
    <button
      type="button"
      onclick={() => onFilterChange?.(filter.value)}
      class={
        activeFilter === filter.value
          ? 'bg-[#1C50A7] text-white border border-transparent rounded-full px-4 py-1.5 text-[13px] font-semibold transition-colors'
          : 'bg-white border border-[#E8EEF8] text-gray-500 rounded-full px-4 py-1.5 text-[13px] font-medium hover:bg-gray-50 hover:border-[#1C50A7] hover:text-[#1C50A7] transition-colors'
      }
      aria-pressed={activeFilter === filter.value}
    >
      {filter.label}
    </button>
  {/each}
</div>
