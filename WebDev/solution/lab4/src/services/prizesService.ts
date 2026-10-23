import BaseApiService from './baseApiService'
import { decodePrizesResponse, PrizesResponse, Prize } from '../codecs/prizesCodec'

// Класс-сервис для получения данных о премиях
class PrizesService extends BaseApiService {
  constructor() {
    super('https://api.nobelprize.org/v1')
  }

  async getPrizes(): Promise<PrizesResponse> {
    const data = await this.get('/prize.json')
    return decodePrizesResponse(data)
  }

  async getPrizesByCategory(category: string): Promise<Prize[]> {
    const response = await this.getPrizes()
    return response.prizes.filter(prize => prize.category === category)
  }

  async getPrizesByYear(year: string): Promise<Prize[]> {
    const response = await this.getPrizes()
    return response.prizes.filter(prize => prize.awardYear === year)
  }
}

export default new PrizesService()
