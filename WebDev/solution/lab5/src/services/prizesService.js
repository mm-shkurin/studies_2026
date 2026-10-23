import BaseApiService from './baseApiService'
import { decodePrizesResponse } from '../codecs/prizesCodec.js'

// Источник: https://api.nobelprize.org/v1/documentation (Nobel Prize API v1)

// Класс-сервис для получения данных о премиях
class PrizesService extends BaseApiService {
  constructor() {
    super('https://api.nobelprize.org/v1')
  }

  async getPrizes() {
    const data = await this.get('/prize.json')
    return decodePrizesResponse(data)
  }

  async getPrizesByCategory(category) {
    const response = await this.getPrizes()
    return response.prizes.filter(prize => prize.category === category)
  }

  async getPrizesByYear(year) {
    const response = await this.getPrizes()
    return response.prizes.filter(prize => prize.awardYear === year)
  }
}

export default new PrizesService()
