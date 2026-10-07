<script lang="ts">
  // Admin Dashboard — mock data for now, Supabase integration ready
  const stats = [
    { label: 'Total Users', value: '24', icon: 'M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2 M9 11a4 4 0 1 0 0-8 4 4 0 0 0 0 8z', color: '#1C50A7', bg: '#EFF4FC' },
    { label: 'Active Users', value: '18', icon: 'M22 11.08V12a10 10 0 1 1-5.93-9.14 M22 4 12 14.01l-3-3', color: '#27AE78', bg: '#DCFCE7' },
    { label: 'Published Stages', value: '4', icon: 'M12 2 2 7l10 5 10-5-10-5z M2 17l10 5 10-5 M2 12l10 5 10-5', color: '#1C50A7', bg: '#EFF4FC' },
    { label: 'Total Materials', value: '20', icon: 'M2 3h6a4 4 0 0 1 4 4v14a3 3 0 0 0-3-3H2z M22 3h-6a4 4 0 0 0-4 4v14a3 3 0 0 1 3-3h7z', color: '#7C5CBF', bg: '#F3EEFF' },
    { label: 'Avg Score', value: '82', icon: 'M18 20V10 M12 20V4 M6 20v-6', color: '#D97706', bg: '#FEF3C7' },
    { label: 'Points Distributed', value: '2,450', icon: 'M12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2', color: '#F2AC44', bg: '#FEF9EE' }
  ];

  const recentActivity = [
    { user: 'Nanda Pratama', action: 'Menyelesaikan materi', detail: 'Greeting & Patient Communication', time: '5 menit lalu' },
    { user: 'Budi Santoso', action: 'Memulai stage', detail: 'Level Up Your Role', time: '1 jam lalu' },
    { user: 'Admin', action: 'Mempublish materi', detail: 'Professional Communication', time: '2 jam lalu' },
    { user: 'Sari Dewi', action: 'Menyelesaikan kuis', detail: 'Kuis Stage 1 — Skor: 90', time: '3 jam lalu' },
    { user: 'Ahmad Fauzi', action: 'Login', detail: 'Front Office · HO', time: '4 jam lalu' },
  ];
</script>

<svelte:head><title>Admin Dashboard — Audy Learning Centre</title></svelte:head>

<div class="p-7">
  <!-- Header -->
  <div class="mb-7">
    <h1 class="text-[22px] font-bold text-[#1A2B4A]">Admin Dashboard</h1>
    <p class="text-[13px] text-gray-400 mt-0.5">Ringkasan platform Audy Learning Centre</p>
  </div>

  <!-- Stat cards -->
  <div class="grid grid-cols-2 lg:grid-cols-3 gap-4 mb-8">
    {#each stats as stat}
      <div class="bg-white rounded-2xl border border-[#E8EEF8] p-5 flex items-center gap-4">
        <div class="w-10 h-10 rounded-xl flex items-center justify-center shrink-0" style="background-color: {stat.bg};">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="{stat.color}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d={stat.icon}/>
          </svg>
        </div>
        <div>
          <p class="text-[12px] text-gray-400">{stat.label}</p>
          <p class="text-[22px] font-bold text-[#1A2B4A] leading-tight">{stat.value}</p>
        </div>
      </div>
    {/each}
  </div>

  <!-- Recent activity -->
  <div class="bg-white rounded-2xl border border-[#E8EEF8] p-5">
    <div class="flex items-center justify-between mb-4">
      <h2 class="text-[15px] font-semibold text-[#1A2B4A]">Aktivitas Terbaru</h2>
      <a href="/admin/audit-logs" class="text-[12px] text-[#1C50A7] hover:underline">Lihat semua →</a>
    </div>
    <div class="overflow-x-auto">
      <table class="w-full text-[13px]">
        <thead>
          <tr class="border-b border-[#F0F4FA]">
            <th class="text-left pb-3 font-medium text-gray-400 pr-4">User</th>
            <th class="text-left pb-3 font-medium text-gray-400 pr-4">Aktivitas</th>
            <th class="text-left pb-3 font-medium text-gray-400 pr-4">Detail</th>
            <th class="text-left pb-3 font-medium text-gray-400">Waktu</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-[#F0F4FA]">
          {#each recentActivity as row}
            <tr>
              <td class="py-3 pr-4 font-medium text-gray-800">{row.user}</td>
              <td class="py-3 pr-4 text-gray-600">{row.action}</td>
              <td class="py-3 pr-4 text-gray-500">{row.detail}</td>
              <td class="py-3 text-gray-400">{row.time}</td>
            </tr>
          {/each}
        </tbody>
      </table>
    </div>
  </div>
</div>
