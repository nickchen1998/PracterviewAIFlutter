<template>
  <div class="setup-page">
    <h1 class="page-title">面試設定</h1>

    <div class="setup-grid">
      <div class="setup-form">
        <!-- Interview Type -->
        <div class="form-section">
          <h3 class="section-title">面試類型</h3>
          <div class="type-cards">
            <button v-for="t in types" :key="t.value" class="type-card"
              :class="{ active: form.type === t.value }" @click="form.type = t.value">
              <span class="type-icon">{{ t.icon }}</span>
              <span class="type-label">{{ t.label }}</span>
            </button>
          </div>
        </div>

        <!-- Position & Industry -->
        <div class="form-section">
          <div class="form-row">
            <div class="form-group">
              <label class="label">目標職位</label>
              <select class="input-field" v-model="form.position">
                <option v-for="p in positions" :key="p" :value="p">{{ p }}</option>
              </select>
            </div>
            <div class="form-group">
              <label class="label">目標產業</label>
              <select class="input-field" v-model="form.industry">
                <option v-for="i in industries" :key="i" :value="i">{{ i }}</option>
              </select>
            </div>
          </div>
        </div>

        <!-- Difficulty -->
        <div class="form-section">
          <h3 class="section-title">面試難度</h3>
          <div class="segment-group">
            <button v-for="d in difficulties" :key="d.value" class="segment-btn"
              :class="{ active: form.difficulty === d.value }" @click="form.difficulty = d.value">
              {{ d.label }}
            </button>
          </div>
        </div>

        <!-- Mode -->
        <div class="form-section">
          <h3 class="section-title">面試模式</h3>
          <div class="segment-group">
            <button class="segment-btn" :class="{ active: form.mode === 'text' }"
              @click="form.mode = 'text'">💬 文字對話</button>
            <button class="segment-btn" :class="{ active: form.mode === 'voice' }"
              @click="form.mode = 'voice'">🎤 語音對話</button>
          </div>
        </div>
      </div>

      <!-- Summary -->
      <div class="card summary-card">
        <h3 class="section-title">面試摘要</h3>
        <div class="summary-rows">
          <div class="summary-row">
            <span class="text-secondary">面試類型</span>
            <span class="text-bold">{{ types.find(t => t.value === form.type)?.label }}</span>
          </div>
          <div class="summary-row">
            <span class="text-secondary">目標職位</span>
            <span class="text-bold">{{ form.position }}</span>
          </div>
          <div class="summary-row">
            <span class="text-secondary">目標產業</span>
            <span class="text-bold">{{ form.industry }}</span>
          </div>
          <div class="summary-row">
            <span class="text-secondary">面試難度</span>
            <span class="text-bold">{{ difficulties.find(d => d.value === form.difficulty)?.label }}</span>
          </div>
          <div class="summary-row">
            <span class="text-secondary">面試模式</span>
            <span class="text-bold">{{ form.mode === 'text' ? '文字對話' : '語音對話' }}</span>
          </div>
        </div>
        <div class="summary-divider"></div>
        <div class="summary-row">
          <span class="text-secondary">⏱ 預估時間</span>
          <span class="text-primary text-bold">30 分鐘</span>
        </div>
        <NuxtLink to="/interview/session" class="btn btn-primary" style="width: 100%; justify-content: center; margin-top: 1.25rem; padding: 0.8rem;">
          ▶ 開始面試
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { positions, industries } from '~/data/mock'

const form = reactive({
  type: 'technical',
  position: '前端工程師',
  industry: '軟體科技',
  difficulty: 'intermediate',
  mode: 'text',
})

const types = [
  { value: 'technical', label: '技術面試', icon: '💻' },
  { value: 'behavioral', label: '行為面試', icon: '🧠' },
  { value: 'comprehensive', label: '綜合面試', icon: '📊' },
]

const difficulties = [
  { value: 'beginner', label: '初級' },
  { value: 'intermediate', label: '中級' },
  { value: 'advanced', label: '高級' },
]
</script>

<style scoped>
.setup-page {
  padding: 2rem;
  max-width: 1100px;
}

.setup-grid {
  display: grid;
  grid-template-columns: 1fr 320px;
  gap: 1.5rem;
  margin-top: 1.25rem;
  align-items: start;
}

@media (max-width: 900px) {
  .setup-grid {
    grid-template-columns: 1fr;
  }
}

.form-section {
  margin-bottom: 1.5rem;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

@media (max-width: 600px) {
  .form-row { grid-template-columns: 1fr; }
}

.form-group {
  margin-bottom: 0.5rem;
}

.type-cards {
  display: flex;
  gap: 0.75rem;
}

.type-card {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  padding: 1.25rem;
  border: 1px solid var(--border);
  border-radius: var(--radius-lg);
  background: white;
  cursor: pointer;
  transition: all 0.15s;
}

.type-card:hover {
  border-color: var(--primary);
}

.type-card.active {
  background: var(--primary-bg);
  border-color: var(--primary);
  color: var(--primary);
}

.type-icon {
  font-size: 1.5rem;
}

.type-label {
  font-size: 0.9rem;
  font-weight: 500;
}

.segment-group {
  display: flex;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  overflow: hidden;
}

.segment-btn {
  flex: 1;
  padding: 0.6rem 1rem;
  border: none;
  background: white;
  font-size: 0.9rem;
  cursor: pointer;
  transition: all 0.15s;
}

.segment-btn + .segment-btn {
  border-left: 1px solid var(--border);
}

.segment-btn.active {
  background: var(--primary);
  color: white;
  font-weight: 500;
}

.summary-card {
  position: sticky;
  top: 2rem;
}

.summary-rows {
  margin-top: 1rem;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  padding: 0.5rem 0;
  font-size: 0.9rem;
}

.summary-divider {
  height: 1px;
  background: var(--border-light);
  margin: 0.75rem 0;
}
</style>
