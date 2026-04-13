import '../models/user.dart';
import '../models/resume.dart';
import '../models/interview.dart';
import '../models/interview_result.dart';

abstract class MockData {
  static const currentUser = AppUser(
    id: 'user-001',
    name: '王小明',
    email: 'xiaoming@example.com',
    phone: '0912-345-678',
    education: Education(
      school: '國立台灣大學',
      department: '資訊工程學系',
      graduationYear: 2022,
    ),
    experience: WorkExperience(
      jobTitle: '前端工程師',
      company: 'ABC 科技',
      yearsOfExperience: 2,
    ),
    skills: ['Flutter', 'React', 'TypeScript', 'Node.js', 'Python', 'Git'],
    hasCompletedOnboarding: true,
    resumeCompleteness: 0.75,
  );

  static final currentResume = Resume(
    id: 'resume-001',
    fileName: '王小明_履歷_2024.pdf',
    uploadedAt: DateTime(2024, 6, 15),
    analysis: const ResumeAnalysis(
      strengths: [
        '技術棧豐富，前後端經驗兼具',
        '有實際專案開發經驗',
        '學歷背景優秀',
      ],
      improvements: [
        '建議加入更多量化成果描述',
        '可補充開源貢獻或技術文章',
        '建議加入軟實力相關描述',
      ],
      overallScore: 78,
    ),
  );

  static final positions = [
    '前端工程師',
    '後端工程師',
    '全端工程師',
    'iOS 工程師',
    'Android 工程師',
    'Flutter 工程師',
    '資料工程師',
    '機器學習工程師',
    'DevOps 工程師',
    '產品經理',
    'UI/UX 設計師',
    '專案經理',
  ];

  static final industries = [
    '軟體科技',
    '金融科技',
    '電子商務',
    '遊戲產業',
    '醫療科技',
    '教育科技',
    '物聯網',
    '區塊鏈',
    '傳統製造',
    '顧問諮詢',
  ];

  static final sampleMessages = [
    InterviewMessage(
      id: 'msg-1',
      content: '你好！我是你的面試官。今天我們將進行一場前端工程師的技術面試。準備好了嗎？',
      isFromAI: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
    InterviewMessage(
      id: 'msg-2',
      content: '準備好了，請開始吧！',
      isFromAI: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 9)),
    ),
    InterviewMessage(
      id: 'msg-3',
      content: '請問你能解釋一下 React 中的 Virtual DOM 是什麼？它如何提升效能？',
      isFromAI: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
    InterviewMessage(
      id: 'msg-4',
      content: 'Virtual DOM 是 React 維護的一個輕量級的 DOM 副本。當狀態改變時，React 會先在 Virtual DOM 中計算差異（diffing），然後只更新實際 DOM 中需要改變的部分，而不是重新渲染整個頁面。這樣可以減少不必要的 DOM 操作，提升渲染效能。',
      isFromAI: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 7)),
    ),
    InterviewMessage(
      id: 'msg-5',
      content: '回答得很好！那請問你知道 React 的 Fiber 架構嗎？它和 Virtual DOM 的關係是什麼？',
      isFromAI: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 6)),
    ),
  ];

  static final interviewResults = [
    InterviewResult(
      id: 'result-001',
      date: DateTime.now().subtract(const Duration(days: 1)),
      position: '前端工程師',
      industry: '軟體科技',
      type: InterviewType.technical,
      overallScore: 82,
      categoryScores: {
        '專業知識': 85,
        '表達能力': 78,
        '邏輯思維': 88,
        '態度': 80,
      },
      questionFeedbacks: [
        const QuestionFeedback(
          question: '請解釋 React 中的 Virtual DOM',
          userAnswer: 'Virtual DOM 是一個輕量級的 DOM 副本...',
          aiFeedback: '回答正確且完整，對 diffing 機制的說明很清楚。建議可以補充提到 reconciliation 演算法。',
          score: 85,
        ),
        const QuestionFeedback(
          question: '什麼是 CSS-in-JS？有什麼優缺點？',
          userAnswer: 'CSS-in-JS 是將 CSS 寫在 JavaScript 中的方式...',
          aiFeedback: '概念理解正確。優點部分說得很好，但缺點方面可以再提到效能影響和 bundle size 增加的問題。',
          score: 78,
        ),
        const QuestionFeedback(
          question: '請說明 HTTP/2 相較於 HTTP/1.1 的改進',
          userAnswer: 'HTTP/2 支援多路復用、頭部壓縮...',
          aiFeedback: '提到了多路復用和頭部壓縮，很好。可以再補充 Server Push 和二進制分幀的概念。',
          score: 80,
        ),
      ],
      suggestions: [
        '加強對瀏覽器渲染原理的理解',
        '多練習系統設計題目',
        '回答時可以多舉實際專案經驗的例子',
        '注意回答的結構化，可使用 STAR 法則',
      ],
    ),
    InterviewResult(
      id: 'result-002',
      date: DateTime.now().subtract(const Duration(days: 5)),
      position: '全端工程師',
      industry: '金融科技',
      type: InterviewType.comprehensive,
      overallScore: 75,
      categoryScores: {
        '專業知識': 72,
        '表達能力': 80,
        '邏輯思維': 75,
        '態度': 78,
      },
      questionFeedbacks: [],
      suggestions: [
        '加強後端 API 設計能力',
        '對資料庫優化有更深入的了解',
      ],
    ),
    InterviewResult(
      id: 'result-003',
      date: DateTime.now().subtract(const Duration(days: 12)),
      position: '前端工程師',
      industry: '電子商務',
      type: InterviewType.behavioral,
      overallScore: 88,
      categoryScores: {
        '專業知識': 85,
        '表達能力': 90,
        '邏輯思維': 85,
        '態度': 92,
      },
      questionFeedbacks: [],
      suggestions: [
        '表現優秀！繼續保持',
        '可以準備更多跨團隊合作的案例',
      ],
    ),
  ];
}
