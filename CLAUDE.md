# Practerview (面試鏡)

AI 模擬面試練習平台 - Flutter Web + App

## Tech Stack
- Flutter 3.x (Web + iOS + Android)
- Material Design 3
- go_router + Riverpod
- Google Fonts (Noto Sans TC)

## GitHub
- Repo: nickchen1998/PracterviewAIFlutter

## Zeabur Deployment (GitHub Actions → 靜態部署)
- Project ID: 69dc9f28a159bbb5eeb48c39
- Service ID: 69dcb5cce4877f6f12f58e1d
- Environment ID: 69dc9f28474db8a99d6df6a8
- 部署方式：push to main → GitHub Actions build Flutter web → deploy 靜態檔案到 Zeabur
- GitHub Secrets: ZEABUR_PROJECT_ID, ZEABUR_SERVICE_ID, ZEABUR_TOKEN

## Rules
- **推送前必須詢問使用者確認**，不要自動 git push。commit 可以先做，但 push 要等使用者同意。

## Commands
- `flutter run -d chrome` — 本地開發
- `flutter build web --release` — 建置
- `flutter analyze` — 靜態分析
- `git push origin main` — 推送後 GitHub Actions 自動建置部署
