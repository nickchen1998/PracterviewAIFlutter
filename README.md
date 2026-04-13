# 面試鏡 Practerview

> AI 模擬面試，讓你信心滿滿

面試鏡是一個 AI 驅動的面試練習平台，幫助求職者透過模擬面試提升面試技巧與信心。

## 功能

- **AI 面試模擬** — 根據你的履歷、目標職位與產業，AI 即時提問並給予回饋
- **文字與語音模式** — 支援文字對話及語音對話兩種面試模式
- **履歷分析** — 上傳履歷後 AI 自動分析優勢與改善建議
- **多維度評分** — 專業知識、表達能力、邏輯思維、態度四大面向評分
- **歷史紀錄** — 完整保存每次面試紀錄，追蹤進步軌跡

## 技術棧

- **Flutter** — 跨平台框架（Web / iOS / Android）
- **Material Design 3** — Google 最新設計語言
- **go_router** — 宣告式路由管理
- **Riverpod** — 響應式狀態管理
- **Zeabur** — 雲端部署平台

## 開發

```bash
# 安裝依賴
flutter pub get

# 本地開發（瀏覽器）
flutter run -d chrome

# 建置 Web
flutter build web --release

# 靜態分析
flutter analyze
```

## 部署

本專案透過 Zeabur Git 部署，每次推送至 `main` 分支將自動觸發重新部署。

部署使用 multi-stage Docker build：
1. Flutter build — 產生靜態檔案
2. Nginx — 提供靜態服務 + SPA fallback + 快取優化

## 專案結構

```
lib/
├── main.dart              # 應用入口
├── app.dart               # MaterialApp + Theme + Router
├── router/                # 路由設定
├── theme/                 # M3 主題與色彩
├── models/                # 資料模型
├── providers/             # Riverpod 狀態管理
├── data/                  # Mock 假資料
├── screens/               # 各頁面 UI
├── widgets/               # 共用元件
└── utils/                 # 工具函式與常數
```

## License

MIT
