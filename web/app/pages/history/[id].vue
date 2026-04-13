<template>
  <div class="result-page" v-if="result">
    <div class="result-header">
      <NuxtLink to="/history" class="back-link">← 返回紀錄</NuxtLink>
      <h1 class="page-title">面試結果</h1>
    </div>

    <!-- Score Card -->
    <div class="card score-card">
      <div class="score-ring-wrap">
        <svg class="score-ring" viewBox="0 0 120 120">
          <circle cx="60" cy="60" r="52" fill="none" stroke="#e8eaed" stroke-width="10" />
          <circle cx="60" cy="60" r="52" fill="none" stroke="var(--primary)" stroke-width="10"
            stroke-linecap="round" :stroke-dasharray="`${result.overallScore * 3.27} 327`"
            transform="rotate(-90 60 60)" />
        </svg>
        <div class="score-text">
          <span class="score-number">{{ result.overallScore }}</span>
          <span class="score-unit">分</span>
        </div>
      </div>
      <div class="score-details">
        <h3>面試表現總覽</h3>
        <p class="text-secondary">{{ result.position }} · {{ result.industry }}</p>
        <div class="category-scores">
          <div v-for="(score, cat) in result.categoryScores" :key="cat" class="category-row">
            <span class="cat-label">{{ cat }}</span>
            <div class="cat-bar-bg">
              <div class="cat-bar" :style="{ width: score + '%' }"></div>
            </div>
            <span class="cat-value">{{ score }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Feedback -->
    <div v-if="result.questionFeedbacks.length" style="margin-top: 1.5rem;">
      <h3 class="section-title">詳細回饋</h3>
      <div v-for="(qf, i) in result.questionFeedbacks" :key="i" class="card feedback-card">
        <div class="feedback-header" @click="toggleFeedback(i)">
          <span class="feedback-question">{{ qf.question }}</span>
          <span class="chip">{{ qf.score }} 分</span>
          <span class="expand-icon">{{ expandedFeedback.has(i) ? '▲' : '▼' }}</span>
        </div>
        <div v-if="expandedFeedback.has(i)" class="feedback-body">
          <div class="answer-block">
            <div class="block-label">你的回答</div>
            <p>{{ qf.userAnswer }}</p>
          </div>
          <div class="ai-block">
            <div class="block-label">✨ AI 回饋</div>
            <p>{{ qf.aiFeedback }}</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Suggestions -->
    <div style="margin-top: 1.5rem;">
      <h3 class="section-title">改善建議</h3>
      <div class="card">
        <div v-for="s in result.suggestions" :key="s" class="suggestion-item">
          💡 {{ s }}
        </div>
      </div>
    </div>

    <div class="actions">
      <NuxtLink to="/interview/setup" class="btn btn-outline">🔄 重新面試</NuxtLink>
      <NuxtLink to="/" class="btn btn-primary">🏠 回到首頁</NuxtLink>
    </div>
  </div>
</template>

<script setup lang="ts">
import { interviewResults } from '~/data/mock'

const route = useRoute()
const result = interviewResults.find(r => r.id === route.params.id)
const expandedFeedback = ref(new Set<number>())

const toggleFeedback = (i: number) => {
  const s = new Set(expandedFeedback.value)
  s.has(i) ? s.delete(i) : s.add(i)
  expandedFeedback.value = s
}

if (!result) {
  navigateTo('/history')
}
</script>

<style scoped>
.result-page {
  padding: 2rem;
  max-width: 900px;
  margin: 0 auto;
}

.result-header {
  margin-bottom: 1.5rem;
}

.back-link {
  font-size: 0.85rem;
  color: var(--text-secondary);
  display: inline-block;
  margin-bottom: 0.5rem;
}

.back-link:hover {
  color: var(--primary);
}

.score-card {
  display: flex;
  gap: 2rem;
  align-items: center;
}

@media (max-width: 600px) {
  .score-card {
    flex-direction: column;
    text-align: center;
  }
}

.score-ring-wrap {
  position: relative;
  width: 120px;
  height: 120px;
  flex-shrink: 0;
}

.score-ring {
  width: 120px;
  height: 120px;
}

.score-text {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.score-number {
  font-size: 2rem;
  font-weight: 700;
  color: var(--primary);
}

.score-unit {
  font-size: 0.75rem;
  color: var(--text-secondary);
}

.score-details {
  flex: 1;
}

.score-details h3 {
  margin-bottom: 0.25rem;
}

.category-scores {
  margin-top: 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.6rem;
}

.category-row {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.cat-label {
  width: 70px;
  font-size: 0.85rem;
  color: var(--text-secondary);
}

.cat-bar-bg {
  flex: 1;
  height: 8px;
  background: #e8eaed;
  border-radius: 4px;
  overflow: hidden;
}

.cat-bar {
  height: 100%;
  background: var(--primary);
  border-radius: 4px;
}

.cat-value {
  width: 30px;
  text-align: right;
  font-weight: 600;
  font-size: 0.9rem;
}

.feedback-card {
  margin-top: 0.75rem;
  padding: 0;
  overflow: hidden;
}

.feedback-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1.25rem;
  cursor: pointer;
}

.feedback-header:hover {
  background: var(--bg);
}

.feedback-question {
  flex: 1;
  font-weight: 500;
}

.expand-icon {
  font-size: 0.7rem;
  color: var(--text-secondary);
}

.feedback-body {
  padding: 0 1.25rem 1.25rem;
}

.answer-block {
  background: var(--bg);
  border-radius: var(--radius);
  padding: 0.9rem;
  margin-bottom: 0.75rem;
}

.ai-block {
  background: var(--primary-bg);
  border-radius: var(--radius);
  padding: 0.9rem;
}

.block-label {
  font-size: 0.8rem;
  font-weight: 600;
  color: var(--text-secondary);
  margin-bottom: 0.3rem;
}

.ai-block .block-label {
  color: var(--primary);
}

.suggestion-item {
  padding: 0.5rem 0;
  font-size: 0.9rem;
}

.suggestion-item + .suggestion-item {
  border-top: 1px solid var(--border-light);
}

.actions {
  display: flex;
  justify-content: center;
  gap: 1rem;
  margin-top: 2rem;
}
</style>
