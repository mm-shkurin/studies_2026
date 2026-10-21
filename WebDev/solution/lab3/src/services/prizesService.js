import BaseApiService from './baseApiService'

// Класс-сервис для получения данных о премиях
class PrizesService extends BaseApiService {
  constructor() {
    super('https://api.nobelprize.org/v1')
  }

  async getPrizes() {
    return this.get('/prize.json')
  }

  async getPrizesByCategory(category) {
    const prizes = await this.getPrizes()
    return prizes.prizes.filter(prize => prize.category === category)
  }

  async getPrizesByYear(year) {
    const prizes = await this.getPrizes()
    return prizes.prizes.filter(prize => prize.awardYear === year)
  }
}

export default new PrizesService()
