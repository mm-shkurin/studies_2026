import axios, { AxiosInstance } from 'axios'

// Источник: https://axios-http.com/docs/intro (документация axios)

// Единый класс-сервис для HTTP-запросов на axios
class BaseApiService {
  private client: AxiosInstance

  constructor(baseURL: string) {
    this.client = axios.create({
      baseURL: baseURL,
      timeout: 10000
    })
  }

  async get(url: string, params: Record<string, unknown> = {}): Promise<unknown> {
    try {
      const response = await this.client.get(url, { params })
      return response.data
    } catch (error) {
      console.error('API request error:', error)
      throw error
    }
  }

  async post(url: string, data: Record<string, unknown> = {}): Promise<unknown> {
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
