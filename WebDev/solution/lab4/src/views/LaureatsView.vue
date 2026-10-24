<script setup>
import { ref, onMounted, computed } from 'vue'
import TableComponent from '../components/TableComponent.vue'
import laureatsService from '../services/laureatsService'

const laureatsHeaders = ['Имя/Название', 'Дата рождения/основания', 'Число премий']
const laureatsData = ref([])
const filteredLaureats = ref([])
const loading = ref(false)
const error = ref(null)

const searchName = ref('')

const currentPage = ref(1)
const itemsPerPage = 10

const totalPages = computed(() => Math.ceil(filteredLaureats.value.length / itemsPerPage))
const paginatedLaureats = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return filteredLaureats.value.slice(start, end)
})

const loadLaureats = async () => {
  loading.value = true
  error.value = null
  try {
    const data = await laureatsService.getLaureates()
    laureatsData.value = data.laureates.map(laureate => [
      laureate.firstname && laureate.surname ? `${laureate.firstname} ${laureate.surname}` : laureate.firstname || laureate.surname || 'N/A',
      laureate.born || 'N/A',
      laureate.prizes ? laureate.prizes.length : 0
    ])
    filteredLaureats.value = laureatsData.value
  } catch (err) {
    error.value = 'Ошибка загрузки данных'
    console.error(err)
  } finally {
    loading.value = false
  }
}

const applyFilter = () => {
  if (searchName.value) {
    filteredLaureats.value = laureatsData.value.filter(row =>
      row[0].toLowerCase().includes(searchName.value.toLowerCase())
    )
  } else {
    filteredLaureats.value = laureatsData.value
  }
  currentPage.value = 1
}

const nextPage = () => {
  if (currentPage.value < totalPages.value) currentPage.value++
}

const prevPage = () => {
  if (currentPage.value > 1) currentPage.value--
}

onMounted(() => {
  loadLaureats()
})
</script>

<template>
  <div>
    <header>
      <h1>Лауреаты Нобелевской премии</h1>
    </header>
    <nav>
      <router-link to="/prizes">Премии</router-link>
      <router-link to="/laureats">Лауреаты</router-link>
    </nav>
    <main>
      <div v-if="loading">Загрузка...</div>
      <div v-else-if="error">{{ error }}</div>
      <div v-else>
        <div class="filter">
          <label>
            Поиск по имени:
            <input
              v-model="searchName"
              @input="applyFilter"
              placeholder="Введите имя лауреата"
            />
          </label>
        </div>
        <TableComponent :headers="laureatsHeaders" :data="paginatedLaureats" />
        <div class="pagination">
          <button @click="prevPage" :disabled="currentPage === 1">Предыдущая</button>
          <span>Страница {{ currentPage }} из {{ totalPages }}</span>
          <button @click="nextPage" :disabled="currentPage === totalPages">Следующая</button>
        </div>
      </div>
    </main>
    <footer>
      <p>&copy; 2026 Нобелевский комитет</p>
    </footer>
  </div>
</template>

<style scoped>
* {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 30px 20px;
  text-align: center;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

header h1 {
  margin: 0;
  font-size: 2rem;
  font-weight: 600;
}

nav {
  background-color: #ffffff;
  padding: 15px 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  border-bottom: 1px solid #e0e0e0;
}

nav a {
  color: #333;
  margin-right: 30px;
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s ease;
}

nav a:hover {
  color: #667eea;
}

nav a.router-link-active {
  color: #667eea;
  font-weight: 600;
  border-bottom: 2px solid #667eea;
  padding-bottom: 5px;
}

main {
  padding: 30px 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.filter {
  margin-bottom: 25px;
  padding: 20px;
  background-color: #ffffff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  border: 1px solid #e8e8e8;
}

.filter label {
  font-weight: 600;
  color: #333;
  font-size: 0.95rem;
}

.filter input {
  margin-left: 12px;
  padding: 8px 16px;
  border-radius: 8px;
  border: 1px solid #d0d0d0;
  background-color: #fff;
  font-size: 0.9rem;
  width: 300px;
  transition: all 0.3s ease;
}

.filter input:hover {
  border-color: #667eea;
}

.filter input:focus {
  outline: none;
  border-color: #667eea;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
}

.pagination {
  margin-top: 30px;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 15px;
}

.pagination button {
  padding: 10px 24px;
  border: none;
  border-radius: 8px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 2px 4px rgba(102, 126, 234, 0.3);
}

.pagination button:hover:not(:disabled) {
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(102, 126, 234, 0.4);
}

.pagination button:disabled {
  background: #e0e0e0;
  cursor: not-allowed;
  box-shadow: none;
}

.pagination span {
  color: #666;
  font-weight: 500;
}

footer {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  text-align: center;
  padding: 20px;
  margin-top: 40px;
  box-shadow: 0 -4px 6px rgba(0, 0, 0, 0.1);
}

footer p {
  margin: 0;
  font-weight: 500;
}
</style>
