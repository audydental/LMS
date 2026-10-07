<script lang="ts">
  import type { ActionData } from './$types';

  interface Props {
    form: ActionData;
  }

  const { form }: Props = $props();

  let loading = $state(false);
</script>

<svelte:head>
  <title>Masuk — Audy Learning Centre</title>
</svelte:head>

<div class="min-h-screen bg-[#F4F7FD] flex items-center justify-center px-4">
  <div class="w-full max-w-[400px]">

    <!-- Logo -->
    <div class="text-center mb-8">
      <div class="inline-flex flex-col items-center">
        <div class="flex items-baseline gap-1.5 mb-1">
          <span class="text-[#1C3A6B] font-extrabold italic text-[26px] leading-none" style="font-family: Georgia, serif;">Audy</span>
          <span class="text-[#1C3A6B] font-bold text-[13px] tracking-[0.18em] leading-none">DENTAL</span>
        </div>
        <span class="text-[#1C50A7] text-[13px] font-medium tracking-wide">Learning Centre</span>
      </div>
    </div>

    <!-- Card -->
    <div class="bg-white rounded-2xl border border-[#E8EEF8] p-8 shadow-[0_2px_16px_rgba(28,80,167,0.08)]">

      <h1 class="text-[20px] font-bold text-[#1A2B4A] mb-1">Masuk ke akun Anda</h1>
      <p class="text-[13px] text-gray-400 mb-6">Gunakan email dan password yang telah diberikan.</p>

      <!-- Error message -->
      {#if form?.error}
        <div class="bg-red-50 border border-red-200 rounded-xl px-4 py-3 mb-5 flex items-start gap-2" role="alert">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#DC2626" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="shrink-0 mt-0.5" aria-hidden="true">
            <circle cx="12" cy="12" r="10"/>
            <line x1="12" y1="8" x2="12" y2="12"/>
            <line x1="12" y1="16" x2="12.01" y2="16"/>
          </svg>
          <p class="text-[13px] text-red-700">{form.error}</p>
        </div>
      {/if}

      <!-- Login form -->
      <form
        method="POST"
        onsubmit={() => { loading = true; }}
        class="flex flex-col gap-4"
      >
        <!-- Email -->
        <div>
          <label for="email" class="block text-[13px] font-medium text-gray-600 mb-1.5">
            Email
          </label>
          <input
            id="email"
            name="email"
            type="email"
            required
            autocomplete="email"
            placeholder="nama@audydental.com"
            class="w-full h-11 px-3.5 bg-gray-50 border border-[#E8EEF8] rounded-xl text-[14px] text-gray-800 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#1C50A7]/20 focus:border-[#1C50A7] transition-colors"
          />
        </div>

        <!-- Password -->
        <div>
          <label for="password" class="block text-[13px] font-medium text-gray-600 mb-1.5">
            Password
          </label>
          <input
            id="password"
            name="password"
            type="password"
            required
            autocomplete="current-password"
            placeholder="••••••••"
            class="w-full h-11 px-3.5 bg-gray-50 border border-[#E8EEF8] rounded-xl text-[14px] text-gray-800 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-[#1C50A7]/20 focus:border-[#1C50A7] transition-colors"
          />
        </div>

        <!-- Submit -->
        <button
          type="submit"
          disabled={loading}
          class="w-full h-11 bg-[#1C50A7] text-white rounded-xl text-[14px] font-semibold hover:bg-[#1845a0] disabled:opacity-60 disabled:cursor-not-allowed transition-colors mt-2 flex items-center justify-center gap-2"
        >
          {#if loading}
            <div class="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" aria-hidden="true"></div>
            Masuk...
          {:else}
            Masuk
          {/if}
        </button>
      </form>
    </div>

    <p class="text-center text-[12px] text-gray-400 mt-6">
      Audy Dental Group · Internal Learning Platform
    </p>
  </div>
</div>
