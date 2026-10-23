import BaseApiService from './baseApiService'
import { decodeLaureatesResponse } from '../codecs/laureatsCodec.js'

// Источник: https://api.nobelprize.org/v1/documentation (Nobel Prize API v1)

// Класс-сервис для получения данных о лауреатах
class LaureatsService extends BaseApiService {
  constructor() {
    super('https://api.nobelprize.org/v1')
  }

  async getLaureates() {
    const data = await this.get('/laureate.json')
    return decodeLaureatesResponse(data)
  }

  async getLaureateByName(name) {
    const response = await this.getLaureates()
    return response.laureates.filter(laureate =>
      laureate.knownName && laureate.knownName.en.toLowerCase().includes(name.toLowerCase())
    )
  }

  async getLaureatesByCategory(category) {
    const response = await this.getLaureates()
    return response.laureates.filter(laureate =>
      laureate.nobelPrizes && laureate.nobelPrizes.some(prize => prize.category === category)
    )
  }
}

export default new LaureatsService()
