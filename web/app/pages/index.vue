<template>
  <div class="dashboard">
    <!-- Welcome Banner -->
    <div class="welcome-banner">
      <div class="welcome-text">
        <h1>歡迎回來，{{ user.name }}</h1>
        <p>準備好今天的面試練習了嗎？持續練習是成功的關鍵。</p>
        <NuxtLink to="/interview/setup" class="btn btn-white">
          ▶ 開始面試練習
        </NuxtLink>
      </div>
      <div class="welcome-icon">🎤</div>
    </div>

    <!-- Stats -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon" style="background: rgba(13,148,136,0.1); color: var(--primary)">📝</div>
        <div>
          <div class="stat-label">面試次數</div>
          <div class="stat-value">{{ results.length }}</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: rgba(245,158,11,0.1); color: #f59e0b">📈</div>
        <div>
          <div class="stat-label">平均分數</div>
          <div class="stat-value">{{ avgScore }}</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: rgba(99,102,241,0.1); color: #6366f1">⭐</div>
        <div>
          <div class="stat-label">最近分數</div>
          <div class="stat-value">{{ results[0]?.overallScore ?? '-' }}</div>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon" style="background: rgba(239,68,68,0.1); color: #ef4444">📄</div>
        <div>
          <div class="stat-label">履歷完成度</div>
          <div class="stat-value">{{ Math.round(user.resumeCompleteness * 100) }}%</div>
        </div>
      </div>
    </div>

    <!-- Score Trend -->
    <div class="card">
      <h3 class="section-title">分數趨勢</h3>
      <div class="trend-chart">
        <div v-for="r in [...results].reverse()" :key="r.id" class="trend-bar-wrap">
          <span class="trend-score">{{ r.overallScore }}</span>
          <div class="trend-bar" :style="{ height: (r.overallScore / 100 * 100) + 'px' }"></div>
          <span class="trend-date">{{ r.date.slice(5) }}</span>
        </div>
      </div>
    </div>

    <!-- Recent Records -->
    <div class="recent-section">
      <div class="recent-header">
        <h3 class="section-title">最近面試紀錄</h3>
        <NuxtLink to="/history" class="text-primary text-sm">查看全部</NuxtLink>
      </div>
      <div class="card" style="padding: 0; overflow: hidden;">
        <table class="data-table">
          <thead>
            <tr>
              <th>日期</th>
              <th>職位</th>
              <th>產業</th>
              <th>分數</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="r in results.slice(0, 3)" :key="r.id" @click="navigateTo(`/history/${r.id}`)">
              <td>{{ r.date }}</td>
              <td class="text-bold">{{ r.position }}</td>
              <td>{{ r.industry }}</td>
              <td class="text-primary text-bold">{{ r.overallScore }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { currentUser, interviewResults } from '~/data/mock'

const user = currentUser
const results = interviewResults
const avgScore = Math.round(results.reduce((a, b) => a + b.overallScore, 0) / results.length)
</script>

<style scoped>
.dashboard {
  padding: 2rem;
  max-width: 1100px;
}

.welcome-banner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: linear-gradient(135deg, var(--primary), var(--primary-light));
  color: white;
  padding: 2rem;
  border-radius: var(--radius-lg);
  margin-bottom: 1.5rem;
}

.welcome-text h1 {
  font-size: 1.5rem;
  margin-bottom: 0.4rem;
}

.welcome-text p {
  opacity: 0.85;
  margin-bottom: 1rem;
  font-size: 0.95rem;
}

.welcome-icon {
  font-size: 4rem;
  opacity: 0.3;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.stat-card {
  background: white;
  border-radius: var(--radius-lg);
  box-shadow: var(--shadow);
  padding: 1.25rem;
  display: flex;
  align-items: center;
  gap: 1rem;
}

.stat-icon {
  width: 44px;
  height: 44px;
  border-radius: var(--radius);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.2rem;
}

.stat-label {
  font-size: 0.8rem;
  color: var(--text-secondary);
}

.stat-value {
  font-size: 1.5rem;
  font-weight: 700;
}

.trend-chart {
  display: flex;
  justify-content: space-evenly;
  align-items: flex-end;
  height: 160px;
  margin-top: 1rem;
}

.trend-bar-wrap {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}

.trend-score {
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--primary);
}

.trend-bar {
  width: 40px;
  background: rgba(13, 148, 136, 0.7);
  border-radius: 4px 4px 0 0;
}

.trend-date {
  font-size: 0.7rem;
  color: var(--text-secondary);
}

.recent-section {
  margin-top: 1.5rem;
}

.recent-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.75rem;
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.9rem;
}

.data-table th {
  text-align: left;
  padding: 0.8rem 1rem;
  background: var(--bg);
  font-weight: 500;
  color: var(--text-secondary);
  font-size: 0.85rem;
}

.data-table td {
  padding: 0.8rem 1rem;
  border-top: 1px solid var(--border-light);
}

.data-table tbody tr {
  cursor: pointer;
  transition: background 0.1s;
}

.data-table tbody tr:hover {
  background: var(--bg);
}
</style>
