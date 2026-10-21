import BaseApiService from './baseApiService'

// Класс-сервис для получения данных о лауреатах
class LaureatsService extends BaseApiService {
  constructor() {
    super('https://api.nobelprize.org/v1')
  }

  async getLaureates() {
    return this.get('/laureate.json')
  }

  async getLaureateByName(name) {
    const laureates = await this.getLaureates()
    return laureates.laureates.filter(laureate =>
      laureate.knownName && laureate.knownName.en.toLowerCase().includes(name.toLowerCase())
    )
  }

  async getLaureatesByCategory(category) {
    const laureates = await this.getLaureates()
    return laureates.laureates.filter(laureate =>
      laureate.nobelPrizes && laureate.nobelPrizes.some(prize => prize.category === category)
    )
  }
}

export default new LaureatsService()
