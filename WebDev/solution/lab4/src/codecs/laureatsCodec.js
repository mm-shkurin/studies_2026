import * as t from 'io-ts'
import { decodeOrThrow } from './decodeOrThrow.js'

export const NobelPrizeCodec = t.type({
  year: t.string,
  category: t.union([
    t.literal('chemistry'),
    t.literal('economics'),
    t.literal('literature'),
    t.literal('peace'),
    t.literal('physics'),
    t.literal('medicine')
  ]),
  share: t.union([t.string, t.null, t.undefined]),
  motivation: t.union([t.string, t.null, t.undefined]),
  affiliations: t.unknown
})

export const LaureateCodec = t.type({
  id: t.string,
  firstname: t.union([t.string, t.null, t.undefined]),
  surname: t.union([t.string, t.null, t.undefined]),
  born: t.union([t.string, t.null, t.undefined]),
  died: t.union([t.string, t.null, t.undefined]),
  bornCountry: t.union([t.string, t.null, t.undefined]),
  bornCountryCode: t.union([t.string, t.null, t.undefined]),
  bornCity: t.union([t.string, t.null, t.undefined]),
  diedCountry: t.union([t.string, t.null, t.undefined]),
  diedCountryCode: t.union([t.string, t.null, t.undefined]),
  diedCity: t.union([t.string, t.null, t.undefined]),
  gender: t.union([
    t.literal('male'),
    t.literal('female'),
    t.literal('org'),
    t.null,
    t.undefined
  ]),
  prizes: t.array(NobelPrizeCodec)
})

export const LaureatesResponseCodec = t.type({
  laureates: t.array(LaureateCodec)
})

export const decodeLaureatesResponse = (data) => {
  return decodeOrThrow(LaureatesResponseCodec)(data)
}
