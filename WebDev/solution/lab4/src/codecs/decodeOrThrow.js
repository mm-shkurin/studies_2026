import * as E from 'fp-ts/Either'
import { PathReporter } from 'io-ts/PathReporter'

export const decodeOrThrow = (codec) => (input) => {
  const result = codec.decode(input)

  if (E.isLeft(result)) {
    const errors = PathReporter.report(result)
    throw new Error(`Validation failed: ${errors.join(', ')}`)
  }

  return result.right
}
