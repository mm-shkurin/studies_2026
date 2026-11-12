# Инструкция: ЛР 2 в Visual Paradigm (вариант 5 — Аэропорт)

## Цель
Перенести PlantUML-диаграммы из `diagrams/*.puml` в Visual Paradigm для UML-анализа системы управления аэропортом.

## Что нужно построить
По методологии главы 3 UML (2).pdf (стр. 53–105):

1. **Диаграмма вариантов использования** — актёры и прецеденты
2. **Диаграмма трассировки прецедентов** — связь Use Case → Use-Case Realization → классы
3. **Диаграмма классов анализа VOPC** — граничные, управляющие, сущностные классы
4. **Диаграммы последовательности** — 4 фазы основного сценария Purchase Tickets
5. **Диаграмма кооперации** — коммуникационная диаграмма для того же сценария
6. **Диаграмма ключевых абстракций** — предметные классы аэропорта

## Пошаговая инструкция

### 1. Создание проекта
1. Откройте Visual Paradigm
2. File → New Project → UML Project
3. Название проекта: `AirportSystem` (или `AirportService`)
4. Создайте пустой проект

### 2. Организация пакетов
В Project Browser создайте структуру:
```
Design Model
└── Use-Case Realizations
    ├── Purchase Realization
    ├── Checkin Realization
    └── Manage Booking Realization
```

### 3. Диаграмма вариантов использования
1. Щёлкните правой кнопкой на `Design Model` → New Diagram → Use Case Diagram
2. Название: `Use Case Diagram`
3. Добавьте элементы:
   - **Система** (System Boundary): `Система управления аэропортом`
   - **Актёры** (Actor):
     - `Пассажир`
     - `Система оплаты`
     - `Система бронирования`
     - `Система регистрации`
   - **Прецеденты** (Use Case):
     - `Поиск рейсов` (вспомогательный)
     - `Покупка билетов` (основной)
     - `Бронирование билетов` (вспомогательный)
     - `Выбор места` (вспомогательный)
     - `Онлайн регистрация на рейс` (основной)
     - `Управление бронированием` (расширение)
     - `Получение посадочного талона` (вспомогательный)
     - `Отмена регистрации` (расширение)
4. Установите связи:
   - Association: Пассажир → Поиск рейсов, Покупка билетов, Онлайн регистрация на рейс, Управление бронированием, Получение посадочного талона
   - Association: Система оплаты → Покупка билетов
   - Association: Система бронирования → Покупка билетов
   - Association: Система регистрации → Онлайн регистрация на рейс
   - Include: Покупка билетов include Поиск рейсов, Бронирование билетов
   - Include: Онлайн регистрация на рейс include Выбор места
   - Include: Получение посадочного талона include Онлайн регистрация на рейс
   - Extend: Управление бронированием extend Покупка билетов
   - Extend: Управление бронированием extend Онлайн регистрация на рейс
   - Extend: Отмена регистрации extend Онлайн регистрация на рейс
5. Установите кратность (Multiplicity) на связях:
   - Пассажир → Покупка билетов: `1..*` (один пассажир делает много покупок)
   - Пассажир → Онлайн регистрация на рейс: `1..*` (один пассажир регистрируется много раз)

**Справка:** см. PlantUML-исходник `diagrams/01_use_case_diagram.puml`

### 4. Диаграмма трассировки прецедентов
1. Щёлкните правой кнопкой на `Use-Case Realizations` → New Diagram → Class Diagram
2. Название: `Traceability Diagram`
3. Добавьте элементы:
   - **Прецеденты** (Use Case): Покупка билетов, Онлайн регистрация на рейс
   - **Реализации** (Use-Case Realization): PurchaseRealization, CheckinRealization (со стереотипом <<use-case realization>>)
   - **Классы** (Class): BookingController, Booking, Flight, Seat, CheckinController, BoardingPass
4. Установите связи (Dependency):
   - PurchaseRealization → Покупка билетов (со стереотипом <<trace>>)
   - CheckinRealization → Онлайн регистрация на рейс (со стереотипом <<trace>>)
   - PurchaseRealization → BookingController, Booking, Flight, Seat
   - CheckinRealization → CheckinController, BoardingPass

**Справка:** см. PlantUML-исходник `diagrams/02_traceabilities_diagram.puml`

### 5. Диаграмма классов анализа VOPC
1. Щёлкните правой кнопкой на `Purchase Realization` → New Diagram → Class Diagram
2. Название: `VOPC Analysis Diagram`
3. Добавьте классы со стереотипами:
   - **Граничные** (<<Boundary>>):
     - `BookingUI` — интерфейс пассажира
   - **Управляющие** (<<Control>>):
     - `BookingController` — контроллер бронирования
   - **Сущностные** (<<Entity>>):
     - `Booking` — бронирование
     - `Flight` — рейс
     - `Seat` — место
     - `Payment` — платёж
     - `BoardingPass` — посадочный талон
     - `Passenger` — пассажир
