import * as t from 'io-ts'
import { decodeOrThrow } from './decodeOrThrow'

// Источник: https://api.nobelprize.org/v1/documentation (Nobel Prize API v1)
// Источник: https://gcanti.github.io/io-ts/ (документация io-ts)

// Типы для Nobel Prize API v1

// Структура отдельной премии
export const PrizeCodec = t.type({
  awardYear: t.string,
  category: t.union([
    t.literal('che'),
    t.literal('eco'),
    t.literal('lit'),
    t.literal('pea'),
    t.literal('phy'),
    t.literal('med')
  ]),
  categoryFullName: t.type({
    en: t.string
  }),
  dateAwarded: t.union([t.string, t.null]),
  prizeAmount: t.number,
  prizeAmountAdjusted: t.number,
  laureates: t.array(
    t.type({
      id: t.string,
      knownName: t.union([
        t.type({ en: t.string }),
        t.null
      ]),
      givenName: t.union([
        t.type({ en: t.string }),
        t.null
      ]),
      familyName: t.union([
        t.type({ en: t.string }),
        t.null
      ]),
      orgName: t.union([
        t.type({ en: t.string }),
        t.null
      ]),
      motivation: t.union([
        t.type({ en: t.string }),
        t.null
      ])
    })
  )
})

export type Prize = t.TypeOf<typeof PrizeCodec>

// Структура ответа API для премий
export const PrizesResponseCodec = t.type({
  prizes: t.array(PrizeCodec)
})

export type PrizesResponse = t.TypeOf<typeof PrizesResponseCodec>

// Декодирование ответа API с выбросом исключения при ошибке
export const decodePrizesResponse = (data: unknown): PrizesResponse => {
  return decodeOrThrow(PrizesResponseCodec)(data as any)
}
