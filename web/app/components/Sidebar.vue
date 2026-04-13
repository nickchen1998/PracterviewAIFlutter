<template>
  <aside class="sidebar">
    <div class="sidebar-header">
      <img src="/logo.png" alt="Logo" class="sidebar-logo" />
      <span class="sidebar-title">面試鏡</span>
    </div>

    <nav class="sidebar-nav">
      <NuxtLink to="/" class="nav-item" :class="{ active: route.path === '/' }">
        <span class="nav-icon">📊</span>
        <span>儀表板</span>
      </NuxtLink>
      <NuxtLink to="/profile" class="nav-item" :class="{ active: route.path === '/profile' }">
        <span class="nav-icon">👤</span>
        <span>個人經歷</span>
      </NuxtLink>
      <NuxtLink to="/history" class="nav-item" :class="{ active: route.path.startsWith('/history') || route.path.startsWith('/interview') }">
        <span class="nav-icon">📋</span>
        <span>面試紀錄</span>
      </NuxtLink>
    </nav>

    <div class="sidebar-footer">
      <div class="user-card">
        <div class="user-avatar">王</div>
        <div class="user-info">
          <div class="user-name">王小明</div>
          <div class="user-email">xiaoming@example.com</div>
        </div>
      </div>
    </div>
  </aside>
</template>

<script setup lang="ts">
const route = useRoute()
</script>

<style scoped>
.sidebar {
  width: 250px;
  height: 100vh;
  background: white;
  display: flex;
  flex-direction: column;
  border-right: 1px solid var(--border-light);
  position: fixed;
  left: 0;
  top: 0;
  z-index: 100;
}

.sidebar-header {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 1.5rem 1.25rem 1rem;
}

.sidebar-logo {
  width: 34px;
  height: 34px;
}

.sidebar-title {
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--primary);
}

.sidebar-nav {
  flex: 1;
  padding: 0.5rem 0.75rem;
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 0.7rem 0.9rem;
  border-radius: var(--radius);
  color: var(--text);
  font-size: 0.95rem;
  transition: all 0.15s;
  text-decoration: none;
  position: relative;
}

.nav-item:hover {
  background: var(--primary-bg);
}

.nav-item.active {
  background: var(--primary-bg);
  color: var(--primary);
  font-weight: 600;
}

.nav-item.active::after {
  content: '';
  position: absolute;
  right: 8px;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 20px;
  background: var(--primary);
  border-radius: 2px;
}

.nav-icon {
  font-size: 1.1rem;
  width: 24px;
  text-align: center;
}

.sidebar-footer {
  padding: 1rem;
}

.user-card {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 0.75rem;
  background: var(--bg);
  border-radius: var(--radius);
}

.user-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  background: var(--primary-bg-strong);
  color: var(--primary);
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 0.85rem;
}

.user-info {
  flex: 1;
  min-width: 0;
}

.user-name {
  font-size: 0.85rem;
  font-weight: 600;
}

.user-email {
  font-size: 0.75rem;
  color: var(--text-secondary);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