4. Добавьте атрибуты и операции в классы (по PlantUML-исходнику):
   - BookingUI: searchFlights(), selectFlight(), selectSeat(), confirmBooking(), cancelBooking(), checkin(), getBoardingPass()
   - BookingController: findAvailableFlights(), bookSeat(), calculatePrice(), processPayment(), completeCheckin()
   - Booking: id, passenger, flight, seat, status, price, bookingTime, cancel(), confirm()
   - Flight: id, flightNumber, departureTime, arrivalTime, origin, destination, isAvailable()
   - Seat: id, seatNumber, row, position, status, flight, isAvailable()
   - Payment: id, amount, method, status, process()
   - BoardingPass: id, booking, gate, seatNumber, boardingTime, generate()
   - Passenger: id, name, passport, email, phone
5. Установите связи (Association):
   - BookingUI → BookingController
   - BookingController → Booking, Flight, Seat, Payment, BoardingPass
   - Booking → Passenger, Flight, Seat
   - BoardingPass → Booking
6. Установите кратность:
   - Booking → Flight: `1..1` (одно бронирование — один рейс)
   - Booking → Seat: `1..1` (одно бронирование — одно место)
   - Flight → Seat: `1..*` (один рейс — много мест)

**Справка:** см. PlantUML-исходник `diagrams/03_vopc_analysis_diagram.puml`

### 6. Диаграммы последовательности (4 фазы)

#### Фаза 1: Поиск рейсов
1. Щёлкните правой кнопкой на `Purchase Realization` → New Diagram → Sequence Diagram
2. Название: `Sequence Part 1 - Search Flights`
3. Добавьте объекты (Lifeline):
   - `:Passenger` (пассажир)
   - `:BookingUI` (интерфейс)
   - `:BookingController` (контроллер)
   - `:Flight` (рейс)
4. Добавьте сообщения:
   - Passenger → BookingUI: `searchFlights(criteria)`
   - BookingUI → BookingController: `findAvailableFlights(criteria)`
   - BookingController → Flight: `isAvailable()`
   - Flight → BookingController: `true`
   - BookingController → BookingUI: `listOfFlights`
   - BookingUI → Passenger: `displayResults()`

**Справка:** см. PlantUML-исходник `diagrams/04_sequence_basic_flow_part1.puml`

#### Фаза 2: Выбор рейса и места
1. New Diagram → Sequence Diagram
2. Название: `Sequence Part 2 - Select Flight and Seat`
3. Объекты:
   - `:Passenger`
   - `:BookingUI`
   - `:BookingController`
   - `:Booking` (бронирование)
   - `:Flight`
   - `:Seat`
4. Сообщения:
   - Passenger → BookingUI: `selectFlight(flightId)`
   - BookingUI → BookingController: `selectFlight(flightId)`
   - Passenger → BookingUI: `selectSeat(seatId)`
   - BookingUI → BookingController: `bookSeat(booking, seat)`
   - BookingController → Seat: `isAvailable()`
   - Seat → BookingController: `true`
   - BookingController → Booking: `create(passenger, flight, seat)`
   - Booking → BookingController: `bookingId`
   - BookingController → BookingUI: `bookingConfirmed(bookingId)`
   - BookingUI → Passenger: `showConfirmation()`

**Справка:** см. PlantUML-исходник `diagrams/05_sequence_basic_flow_part2.puml`

#### Фаза 3: Оплата
1. New Diagram → Sequence Diagram
2. Название: `Sequence Part 3 - Payment`
3. Объекты:
   - `:Passenger`
   - `:BookingUI`
   - `:BookingController`
   - `:Payment`
4. Сообщения:
   - Passenger → BookingUI: `confirmPayment(bookingId, paymentMethod)`
   - BookingUI → BookingController: `processPayment(bookingId, paymentMethod)`
   - BookingController → Payment: `create(bookingId, amount)`
   - Payment → BookingController: `paymentId`
   - BookingController → Payment: `process()`
   - Payment → BookingController: `success`
   - BookingController → Booking: `confirm()`
   - Booking → BookingController: `updated`
   - BookingController → BookingUI: `paymentSuccessful()`

**Справка:** см. PlantUML-исходник `diagrams/06_sequence_basic_flow_part3.puml`

#### Фаза 4: Онлайн регистрация
1. New Diagram → Sequence Diagram
2. Название: `Sequence Part 4 - Online Checkin`
3. Объекты:
   - `:Passenger`
   - `:BookingUI`
   - `:CheckinController`
   - `:BoardingPass`
   - `:Booking`
4. Сообщения:
   - Passenger → BookingUI: `checkin(bookingId)`
   - BookingUI → CheckinController: `completeCheckin(booking)`
   - CheckinController → Booking: `checkStatus()`
   - Booking → CheckinController: `confirmed`
   - CheckinController → BoardingPass: `generate(booking)`
   - BoardingPass → CheckinController: `boardingPassId`
   - CheckinController → BookingUI: `boardingPassGenerated()`
   - BookingUI → Passenger: `showBoardingPass()`

