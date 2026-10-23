import * as t from 'io-ts'
import * as E from 'fp-ts/Either'
import { PathReporter } from 'io-ts/PathReporter'

// Источник: https://gcanti.github.io/io-ts/ (документация io-ts)
// Источник: https://gcanti.github.io/fp-ts/modules/Either.html (документация fp-ts/Either)

/**
 * Функция decodeOrThrow для обработки Either из io-ts.
 * При успешной декодировке возвращает декодированные данные.
 * При ошибке декодирования выбрасывает исключение с детальным описанием ошибок.
 *
 * @param codec - кодек io-ts для декодирования
 * @returns функция, которая принимает данные и возвращает декодированные данные или выбрасывает исключение
 */
export const decodeOrThrow = <I, O>(codec: t.Type<O, I>) => (input: I): O => {
  const result = codec.decode(input)

  if (E.isLeft(result)) {
    const errors = PathReporter.report(result)
    throw new Error(`Validation failed: ${errors.join(', ')}`)
  }

  return result.right
}
