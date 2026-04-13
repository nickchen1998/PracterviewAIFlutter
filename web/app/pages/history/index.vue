<template>
  <div class="history-page">
    <div class="history-header">
      <h1 class="page-title">面試紀錄</h1>
      <NuxtLink to="/interview/setup" class="btn btn-primary">+ 開始新面試</NuxtLink>
    </div>

    <div class="filters">
      <button class="filter-chip">依日期</button>
      <button class="filter-chip">依職位</button>
      <button class="filter-chip">依產業</button>
    </div>

    <div class="card" style="padding: 0; overflow: hidden;">
      <table class="data-table">
        <thead>
          <tr>
            <th>日期</th>
            <th>職位</th>
            <th>產業</th>
            <th>類型</th>
            <th>分數</th>
            <th></th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="r in results" :key="r.id" @click="navigateTo(`/history/${r.id}`)">
            <td>{{ r.date }}</td>
            <td class="text-bold">{{ r.position }}</td>
            <td>{{ r.industry }}</td>
            <td>
              <span class="type-badge">{{ typeLabels[r.type] }}</span>
            </td>
            <td class="text-primary text-bold">{{ r.overallScore }}</td>
            <td>
              <NuxtLink :to="`/history/${r.id}`" class="btn btn-outline" style="padding: 0.35rem 0.75rem; font-size: 0.8rem;">
                查看詳情
              </NuxtLink>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { interviewResults, typeLabels } from '~/data/mock'

const results = interviewResults
</script>

<style scoped>
.history-page {
  padding: 2rem;
  max-width: 1100px;
}

.history-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.filters {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 1rem;
}

.filter-chip {
  padding: 0.4rem 0.9rem;
  border-radius: 20px;
  border: 1px solid var(--border);
  background: white;
  font-size: 0.85rem;
  cursor: pointer;
  transition: all 0.15s;
}

.filter-chip:hover {
  border-color: var(--primary);
  color: var(--primary);
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

.type-badge {
  font-size: 0.8rem;
  padding: 0.2rem 0.6rem;
  border-radius: 6px;
  background: var(--primary-bg);
  color: var(--primary);
}
</style>