**Справка:** см. PlantUML-исходник `diagrams/07_sequence_basic_flow_part4.puml`

### 7. Диаграмма кооперации
1. Щёлкните правой кнопкой на `Purchase Realization` → New Diagram → Communication Diagram
2. Название: `Collaboration Diagram`
3. Добавьте объекты:
   - `:Passenger`
   - `:BookingUI`
   - `:BookingController`
   - `:Booking`
   - `:Flight`
   - `:Seat`
   - `:Payment`
   - `:BoardingPass`
4. Добавьте сообщения с номерами (в том же порядке, что и в диаграммах последовательности):
   - 1: Passenger → BookingUI: `searchFlights()`
   - 2: BookingUI → BookingController: `findAvailableFlights()`
   - 3: BookingController → Flight: `isAvailable()`
   - 4: Flight → BookingController: `true`
   - 5: BookingController → BookingUI: `listOfFlights`
   - 6: BookingUI → Passenger: `displayResults()`
   - 7: Passenger → BookingUI: `selectFlight()`
   - 8: BookingUI → BookingController: `selectFlight()`
   - 9: Passenger → BookingUI: `selectSeat()`
   - 10: BookingUI → BookingController: `bookSeat()`
   - 11: BookingController → Seat: `isAvailable()`
   - 12: Seat → BookingController: `true`
   - 13: BookingController → Booking: `create()`
   - 14: Booking → BookingController: `bookingId`
   - 15: BookingController → BookingUI: `bookingConfirmed()`
   - 16: BookingUI → Passenger: `showConfirmation()`
   - 17: Passenger → BookingUI: `confirmPayment()`
   - 18: BookingUI → BookingController: `processPayment()`
   - 19: BookingController → Payment: `create()`
   - 20: Payment → BookingController: `paymentId`
   - 21: BookingController → Payment: `process()`
   - 22: Payment → BookingController: `success`
   - 23: BookingController → Booking: `confirm()`
   - 24: Booking → BookingController: `updated`
   - 25: BookingController → BookingUI: `paymentSuccessful()`
   - 26: Passenger → BookingUI: `checkin()`
   - 27: BookingUI → CheckinController: `completeCheckin()`
   - 28: CheckinController → Booking: `checkStatus()`
   - 29: Booking → CheckinController: `confirmed`
   - 30: CheckinController → BoardingPass: `generate()`
   - 31: BoardingPass → CheckinController: `boardingPassId`
   - 32: CheckinController → BookingUI: `boardingPassGenerated()`
   - 33: BookingUI → Passenger: `showBoardingPass()`

**Справка:** см. PlantUML-исходник `diagrams/08_collaboration_diagram.puml`

### 8. Диаграмма ключевых абстракций
1. Щёлкните правой кнопкой на `Design Model` → New Diagram → Class Diagram
2. Название: `Key Abstractions`
3. Добавьте классы (сущности предметной области):
   - `Passenger` — пассажир
   - `Flight` — рейс
   - `Seat` — место
   - `Booking` — бронирование
   - `Airport` — аэропорт
   - `Payment` — платёж
   - `BoardingPass` — посадочный талон
4. Установите связи с кратностью:
   - Passenger → Booking: `1..*` (один пассажир делает много бронирований)
   - Flight → Booking: `1..*` (один рейс — много бронирований)
   - Flight → Seat: `1..*` (один рейс — много мест)
   - Seat → Booking: `0..1` (одно место — одно бронирование или свободно)
   - Booking → Payment: `0..1` (одно бронирование — один платёж)
   - Booking → BoardingPass: `0..1` (одно бронирование — один талон)
   - Airport → Flight: `1..*` (один аэропорт — много рейсов)

**Справка:** см. PlantUML-исходник `diagrams/09_key_abstractions.puml`

## Экспорт диаграмм
1. Для каждой диаграммы: Diagram → Export → Image (PNG или JPG)
2. Сохраните в папку `solution/lab_05/lab2/img/` с теми же именами, что в PlantUML:
   - `01_use_case_diagram.png`
   - `02_traceabilities_diagram.png`
   - `03_vopc_analysis_diagram.png`
   - `04_sequence_basic_flow_part1.png`
   - `05_sequence_basic_flow_part2.png`
   - `06_sequence_basic_flow_part3.png`
   - `07_sequence_basic_flow_part4.png`
   - `08_collaboration_diagram.png`
   - `09_key_abstractions.png`

## Обновление отчёта
1. Замените PNG-изображения в `solution/lab_05/lab2/img/` на новые из Visual Paradigm
2. Если нужно, обновите `report.docx` через md-to-docx skill или вручную

## Контрольные вопросы (из задания)
- Каково назначение диаграммы вариантов использования?
- Какие основные элементы включает диаграмма вариантов использования?
- Как создать диаграмму вариантов использования в Visual Paradigm?

**Примечание:** Если преподаватель требует отчёт в Word с пошаговым описанием построения — используйте структуру отчёта из ЛР 1 (вариант 10 — Таксопарк, `solution/lab1/README.md`).
