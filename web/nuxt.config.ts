export default defineNuxtConfig({
  compatibilityDate: '2025-07-15',
  devtools: { enabled: true },

  app: {
    head: {
      title: '面試鏡 Practerview',
      meta: [
        { charset: 'utf-8' },
        { name: 'viewport', content: 'width=device-width, initial-scale=1' },
        { name: 'description', content: '面試鏡 - AI 模擬面試，讓你信心滿滿' },
      ],
      link: [
        { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' },
      ],
    },
  },

  css: [
    '@fontsource/noto-sans-tc/400.css',
    '@fontsource/noto-sans-tc/500.css',
    '@fontsource/noto-sans-tc/700.css',
    '~/assets/css/main.css',
  ],

  ssr: true,
})
