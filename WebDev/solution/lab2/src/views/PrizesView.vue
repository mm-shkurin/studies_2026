<script setup>
import { ref } from 'vue'
import TableComponent from '../components/TableComponent.vue'

const prizesHeaders = ['Категория', 'Дата вручения', 'Стоимость гранта']
const prizesData = ref([
  ['Физика', '2023-10-03', '11 000 000 SEK'],
  ['Химия', '2023-10-04', '11 000 000 SEK'],
  ['Медицина', '2023-10-02', '11 000 000 SEK'],
  ['Литература', '2023-10-05', '11 000 000 SEK'],
  ['Мир', '2023-10-06', '11 000 000 SEK'],
  ['Экономика', '2023-10-09', '11 000 000 SEK']
])
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
      <TableComponent :headers="prizesHeaders" :data="prizesData" />
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
