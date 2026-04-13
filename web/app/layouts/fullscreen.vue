<template>
  <div class="fullscreen-layout">
    <slot />
  </div>
</template>

<style scoped>
.fullscreen-layout {
  min-height: 100vh;
  background: var(--bg);
}
</style>
