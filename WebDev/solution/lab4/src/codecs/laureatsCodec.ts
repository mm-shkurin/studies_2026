import * as t from 'io-ts'
import { decodeOrThrow } from './decodeOrThrow'

// Типы для Nobel Prize API v1

// Структура отдельной премии лауреата
export const NobelPrizeCodec = t.type({
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
  awardYear: t.string,
  dateAwarded: t.union([t.string, t.null]),
  prizeAmount: t.number,
  prizeAmountAdjusted: t.number,
  motivation: t.union([
    t.type({ en: t.string }),
    t.null
  ]),
  sortOrder: t.union([t.number, t.null])
})

export type NobelPrize = t.TypeOf<typeof NobelPrizeCodec>

// Структура лауреата
export const LaureateCodec = t.type({
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
  birth: t.union([
    t.type({
      date: t.string
    }),
    t.null
  ]),
  death: t.union([
    t.type({
      date: t.string
    }),
    t.null
  ]),
  gender: t.union([
    t.literal('male'),
    t.literal('female'),
    t.literal('org'),
    t.null
  ]),
  orgName: t.union([
    t.type({ en: t.string }),
    t.null
  ]),
  nobelPrizes: t.array(NobelPrizeCodec)
})

export type Laureate = t.TypeOf<typeof LaureateCodec>

// Структура ответа API для лауреатов
export const LaureatesResponseCodec = t.type({
  laureates: t.array(LaureateCodec)
})

export type LaureatesResponse = t.TypeOf<typeof LaureatesResponseCodec>

// Декодирование ответа API с выбросом исключения при ошибке
export const decodeLaureatesResponse = (data: unknown): LaureatesResponse => {
  return decodeOrThrow(LaureatesResponseCodec)(data as any)
}
