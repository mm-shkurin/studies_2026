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
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

thead {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

th {
  padding: 16px;
  text-align: left;
  color: white;
  font-weight: 600;
  font-size: 0.95rem;
  border: none;
}

td {
  padding: 14px 16px;
  text-align: left;
  border-bottom: 1px solid #e8e8e8;
  color: #333;
}

tbody tr {
  transition: background-color 0.2s ease;
}

tbody tr:hover {
  background-color: #f8f9ff;
}

tbody tr:nth-child(even) {
  background-color: #fafbfc;
}

tbody tr:nth-child(even):hover {
  background-color: #f8f9ff;
}

tbody tr:last-child td {
  border-bottom: none;
}
</style>
