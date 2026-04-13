<template>
  <div class="layout">
    <Sidebar v-if="!isMobile" />
    <!-- Mobile header -->
    <header v-if="isMobile" class="mobile-header">
      <button class="menu-btn" @click="showDrawer = true">☰</button>
      <div class="mobile-brand">
        <img src="/logo.png" alt="Logo" class="mobile-logo" />
        <span>面試鏡</span>
      </div>
    </header>
    <!-- Mobile drawer -->
    <Teleport to="body">
      <div v-if="showDrawer" class="drawer-overlay" @click="showDrawer = false">
        <div class="drawer" @click.stop>
          <Sidebar />
        </div>
      </div>
    </Teleport>
    <main class="main-content" :class="{ 'mobile': isMobile }">
      <slot />
    </main>
  </div>
</template>

<script setup lang="ts">
const showDrawer = ref(false)
const isMobile = ref(false)

const checkMobile = () => {
  isMobile.value = window.innerWidth < 768
}

onMounted(() => {
  checkMobile()
  window.addEventListener('resize', checkMobile)
})

onUnmounted(() => {
  window.removeEventListener('resize', checkMobile)
})

watch(() => useRoute().path, () => {
  showDrawer.value = false
})
</script>

<style scoped>
.layout {
  display: flex;
  min-height: 100vh;
}

.main-content {
  flex: 1;
  margin-left: 250px;
  min-height: 100vh;
}

.main-content.mobile {
  margin-left: 0;
}

.mobile-header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  height: 56px;
  background: white;
  display: flex;
  align-items: center;
  padding: 0 1rem;
  gap: 0.75rem;
  box-shadow: var(--shadow);
  z-index: 50;
}

.menu-btn {
  background: none;
  border: none;
  font-size: 1.5rem;
  padding: 0.25rem;
  color: var(--text);
}

.mobile-brand {
  display: flex;
  align-items: center;
  gap: 8px;
  font-weight: 700;
  color: var(--primary);
}

.mobile-logo {
  width: 28px;
  height: 28px;
}

.main-content.mobile {
  padding-top: 56px;
}

.drawer-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.4);
  z-index: 200;
}

.drawer {
  width: 250px;
  height: 100%;
  background: white;
}
</style>
