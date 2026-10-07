<script lang="ts">
  let searchQuery = $state('');

  const mockUsers = [
    { id: '1', employeeId: 'AUD-001', name: 'Nanda Pratama', department: 'Head Office', position: 'Front Office', role: 'employee', status: 'active', completedStages: 0, totalPoint: 50 },
    { id: '2', employeeId: 'AUD-002', name: 'Budi Santoso', department: 'Klinik Utama', position: 'Dokter Gigi', role: 'employee', status: 'active', completedStages: 1, totalPoint: 120 },
    { id: '3', employeeId: 'AUD-003', name: 'Sari Dewi', department: 'Klinik Utama', position: 'Perawat Gigi', role: 'employee', status: 'active', completedStages: 2, totalPoint: 280 },
    { id: '4', employeeId: 'AUD-004', name: 'Ahmad Fauzi', department: 'Head Office', position: 'HRD', role: 'employee', status: 'active', completedStages: 0, totalPoint: 30 },
    { id: '5', employeeId: 'AUD-ADM', name: 'Admin Audy', department: 'Head Office', position: 'Learning & Development', role: 'admin', status: 'active', completedStages: 4, totalPoint: 700 },
  ];

  const filtered = $derived(
    mockUsers.filter(u =>
      searchQuery === '' ||
      u.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      u.employeeId.toLowerCase().includes(searchQuery.toLowerCase())
    )
  );

  function getRoleBadge(role: string) {
    if (role === 'admin' || role === 'super_admin') return { label: role === 'super_admin' ? 'Super Admin' : 'Admin', color: '#DC2626', bg: '#FEF2F2' };
    return { label: 'Employee', color: '#1C50A7', bg: '#EFF4FC' };
  }
</script>

<svelte:head><title>Admin — Users</title></svelte:head>

<div class="p-7">
  <div class="flex items-center justify-between mb-6">
    <div>
      <h1 class="text-[20px] font-bold text-[#1A2B4A]">User Management</h1>
      <p class="text-[13px] text-gray-400 mt-0.5">{mockUsers.length} user terdaftar</p>
    </div>
    <button type="button" class="bg-[#1C50A7] text-white rounded-xl px-4 py-2.5 text-[13px] font-semibold hover:bg-[#1845a0] transition-colors flex items-center gap-2">
      <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
      Tambah User
    </button>
  </div>

  <!-- Search -->
  <div class="relative max-w-sm mb-5">
    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="#9CA3AF" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="absolute left-3 top-1/2 -translate-y-1/2 pointer-events-none" aria-hidden="true"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
    <input type="search" bind:value={searchQuery} placeholder="Cari nama atau ID karyawan..." class="w-full pl-9 pr-4 h-10 bg-white border border-[#E8EEF8] rounded-xl text-[13px] focus:outline-none focus:ring-2 focus:ring-[#1C50A7]/20 focus:border-[#1C50A7]" />
  </div>

  <div class="bg-white rounded-2xl border border-[#E8EEF8] overflow-hidden">
    <table class="w-full text-[13px]">
      <thead class="bg-[#F8FAFF]">
        <tr>
          <th class="text-left px-5 py-3.5 font-semibold text-gray-500">Employee ID</th>
          <th class="text-left px-5 py-3.5 font-semibold text-gray-500">Nama</th>
          <th class="text-left px-5 py-3.5 font-semibold text-gray-500">Departemen</th>
          <th class="text-left px-5 py-3.5 font-semibold text-gray-500">Role</th>
          <th class="text-left px-5 py-3.5 font-semibold text-gray-500">Point</th>
          <th class="text-left px-5 py-3.5 font-semibold text-gray-500">Status</th>
          <th class="text-left px-5 py-3.5 font-semibold text-gray-500">Aksi</th>
        </tr>
      </thead>
      <tbody class="divide-y divide-[#F0F4FA]">
        {#each filtered as user}
          {@const roleBadge = getRoleBadge(user.role)}
          <tr class="hover:bg-[#F8FAFF] transition-colors">
            <td class="px-5 py-3.5 text-gray-500 font-mono text-[12px]">{user.employeeId}</td>
            <td class="px-5 py-3.5 font-semibold text-gray-800">{user.name}</td>
            <td class="px-5 py-3.5 text-gray-500">{user.department}</td>
            <td class="px-5 py-3.5">
              <span class="text-[11px] font-semibold rounded-full px-2.5 py-1" style="color: {roleBadge.color}; background-color: {roleBadge.bg};">{roleBadge.label}</span>
            </td>
            <td class="px-5 py-3.5 font-semibold text-[#D97706]">{user.totalPoint}</td>
            <td class="px-5 py-3.5">
              <span class="text-[11px] font-semibold rounded-full px-2.5 py-1 {user.status === 'active' ? 'text-[#16A34A] bg-[#DCFCE7]' : 'text-gray-500 bg-gray-100'}">
                {user.status === 'active' ? 'Aktif' : 'Nonaktif'}
              </span>
            </td>
            <td class="px-5 py-3.5">
              <div class="flex items-center gap-2">
                <button type="button" class="text-[12px] font-medium text-gray-500 hover:text-[#1C50A7] border border-[#E8EEF8] rounded-lg px-3 py-1.5 transition-colors">Edit</button>
                <button type="button" class="text-[12px] font-medium text-gray-500 hover:text-red-600 border border-[#E8EEF8] rounded-lg px-3 py-1.5 transition-colors">
                  {user.status === 'active' ? 'Nonaktifkan' : 'Aktifkan'}
                </button>
              </div>
            </td>
          </tr>
        {/each}
      </tbody>
    </table>
    {#if filtered.length === 0}
      <div class="text-center py-12 text-gray-400">
        <p class="text-[14px]">Tidak ada user ditemukan</p>
      </div>
    {/if}
  </div>
</div>
