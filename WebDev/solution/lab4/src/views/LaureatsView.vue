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
  background-color: #f8f9fa;
  color: #333;
  padding: 30px 20px;
  text-align: center;
  border-bottom: 1px solid #e0e0e0;
}

header h1 {
  margin: 0;
  font-size: 2rem;
  font-weight: 600;
}

nav {
  background-color: #ffffff;
  padding: 15px 20px;
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
  color: #007bff;
}

nav a.router-link-active {
  color: #007bff;
  font-weight: 600;
  border-bottom: 2px solid #007bff;
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
  border-radius: 8px;
  border: 1px solid #e0e0e0;
}

.filter label {
  font-weight: 600;
  color: #333;
  font-size: 0.95rem;
}

.filter input {
  margin-left: 12px;
  padding: 8px 16px;
  border-radius: 4px;
  border: 1px solid #d0d0d0;
  background-color: #fff;
  font-size: 0.9rem;
  width: 300px;
  transition: border-color 0.3s ease;
}

.filter input:hover {
  border-color: #007bff;
}

.filter input:focus {
  outline: none;
  border-color: #007bff;
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
  border: 1px solid #007bff;
  border-radius: 4px;
  background-color: #007bff;
  color: white;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.pagination button:hover:not(:disabled) {
  background-color: #0056b3;
}

.pagination button:disabled {
  background-color: #e0e0e0;
  border-color: #e0e0e0;
  cursor: not-allowed;
}

.pagination span {
  color: #666;
  font-weight: 500;
}

footer {
  background-color: #f8f9fa;
  color: #333;
  text-align: center;
  padding: 20px;
  margin-top: 40px;
  border-top: 1px solid #e0e0e0;
}

footer p {
  margin: 0;
  font-weight: 500;
}
</style>
