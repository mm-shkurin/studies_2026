<script setup>
import { ref, onMounted, computed } from 'vue'
import TableComponent from '../components/TableComponent.vue'
import laureatsService from '../services/laureatsService'

const laureatsHeaders = ['Имя/Название', 'Дата рождения/основания', 'Число премий']
const laureatsData = ref([])
const filteredLaureats = ref([])
const loading = ref(false)
const error = ref(null)

// Фильтрация по имени
const searchName = ref('')

// Пагинация
const currentPage = ref(1)
const itemsPerPage = 10

// Вычисляемые свойства
const totalPages = computed(() => Math.ceil(filteredLaureats.value.length / itemsPerPage))
const paginatedLaureats = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return filteredLaureats.value.slice(start, end)
})

// Загрузка данных
const loadLaureats = async () => {
  loading.value = true
  error.value = null
  try {
    const data = await laureatsService.getLaureates()
    laureatsData.value = data.laureates.map(laureate => [
      laureate.knownName ? laureate.knownName.en : laureate.orgName ? laureate.orgName.en : 'N/A',
      laureate.birth ? laureate.birth.date : laureate.founded ? laureate.founded.date : 'N/A',
      laureate.nobelPrizes ? laureate.nobelPrizes.length : 0
    ])
    filteredLaureats.value = laureatsData.value
  } catch (err) {
    error.value = 'Ошибка загрузки данных'
    console.error(err)
  } finally {
    loading.value = false
  }
}

// Фильтрация
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

// Пагинация
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
header {
  background-color: #524FE5;
  color: white;
  padding: 20px;
  text-align: center;
}

nav {
  background-color: #0400fc;
  padding: 10px;
}

nav a {
  color: white;
  margin-right: 20px;
  text-decoration: none;
}

nav a.router-link-active {
  font-weight: bold;
  text-decoration: underline;
}

main {
  padding: 20px;
}

.filter {
  margin-bottom: 20px;
  padding: 10px;
  background-color: #f5f5f5;
  border-radius: 4px;
}

.filter label {
  font-weight: bold;
}

.filter input {
  margin-left: 10px;
  padding: 5px;
  border-radius: 4px;
  border: 1px solid #ccc;
  width: 300px;
}

.pagination {
  margin-top: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 10px;
}

.pagination button {
  padding: 5px 15px;
  border: 1px solid #ccc;
  border-radius: 4px;
  background-color: white;
  cursor: pointer;
}

.pagination button:disabled {
  background-color: #f0f0f0;
  cursor: not-allowed;
}

footer {
  background-color: #524FE5;
  color: white;
  text-align: center;
  padding: 10px;
  margin-top: 20px;
}
</style>
