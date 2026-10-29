from affine import ext_gcd, inverse, solve_congruence, solve_system, affine, ALPHABET, M

def test_ext_gcd():
    print("=== Тест 1: Расширенный алгоритм Евклида ===")
    tests = [
        (240, 46, (2, -9, 47)),
        (46, 240, (2, 47, -9)),
        (17, 32, (1, -9, 5)),
        (9, 32, (1, -7, 2)),
        (4, 32, (4, 1, 0)),
    ]
    for a, b, expected in tests:
        result = ext_gcd(a, b)
        d, x, y = result
        check = a * x + b * y
        print(f"ext_gcd({a}, {b}) = {result}")
        print(f"  Проверка: {a}*{x} + {b}*{y} = {check} (ожидается {expected[0]})")
        assert d == expected[0], f"НОД неверен: {d} != {expected[0]}"
        assert check == expected[0], f"Тождество Безу не выполняется: {check} != {expected[0]}"
    print("OK\n")

def test_inverse():
    print("=== Тест 2: Обратный элемент ===")
    tests = [
        (9, 32, 25),
        (17, 32, 17),
        (3, 32, 11),
        (4, 32, None),
        (6, 32, None),
    ]
    for a, m, expected in tests:
        result = inverse(a, m)
        print(f"inverse({a}, {m}) = {result}")
        if expected is None:
            assert result is None, f"Ожидался None, получено {result}"
        else:
            assert result == expected, f"Ожидалось {expected}, получено {result}"
            check = (a * result) % m
            print(f"  Проверка: {a}*{result} mod {m} = {check} (ожидается 1)")
            assert check == 1, f"Обратный элемент неверен: {check} != 1"
    print("OK\n")

def test_solve_congruence():
    print("=== Тест 3: Решение сравнения ===")
    tests = [
        (6, 4, 32, [6, 22]),
        (8, 6, 32, []),
        (9, 5, 32, [21]),
        (12, 8, 32, [2, 10, 18, 26]),
    ]
    for a, b, m, expected in tests:
        result = solve_congruence(a, b, m)
        print(f"solve_congruence({a}, {b}, {m}) = {result}")
        if not expected:
            assert result == [], f"Ожидалось [], получено {result}"
        else:
            for x in result:
                check = (a * x) % m
                print(f"  Проверка x={x}: {a}*{x} mod {m} = {check} (ожидается {b % m})")
                assert check == b % m, f"Решение неверно: {check} != {b % m}"
    print("OK\n")

def test_solve_system():
    print("=== Тест 4: Решение системы ===")
    # Пример 1 методички (с. 15-16)
    tests = [
        (14, 8, 5, 19, 32, [(13, 18)]),
        (14, 19, 5, 8, 32, [(19, 9)]),
        (0, 9, 8, 15, 32, []),
    ]
    for a, b, c, d, m, expected in tests:
        result = solve_system(a, b, c, d, m)
        print(f"solve_system({a}, {b}, {c}, {d}, {m}) = {result}")
        if not expected:
            assert result == [], f"Ожидалось [], получено {result}"
        else:
            for x, y in result:
                check1 = (a * x + y) % m
                check2 = (c * x + y) % m
                print(f"  Проверка x={x}, y={y}: {a}*{x}+{y} mod {m} = {check1} (ожидается {b % m}), {c}*{x}+{y} mod {m} = {check2} (ожидается {d % m})")
                assert check1 == b % m, f"Первое сравнение неверно: {check1} != {b % m}"
                assert check2 == d % m, f"Второе сравнение неверно: {check2} != {d % m}"
    print("OK\n")

def test_affine():
    print("=== Тест 5: Аффинный шифр ===")
    # Тест шифрования и расшифрования
    text = "привет мир"
    a, b = 17, 1
    encrypted = affine(text, a, b, 0)
    decrypted = affine(encrypted, a, b, 1)
    print(f"Текст: {text}")
    print(f"Ключ: a={a}, b={b}")
    print(f"Зашифровано: {encrypted}")
    print(f"Расшифровано: {decrypted}")
    assert decrypted == text, f"Расшифрование не совпало: {decrypted} != {text}"
    print("OK\n")

def test_methodic_examples():
    print("=== Тест 6: Примеры из методички ===")
    # Пример 1 (с. 15-16)
    a, b = 13, 18
    plain = "грибоедов"
    encrypted = affine(plain, a, b, 0)
    print(f"Пример 1: a={a}, b={b}")
    print(f"Открытый текст: {plain}")
    print(f"Зашифровано: {encrypted}")
    decrypted = affine(encrypted, a, b, 1)
    assert decrypted == plain, f"Расшифрование не совпало: {decrypted} != {plain}"
    print("OK\n")

def test_variant_22():
    print("=== Тест 7: Вариант 22 ===")
    cipher = "юпицьпгцлбицьпгцлапвьбьлбюибсдгьбвуюмнгшфьрепнйупуапвьдщюпгадуэапуцлйлдусдгпшгсбуйьврврепнасйюцвпювнцсуюдявнпьдебгцугэвдгрещйнйьйвубнййапуаптьцеюпндицьдвусдйьвржьбеюмнйсдиэрнй"
    a, b = 17, 1
    decrypted = affine(cipher, a, b, 1)
    print(f"Шифр-текст: {cipher[:50]}...")
    print(f"Ключ: a={a}, b={b}")
    print(f"Расшифровано: {decrypted[:50]}...")
    expected_start = "ночеловекачеловекпослалканчару"
    assert decrypted.startswith(expected_start), f"Расшифрование не совпало: {decrypted[:50]} не начинается с {expected_start}"
    print("OK\n")

if __name__ == "__main__":
    try:
        test_ext_gcd()
        test_inverse()
        test_solve_congruence()
        test_solve_system()
        test_affine()
        test_methodic_examples()
        test_variant_22()
        print("=== ВСЕ ТЕСТЫ ПРОЙДЕНЫ ===")
    except AssertionError as e:
        print(f"=== ТЕСТ ПРОВАЛЕН: {e} ===")
    except Exception as e:
        print(f"=== ОШИБКА: {e} ===")
