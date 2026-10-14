from pathlib import Path

ALPHABET = "абвгдежзийклмнопрстуфхцчшщъыьэюя"
M = len(ALPHABET)
OUT_DIR = Path(__file__).parent


def caesar(text, k, mode):
    shift = k if mode == 0 else -k
    result = ""
    for ch in text.lower().replace("ё", "е"):
        if ch in ALPHABET:
            result += ALPHABET[(ALPHABET.index(ch) + shift) % M]
        else:
            result += ch
    return result


def main():
    while True:
        print()
        print("Меню:")
        print("0 - шифрование")
        print("1 - расшифрование")
        print("2 - подбор ключа")
        print("3 - выход")
        raw = input("Выберите режим: ").strip()
        if raw == "3":
            break
        if raw not in ("0", "1", "2"):
            print("Ошибка: режим должен быть 0, 1, 2 или 3.")
            continue

        if raw == "2":
            cipher = input("Введите зашифрованную фразу: ")
            lines = [f"ШИФР-ТЕКСТ (ШТ): {cipher}", "Варианты расшифрования при различных значениях ключа:"]
            for key in range(1, M):
                variant = caesar(cipher, key, 1)
                lines.append(f"k = {key}: {variant}")
                print(f"k = {key:2}: {variant}")
            (OUT_DIR / "bruteforce.txt").write_text("\n".join(lines) + "\n", encoding="utf-8")
            print("Сохранено в bruteforce.txt")
            continue

        mode = int(raw)
        while True:
            raw_key = input(f"Введите ключ k (целое число от 1 до {M}): ").strip()
            try:
                k = int(raw_key)
            except ValueError:
                print("Ошибка: ключ должен быть целым числом.")
                continue
            if 1 <= k <= M:
                break
            if k < 0:
                k = k % M or M
                print(f"Отрицательный ключ заменён сравнимым по модулю {M}: k = {k}")
                break
            print(f"Ошибка: ключ должен быть от 1 до {M}.")

        text = input("Введите текст: ")
        result = caesar(text, k, mode)
        print("Ключ:", k)
        if mode == 0:
            print("Зашифрованный текст:", result)
            (OUT_DIR / "encrypted.txt").write_text(f"Ключ: {k}\nШифр-текст: {result}\n", encoding="utf-8")
            print("Сохранено в encrypted.txt")
        else:
            print("Расшифрованный текст:", result)
            (OUT_DIR / "decrypted.txt").write_text(f"Ключ: {k}\nРасшифрованный текст: {result}\n", encoding="utf-8")
            print("Сохранено в decrypted.txt")


if __name__ == "__main__":
    main()
