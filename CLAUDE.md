# Practerview (面試鏡)

AI 模擬面試練習平台

## 專案結構
```
Practerview/
├── web/         # Nuxt.js 前端（Web 版，server mode）
├── flutter/     # Flutter 前端（iOS/Android App）
├── backend/     # FastAPI 後端（共用 API）
```

## Tech Stack
- **Web**: Nuxt.js 4 + 純本地 CSS（不依賴 CDN）
- **App**: Flutter 3.x (iOS / Android)
- **Backend**: FastAPI (Python)
- **部署**: Zeabur（綁定 GitHub，push to main 自動建置部署）

## GitHub
- Repo: nickchen1998/Practerview

## Zeabur
- Project ID: 69dc9f28a159bbb5eeb48c39
- Web (Nuxt) Service ID: 69dcc18931002b1c1e155912 (Git deploy, root: web/, server mode)
- Environment ID: 69dc9f28474db8a99d6df6a8
- 部署方式：Zeabur 直接綁定 GitHub repo，root directory: web/，push 後自動建置

## Rules
- **推送前必須詢問使用者確認**，不要自動 git push。commit 可以先做，但 push 要等使用者同意。
- **CSS 純本地**，所有字型、樣式都打包在專案中，不依賴外部 CDN。

## Commands
### Web (Nuxt.js)
- `cd web && npm run dev` — 本地開發
- `cd web && npm run build` — 建置（server mode）

### Flutter
- `cd flutter && flutter run -d chrome` — 本地開發
- `cd flutter && flutter build web --release` — 建置

### Backend
- `cd backend && uvicorn main:app --reload` — 本地開發
