<script lang="ts">
  // Greeting — time-based salutation with the user's first name
  import type { User } from '#lib/types/learning';
  import { getGreeting } from '#lib/utils/greeting';

  interface Props {
    user: User;
  }

  const { user }: Props = $props();

  const greeting = $derived(getGreeting(user.firstName));
</script>

<div>
  <!-- Greeting heading -->
  <h1 class="text-[28px] font-bold text-[#1A2B4A] leading-tight">
    {greeting}
  </h1>

  <!-- Supporting text -->
  <p class="mt-1 text-[14px] text-[#5B7A9E] leading-relaxed">
    Lanjutkan perjalanan belajarmu dan jadi versi terbaik hari ini.
  </p>
</div>
