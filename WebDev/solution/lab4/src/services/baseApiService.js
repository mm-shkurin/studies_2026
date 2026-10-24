import axios from 'axios'

class BaseApiService {
  constructor(baseURL) {
    this.client = axios.create({
      baseURL: baseURL,
      timeout: 30000
    })
  }

  async get(url, params = {}) {
    try {
      const response = await this.client.get(url, { params })
      return response.data
    } catch (error) {
      console.error('API request error:', error)
      throw error
    }
  }

  async post(url, data = {}) {
    try {
      const response = await this.client.post(url, data)
      return response.data
    } catch (error) {
      console.error('API request error:', error)
      throw error
    }
  }
}

export default BaseApiService
