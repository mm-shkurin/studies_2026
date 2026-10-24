import BaseApiService from './baseApiService'
import { decodeLaureatesResponse } from '../codecs/laureatsCodec.js'

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
    return response.laureates.filter(laureate => {
      const fullName = laureate.firstname && laureate.surname
        ? `${laureate.firstname} ${laureate.surname}`.toLowerCase()
        : (laureate.firstname || laureate.surname || '').toLowerCase()
      return fullName.includes(name.toLowerCase())
    })
  }

  async getLaureatesByCategory(category) {
    const response = await this.getLaureates()
    return response.laureates.filter(laureate =>
      laureate.prizes && laureate.prizes.some(prize => prize.category === category)
    )
  }
}

export default new LaureatsService()
