import BaseApiService from './baseApiService'
import { decodeLaureatesResponse, LaureatesResponse, Laureate } from '../codecs/laureatsCodec'

// Класс-сервис для получения данных о лауреатах
class LaureatsService extends BaseApiService {
  constructor() {
    super('https://api.nobelprize.org/v1')
  }

  async getLaureates(): Promise<LaureatesResponse> {
    const data = await this.get('/laureate.json')
    return decodeLaureatesResponse(data)
  }

  async getLaureateByName(name: string): Promise<Laureate[]> {
    const response = await this.getLaureates()
    return response.laureates.filter(laureate =>
      laureate.knownName && laureate.knownName.en.toLowerCase().includes(name.toLowerCase())
    )
  }

  async getLaureatesByCategory(category: string): Promise<Laureate[]> {
    const response = await this.getLaureates()
    return response.laureates.filter(laureate =>
      laureate.nobelPrizes && laureate.nobelPrizes.some(prize => prize.category === category)
    )
  }
}

export default new LaureatsService()
