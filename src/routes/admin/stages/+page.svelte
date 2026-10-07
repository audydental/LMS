<script lang="ts">
  import { mockStages } from '#lib/mocks/stages';

  const stages = mockStages;

  function getStatusBadge(status: string) {
    if (status === 'active') return { label: 'Published', color: '#16A34A', bg: '#DCFCE7' };
    if (status === 'inactive') return { label: 'Archived', color: '#D97706', bg: '#FEF3C7' };
    return { label: 'Draft', color: '#6B7280', bg: '#F3F4F6' };
  }
</script>

<svelte:head><title>Admin — Stages</title></svelte:head>

<div class="p-7">
  <div class="flex items-center justify-between mb-6">
    <div>
      <h1 class="text-[20px] font-bold text-[#1A2B4A]">Stage Management</h1>
      <p class="text-[13px] text-gray-400 mt-0.5">{stages.length} stage terdaftar</p>
    </div>
    <button type="button" class="bg-[#1C50A7] text-white rounded-xl px-4 py-2.5 text-[13px] font-semibold hover:bg-[#1845a0] transition-colors flex items-center gap-2">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
      Tambah Stage
    </button>
  </div>

  <div class="bg-white rounded-2xl border border-[#E8EEF8] overflow-hidden">
    <table class="w-full text-[13px]">
      <thead class="bg-[#F8FAFF]">
        <tr>
          <th class="text-left px-5 py-3.5 font-semibold text-gray-500">Urutan</th>
          <th class="text-left px-5 py-3.5 font-semibold text-gray-500">Stage</th>
          <th class="text-left px-5 py-3.5 font-semibold text-gray-500">Status</th>
          <th class="text-left px-5 py-3.5 font-semibold text-gray-500">Materi</th>
          <th class="text-left px-5 py-3.5 font-semibold text-gray-500">Point Reward</th>
          <th class="text-left px-5 py-3.5 font-semibold text-gray-500">Aksi</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-[#F0F4FA]">
        {#each stages as stage}
          {@const badge = getStatusBadge(stage.status)}
          <tr class="hover:bg-[#F8FAFF] transition-colors">
            <td class="px-5 py-4">
              <span class="w-7 h-7 bg-[#EFF4FC] text-[#1C50A7] rounded-full flex items-center justify-center text-[11px] font-bold">
                {stage.sequence}
              </span>
            </td>
            <td class="px-5 py-4">
              <p class="font-semibold text-gray-800">{stage.title}</p>
              <p class="text-gray-400 text-[12px] mt-0.5 line-clamp-1">{stage.description}</p>
            </td>
            <td class="px-5 py-4">
              <span class="text-[11px] font-semibold rounded-full px-2.5 py-1" style="color: {badge.color}; background-color: {badge.bg};">{badge.label}</span>
            </td>
            <td class="px-5 py-4 text-gray-600">{stage.totalMaterials} materi</td>
            <td class="px-5 py-4 text-[#D97706] font-semibold">+{stage.pointReward}</td>
            <td class="px-5 py-4">
              <div class="flex items-center gap-2">
                <button type="button" class="text-[12px] font-medium text-gray-500 hover:text-[#1C50A7] border border-[#E8EEF8] rounded-lg px-3 py-1.5 transition-colors">Edit</button>
                <button type="button" class="text-[12px] font-medium text-gray-500 hover:text-[#1C50A7] border border-[#E8EEF8] rounded-lg px-3 py-1.5 transition-colors">
                  {stage.status === 'active' ? 'Archive' : 'Publish'}
                </button>
              </div>
            </td>
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
</div>
