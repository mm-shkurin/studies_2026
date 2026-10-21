<script setup>
import { ref, onMounted, computed } from 'vue'
import TableComponent from '../components/TableComponent.vue'
import prizesService from '../services/prizesService'

const prizesHeaders = ['Категория', 'Дата вручения', 'Стоимость гранта']
const prizesData = ref([])
const filteredPrizes = ref([])
const loading = ref(false)
const error = ref(null)

// Фильтрация по категории
const selectedCategory = ref('')
const categories = ref(['phy', 'che', 'med', 'lit', 'pea', 'eco'])
const categoryLabels = {
  phy: 'Физика',
  che: 'Химия',
  med: 'Медицина',
  lit: 'Литература',
  pea: 'Мир',
  eco: 'Экономика'
}

// Пагинация
const currentPage = ref(1)
const itemsPerPage = 10

// Вычисляемые свойства
const totalPages = computed(() => Math.ceil(filteredPrizes.value.length / itemsPerPage))
const paginatedPrizes = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage
  const end = start + itemsPerPage
  return filteredPrizes.value.slice(start, end)
})

// Загрузка данных
const loadPrizes = async () => {
  loading.value = true
  error.value = null
  try {
    const data = await prizesService.getPrizes()
    prizesData.value = data.prizes.map(prize => [
      categoryLabels[prize.category] || prize.category,
      prize.awardYear,
      prize.prizeAmountAdjusted || 'N/A'
    ])
    filteredPrizes.value = prizesData.value
  } catch (err) {
    error.value = 'Ошибка загрузки данных'
    console.error(err)
  } finally {
    loading.value = false
  }
}

// Фильтрация
const applyFilter = () => {
  if (selectedCategory.value) {
    const categoryName = categoryLabels[selectedCategory.value]
    filteredPrizes.value = prizesData.value.filter(row => row[0] === categoryName)
  } else {
    filteredPrizes.value = prizesData.value
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
  loadPrizes()
})
</script>

<template>
  <div>
    <header>
      <h1>Нобелевские премии</h1>
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
            Фильтр по категории:
            <select v-model="selectedCategory" @change="applyFilter">
              <option value="">Все категории</option>
              <option v-for="cat in categories" :key="cat" :value="cat">
                {{ categoryLabels[cat] }}
              </option>
            </select>
          </label>
        </div>
        <TableComponent :headers="prizesHeaders" :data="paginatedPrizes" />
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

.filter select {
  margin-left: 10px;
  padding: 5px;
  border-radius: 4px;
  border: 1px solid #ccc;
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
