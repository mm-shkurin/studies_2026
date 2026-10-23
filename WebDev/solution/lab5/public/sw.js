// Service Worker для кеширования API-запросов
// Источник: https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API

const CACHE_NAME = 'nobel-prize-api-v1'
const API_URL = 'https://api.nobelprize.org/v1'

// Установка service worker
self.addEventListener('install', (event) => {
  console.log('Service Worker: installing...')
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      console.log('Service Worker: cache opened')
      return cache.addAll([])
    })
  )
})

// Активация service worker
self.addEventListener('activate', (event) => {
  console.log('Service Worker: activating...')
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            console.log('Service Worker: deleting old cache', cacheName)
            return caches.delete(cacheName)
          }
        })
      )
    })
  )
})

// Перехват запросов (стратегия Network First для API)
self.addEventListener('fetch', (event) => {
  // Кешируем только API-запросы
  if (event.request.url.startsWith(API_URL)) {
    event.respondWith(
      fetch(event.request)
        .then((response) => {
          // Клонирование ответа для кеширования
          const responseToCache = response.clone()
          caches.open(CACHE_NAME).then((cache) => {
            cache.put(event.request, responseToCache)
          })
          return response
        })
        .catch(() => {
          // При ошибке сети берем из кеша
          return caches.match(event.request)
        })
    )
  }
})
