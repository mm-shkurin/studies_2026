import * as t from 'io-ts'
import { decodeOrThrow } from './decodeOrThrow.js'

export const PrizeCodec = t.type({
  year: t.string,
  category: t.union([
    t.literal('chemistry'),
    t.literal('economics'),
    t.literal('literature'),
    t.literal('peace'),
    t.literal('physics'),
    t.literal('medicine')
  ]),
  overallMotivation: t.union([t.string, t.null, t.undefined]),
  laureates: t.union([
    t.array(
      t.type({
        id: t.string,
        firstname: t.union([t.string, t.null, t.undefined]),
        surname: t.union([t.string, t.null, t.undefined]),
        motivation: t.union([t.string, t.null, t.undefined]),
        share: t.union([t.string, t.null, t.undefined])
      })
    ),
    t.undefined
  ])
})

export const PrizesResponseCodec = t.type({
  prizes: t.array(PrizeCodec)
})

export const decodePrizesResponse = (data) => {
  return decodeOrThrow(PrizesResponseCodec)(data)
}
