<template>
  <div class="profile-page">
    <h1 class="page-title">個人經歷</h1>

    <div class="profile-grid">
      <!-- Form Section -->
      <div class="card form-section">
        <h3 class="section-title">基本資料</h3>
        <div class="form-row">
          <div class="form-group">
            <label class="label">姓名</label>
            <input class="input-field" :value="user.name" />
          </div>
          <div class="form-group">
            <label class="label">Email</label>
            <input class="input-field" :value="user.email" />
          </div>
        </div>
        <div class="form-group">
          <label class="label">電話</label>
          <input class="input-field" :value="user.phone" />
        </div>

        <h4 class="sub-title">學歷</h4>
        <div class="form-row">
          <div class="form-group">
            <label class="label">學校</label>
            <input class="input-field" :value="user.education.school" />
          </div>
          <div class="form-group">
            <label class="label">科系</label>
            <input class="input-field" :value="user.education.department" />
          </div>
        </div>
        <div class="form-group" style="max-width: 200px;">
          <label class="label">畢業年份</label>
          <input class="input-field" :value="user.education.graduationYear" />
        </div>

        <h4 class="sub-title">工作經驗</h4>
        <div class="form-row">
          <div class="form-group">
            <label class="label">職稱</label>
            <input class="input-field" :value="user.experience.jobTitle" />
          </div>
          <div class="form-group">
            <label class="label">公司</label>
            <input class="input-field" :value="user.experience.company" />
          </div>
        </div>
        <div class="form-group" style="max-width: 200px;">
          <label class="label">年資</label>
          <input class="input-field" :value="user.experience.yearsOfExperience" />
        </div>

        <h4 class="sub-title">技能標籤</h4>
        <div class="skills-wrap">
          <span v-for="s in user.skills" :key="s" class="chip">{{ s }} ✕</span>
          <button class="btn btn-outline" style="padding: 0.3rem 0.75rem; font-size: 0.8rem;">+ 新增</button>
        </div>

        <div style="text-align: right; margin-top: 1.5rem;">
          <button class="btn btn-primary">💾 儲存</button>
        </div>
      </div>

      <!-- Resume Section -->
      <div class="resume-section">
        <div class="card">
          <h3 class="section-title">上傳履歷</h3>
          <div class="upload-area">
            <div class="upload-icon">☁️</div>
            <div class="upload-text">拖放檔案或點擊上傳</div>
            <div class="upload-hint">支援 PDF、Word 格式</div>
            <button class="btn btn-outline" style="margin-top: 0.75rem;">📎 選擇檔案</button>
          </div>

          <div class="uploaded-file">
            <span class="file-icon">📄</span>
            <div class="file-info">
              <div class="file-name">{{ resumeData.fileName }}</div>
              <div class="file-date">上傳於 {{ resumeData.uploadedAt }}</div>
            </div>
            <button class="icon-btn">👁</button>
            <button class="icon-btn" style="color: var(--error);">🗑</button>
          </div>
        </div>

        <div v-if="resumeData.analysis" class="card" style="margin-top: 1rem;">
          <div class="analysis-header">
            <div>
              <h3 class="section-title">✨ AI 履歷分析</h3>
            </div>
            <span class="chip" style="font-size: 0.9rem; padding: 0.4rem 1rem;">{{ resumeData.analysis.overallScore }} / 100</span>
          </div>

          <h4 class="analysis-label" style="color: var(--primary);">優勢</h4>
          <ul class="analysis-list">
            <li v-for="s in resumeData.analysis.strengths" :key="s">✅ {{ s }}</li>
          </ul>

          <h4 class="analysis-label" style="color: var(--warning);">建議改善</h4>
          <ul class="analysis-list">
            <li v-for="s in resumeData.analysis.improvements" :key="s">💡 {{ s }}</li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { currentUser, resume } from '~/data/mock'

const user = currentUser
const resumeData = resume
</script>

<style scoped>
.profile-page {
  padding: 2rem;
  max-width: 1100px;
}

.profile-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.25rem;
  margin-top: 1.25rem;
}

@media (max-width: 900px) {
  .profile-grid {
    grid-template-columns: 1fr;
  }
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-bottom: 0.75rem;
}

@media (max-width: 600px) {
  .form-row {
    grid-template-columns: 1fr;
  }
}

.form-group {
  margin-bottom: 0.75rem;
}

.sub-title {
  font-size: 0.95rem;
  font-weight: 600;
  margin: 1.25rem 0 0.75rem;
  padding-top: 0.75rem;
  border-top: 1px solid var(--border-light);
}

.skills-wrap {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  align-items: center;
}

.upload-area {
  border: 2px dashed var(--border);
  border-radius: var(--radius);
  padding: 2rem;
  text-align: center;
  margin: 1rem 0;
}

.upload-icon {
  font-size: 2rem;
  margin-bottom: 0.5rem;
}

.upload-text {
  font-weight: 500;
}

.upload-hint {
  font-size: 0.8rem;
  color: var(--text-secondary);
}

.uploaded-file {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem;
  background: var(--bg);
  border-radius: var(--radius);
}

.file-icon {
  font-size: 1.5rem;
}

.file-info {
  flex: 1;
}

.file-name {
  font-weight: 500;
  font-size: 0.9rem;
}

.file-date {
  font-size: 0.75rem;
  color: var(--text-secondary);
}

.icon-btn {
  background: none;
  border: none;
  font-size: 1rem;
  padding: 0.25rem;
  cursor: pointer;
}

.analysis-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.analysis-label {
  font-size: 0.9rem;
  font-weight: 600;
  margin: 1rem 0 0.4rem;
}

.analysis-list {
  list-style: none;
  font-size: 0.85rem;
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
}
</style>
