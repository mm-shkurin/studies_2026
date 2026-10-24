<script setup>
defineProps({
  headers: {
    type: Array,
    required: true
  },
  data: {
    type: Array,
    required: true
  }
})
</script>

<template>
  <table>
    <thead>
      <tr>
        <th v-for="header in headers" :key="header">{{ header }}</th>
      </tr>
    </thead>
    <tbody>
      <tr v-for="(row, rowIndex) in data" :key="rowIndex">
        <td v-for="(cell, cellIndex) in row" :key="cellIndex">{{ cell }}</td>
      </tr>
    </tbody>
  </table>
</template>

<style scoped>
table {
  border-collapse: collapse;
  width: 100%;
  background-color: #ffffff;
  border: 1px solid #e0e0e0;
}

thead {
  background-color: #f8f9fa;
}

th {
  padding: 14px 16px;
  text-align: left;
  color: #333;
  font-weight: 600;
  font-size: 0.95rem;
  border-bottom: 2px solid #e0e0e0;
}

td {
  padding: 12px 16px;
  text-align: left;
  border-bottom: 1px solid #e0e0e0;
  color: #333;
}

tbody tr:hover {
  background-color: #f8f9fa;
}

tbody tr:nth-child(even) {
  background-color: #fafbfc;
}

tbody tr:nth-child(even):hover {
  background-color: #f8f9fa;
}

tbody tr:last-child td {
  border-bottom: none;
}
</style>
