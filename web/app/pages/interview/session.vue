<template>
  <div class="session-page">
    <NuxtLayout name="fullscreen">
      <!-- Top Bar -->
      <header class="session-header">
        <button class="btn btn-outline" @click="showEndDialog = true">✕ 結束面試</button>
        <div class="session-info">
          <span class="text-secondary">前端工程師 · 軟體科技</span>
          <span class="progress-text">3 / 8 題</span>
        </div>
        <div class="timer">⏱ 12:34</div>
      </header>

      <div class="session-progress">
        <div class="progress-bar" style="width: 37.5%"></div>
      </div>

      <!-- Chat Area -->
      <div class="chat-area">
        <div v-for="msg in messages" :key="msg.id" class="message" :class="msg.isAI ? 'ai' : 'user'">
          <div class="msg-label" v-if="msg.isAI">🤖 AI 面試官</div>
          <div class="msg-bubble">{{ msg.content }}</div>
          <div class="msg-time">{{ msg.time }}</div>
        </div>
      </div>

      <!-- Input -->
      <div class="input-area">
        <input class="chat-input" placeholder="輸入你的回答..." v-model="input" @keyup.enter="send" />
        <button class="btn btn-primary" @click="send">傳送</button>
      </div>

      <!-- End Dialog -->
      <div v-if="showEndDialog" class="dialog-overlay" @click="showEndDialog = false">
        <div class="dialog" @click.stop>
          <h3>結束面試</h3>
          <p class="text-secondary">確定要結束面試嗎？結束後將產生面試結果報告。</p>
          <div class="dialog-actions">
            <button class="btn btn-outline" @click="showEndDialog = false">取消</button>
            <NuxtLink to="/history/result-001" class="btn btn-primary">結束</NuxtLink>
          </div>
        </div>
      </div>
    </NuxtLayout>
  </div>
</template>

<script setup lang="ts">
import { sampleMessages } from '~/data/mock'

definePageMeta({ layout: false })

const messages = ref([...sampleMessages])
const input = ref('')
const showEndDialog = ref(false)

const send = () => {
  if (!input.value.trim()) return
  messages.value.push({
    id: Date.now().toString(),
    content: input.value,
    isAI: false,
    time: new Date().toLocaleTimeString('zh-TW', { hour: '2-digit', minute: '2-digit' }),
  })
  input.value = ''
}
</script>

<style scoped>
.session-page {
  height: 100vh;
  display: flex;
  flex-direction: column;
  background: var(--bg);
}

.session-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0.75rem 1.5rem;
  background: white;
  border-bottom: 1px solid var(--border-light);
}

.session-info {
  display: flex;
  gap: 1rem;
  font-size: 0.9rem;
}

.timer {
  padding: 0.3rem 0.75rem;
  background: #fef2f2;
  color: var(--error);
  border-radius: 20px;
  font-size: 0.85rem;
  font-weight: 600;
}

.session-progress {
  height: 4px;
  background: var(--border-light);
}

.progress-bar {
  height: 100%;
  background: var(--primary);
  border-radius: 0 2px 2px 0;
  transition: width 0.3s;
}

.chat-area {
  flex: 1;
  overflow-y: auto;
  padding: 1.5rem;
  max-width: 800px;
  margin: 0 auto;
  width: 100%;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.message.user {
  align-self: flex-end;
  max-width: 75%;
}

.message.ai {
  align-self: flex-start;
  max-width: 75%;
}

.msg-label {
  font-size: 0.75rem;
  color: var(--primary);
  margin-bottom: 0.25rem;
}

.msg-bubble {
  padding: 0.75rem 1rem;
  border-radius: 14px;
  font-size: 0.95rem;
  line-height: 1.6;
}

.ai .msg-bubble {
  background: white;
  border-bottom-left-radius: 4px;
}

.user .msg-bubble {
  background: var(--primary);
  color: white;
  border-bottom-right-radius: 4px;
}

.msg-time {
  font-size: 0.7rem;
  color: var(--text-secondary);
  margin-top: 0.2rem;
}

.user .msg-time {
  text-align: right;
}

.input-area {
  display: flex;
  gap: 0.75rem;
  padding: 1rem 1.5rem;
  background: white;
  border-top: 1px solid var(--border-light);
  max-width: 800px;
  margin: 0 auto;
  width: 100%;
}

.chat-input {
  flex: 1;
  padding: 0.7rem 1rem;
  border: 1px solid var(--border);
  border-radius: 24px;
  background: var(--bg);
  font-size: 0.95rem;
}

.chat-input:focus {
  outline: none;
  border-color: var(--primary);
}

.dialog-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 300;
}

.dialog {
  background: white;
  border-radius: var(--radius-lg);
  padding: 1.5rem;
  max-width: 400px;
  width: 90%;
}

.dialog h3 {
  margin-bottom: 0.5rem;
}

.dialog-actions {
  display: flex;
  justify-content: flex-end;
  gap: 0.75rem;
  margin-top: 1.5rem;
}
</style>
