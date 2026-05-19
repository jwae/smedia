<script setup>
import { useRouter } from "vue-router";

defineProps({
  module: {
    type: Array,
    required: true
  },
  aktivesModul: {
    type: String,
    required: true
  }
});

const router = useRouter();

function wechsleModul(modulId) {
  router.push({ name: modulId });
}
</script>

<template>
  <section class="modul-nav">
    <button
      v-for="modul in module"
      :key="modul.id"
      type="button"
      :class="['modul-tab', aktivesModul === modul.id ? 'is-active' : '']"
      @click="wechsleModul(modul.id)"
    >
      {{ modul.label }}
    </button>
  </section>
</template>
