<script setup>
import { ref } from 'vue'
import TableComponent from '../components/TableComponent.vue'

const laureatsHeaders = ['Имя/Название', 'Дата рождения/основания', 'Число премий']
const laureatsData = ref([
  ['Альберт Эйнштейн', '1879-03-14', '1'],
  ['Мария Кюри', '1867-11-07', '2'],
  ['Красный Крест', '1863-02-17', '3'],
  ['Международный комитет Красного Креста', '1863-02-17', '3'],
  ['UNHCR', '1950-12-14', '2'],
  ['Линус Полинг', '1901-02-28', '2']
])
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
      <TableComponent :headers="laureatsHeaders" :data="laureatsData" />
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

footer {
  background-color: #524FE5;
  color: white;
  text-align: center;
  padding: 10px;
  margin-top: 20px;
}
</style>
