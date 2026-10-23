import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router'

// Регистрация service worker
// Источник: https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API/Using_Service_Workers
if ('serviceWorker' in navigator) {
  window.addEventListener('load', () => {
    navigator.serviceWorker.register('/sw.js')
      .then((registration) => {
        console.log('Service Worker registered: ', registration)
      })
      .catch((registrationError) => {
        console.log('Service Worker registration failed: ', registrationError)
      })
  })
}

const app = createApp(App)
app.use(router)
app.mount('#app')
