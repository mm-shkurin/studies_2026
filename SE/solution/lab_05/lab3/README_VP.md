# Инструкция: ЛР 3 в Visual Paradigm (вариант 5 — Аэропорт)

## Цель
Перенести PlantUML-диаграммы из `diagrams/*.puml` в Visual Paradigm для перехода от анализа (ЛР 2) к проектированию классов и архитектуры системы управления аэропортом.

## Что нужно построить
По методологии главы 3 UML (2).pdf (стр. 84–101, раздел 3.6 «Проектирование»):

1. **Операции классов анализа** — методы, выведенные из сообщений сценариев ЛР 2
2. **Атрибуты и операции** — полная спецификация классов с типами
3. **Специализация сущностей** — наследование для подтипов (RegisteredPassenger/GuestPassenger, OnlinePayment/CashPayment)
4. **Класс-ассоциация доступности** — SeatAvailability для пары Flight/Seat
5. **Полная VOPC-модель** — граничные, управляющие, сущностные классы с связями
6. **Логические слои** — трёхслойная BCE-архитектура (Application/Business/Integration)
7. **Зависимости подсистем** — продажи, каталог, платежи, уведомления
8. **Интерфейс каталога** — IFlightCatalog для чтения рейсов
9. **Чтение каталога: последовательность** — сценарий запроса рейсов
10. **Инициализация каталога: последовательность** — сценарий запуска
11. **Развёртывание** — сетевая топология с протоколами

## Пошаговая инструкция

### 1. Создание проекта
1. Откройте Visual Paradigm
2. File → New Project → UML Project
3. Название проекта: `AirportSystem` (или `AirportDesign`)
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

### 3. Диаграмма 1: Операции классов анализа
1. Щёлкните правой кнопкой на `Purchase Realization` → New Diagram → Class Diagram
2. Название: `Classes with Analysis Operations`
3. Добавьте классы со стереотипами и операциями (из сообщений ЛР 2):
   - **Граничные** (<<Boundary>>):
     - `BookingUI` — интерфейс пассажира
       - `+searchFlights(criteria)`
       - `+showSeatMap(flightId)`
       - `+showPaymentResult(result)`
     - `FlightCatalogBoundary` — граничный класс каталога рейсов
       - `+getPublishedFlights(criteria)`
     - `PaymentGatewayBoundary` — граничный класс платёжного шлюза
       - `+charge(amount, operationId)`
     - `NotificationBoundary` — граничный класс уведомлений
       - `+sendBoardingPass(passId, operationId)`
   - **Управляющие** (<<Control>>):
     - `BookingController` — контроллер бронирования
       - `+searchFlights(criteria)`
       - `+reserveSeats(flightId, seats)`
       - `+pay(bookingId, operationId)`
       - `+getPaidTicket(bookingId)`
     - `CheckinController` — контроллер регистрации
       - `+completeCheckin(booking)`
   - **Сущностные** (<<Entity>>):
     - `Flight` — рейс
       - `+currentSeatStates()`
       - `+lockSeats(seats, timeout)`
       - `+confirmSeatSold(seat, ticketId)`
       - `+releaseSeat(seat, ticketId)`
     - `Booking` — бронирование
       - `+getTotal()`
       - `+getExpiresAt()`
     - `BoardingPass` — посадочный талон
       - `+markPaid(transactionId)`
       - `+cancel()`
       - `+getStatus()`
4. Установите связи (Association):
   - BookingUI → BookingController
   - BookingController → FlightCatalogBoundary
   - BookingController → PaymentGatewayBoundary
   - BookingController → NotificationBoundary
   - BookingController → Flight
   - BookingController → Booking
   - Booking → BoardingPass

**Справка:** см. образец `materials/lab_3/diagrams/01_classes_with_analysis_operations.puml`

### 4. Диаграмма 2: Атрибуты и операции
1. New Diagram → Class Diagram
2. Название: `Classes with Attributes and Operations`
3. Добавьте классы с полными атрибутами и операциями:
   - `Passenger` <<entity>>
     - `id: String`
     - `name: String`
     - `passport: String`
     - `email: String`
     - `phone: String`
     - `+getProfile(): Profile`
   - `Flight` <<entity>>
     - `id: String`
     - `flightNumber: String`
     - `departureTime: DateTime`
     - `arrivalTime: DateTime`
     - `origin: String`
     - `destination: String`
     - `+isAvailable(): Boolean`
   - `Seat` <<entity>>
     - `id: String`
     - `seatNumber: String`
     - `row: Integer`
     - `position: String`
     - `status: SeatStatus`
     - `flight: Flight`
     - `+isAvailable(): Boolean`
   - `Booking` <<entity>>
     - `id: String`
     - `passenger: Passenger`
     - `flight: Flight`
     - `seat: Seat`
     - `status: BookingStatus`
     - `price: Money`
     - `bookingTime: DateTime`
     - `+cancel(): Void`
     - `+confirm(): Void`
   - `Payment` <<entity>>
     - `id: String`
     - `amount: Money`
     - `method: PaymentMethod`
     - `status: PaymentStatus`
     - `+process(): PaymentResult`
   - `BoardingPass` <<entity>>
     - `id: String`
     - `booking: Booking`
     - `gate: String`
     - `seatNumber: String`
     - `boardingTime: DateTime`
     - `+generate(): BoardingPass`
4. Установите связи с кратностью:
   - Passenger → Booking: `1..*`
   - Flight → Booking: `1..*`
   - Flight → Seat: `1..*`
   - Booking → Seat: `1..1`
   - Booking → Payment: `0..1`
   - Booking → BoardingPass: `0..1`

**Справка:** см. образец `materials/lab_3/diagrams/02_classes_with_attributes_and_operations.puml`

### 5. Диаграмма 3: Специализация сущностей
1. New Diagram → Class Diagram
2. Название: `Entity Classes Specialization`
3. Добавьте классы с наследованием:
   - `Passenger` <<entity>> (базовый класс)
     - `RegisteredPassenger` <<entity>> (зарегистрированный пассажир)
       - `profile: PassengerProfile`
       - `loyaltyPoints: Integer`
     - `GuestPassenger` <<entity>> (гость без регистрации)
       - `temporaryId: String`
   - `Payment` <<entity>> (базовый класс)
     - `OnlinePayment` <<entity>> (онлайн-оплата)
       - `transactionId: String`
       - `paymentMethod: PaymentMethod`
     - `CashPayment` <<entity>> (оплата в кассе)
       - `cashierId: String`
       - `terminalId: String`
4. Установите связи (Generalization):
   - RegisteredPassenger → Passenger
   - GuestPassenger → Passenger
   - OnlinePayment → Payment
   - CashPayment → Payment

**Справка:** см. образец `materials/lab_3/diagrams/03_entity_classes_specialization.puml`

### 6. Диаграмма 4: Класс-ассоциация доступности
1. New Diagram → Class Diagram
2. Название: `Association Class Seat Availability`
3. Добавьте классы:
   - `Flight` <<entity>>
   - `Seat` <<entity>>
   - `SeatAvailability` <<association class>> (класс-ассоциация)
     - `status: SeatStatus`
     - `lockedUntil: DateTime`
     - `bookingId: String`
4. Установите связи:
   - Flight → SeatAvailability (Association, кратность `1..*`)
   - Seat → SeatAvailability (Association, кратность `0..*`)
   - Класс-ассоциация SeatAvailability прикрепляется к связи между Flight и Seat

**Справка:** см. образец `materials/lab_3/diagrams/04_association_classes_seat_availability.puml`

### 7. Диаграмма 5: Полная VOPC-модель
1. New Diagram → Class Diagram
2. Название: `Full VOPC Class Diagram`
3. Добавьте все классы проекта:
   - **Граничные** (<<Boundary>>):
     - `BookingUI`
     - `PaymentGatewayBoundary`
     - `NotificationBoundary`
     - `FlightCatalogBoundary`
   - **Управляющие** (<<Control>>):
     - `BookingController`
     - `RefundController` (для возврата билетов)
   - **Сущностные** (<<Entity>>):
     - `Passenger`
     - `Flight`
     - `Airport`
     - `Seat`
     - `SeatAvailability`
     - `Booking`
     - `BoardingPass`
     - `Payment`
4. Установите все связи с кратностью:
   - BookingUI → BookingController
   - BookingController → FlightCatalogBoundary
   - BookingController → PaymentGatewayBoundary
   - BookingController → NotificationBoundary
   - BookingController → Flight
   - BookingController → Booking
   - RefundController → BoardingPass
   - Passenger → Booking: `1..*`
   - Flight → Booking: `1..*`
   - Airport → Flight: `1..*`
   - Flight → Seat: `1..*`
   - Flight → SeatAvailability: `1..*`
   - Seat → SeatAvailability: `0..*`
   - Booking → BoardingPass: `1..*`
   - Booking → Payment: `0..1`
   - BoardingPass → Flight: `1..1`
   - BoardingPass → Seat: `1..1`

**Справка:** см. образец `materials/lab_3/diagrams/05_full_vopc_class_diagram.puml`

### 8. Диаграмма 6: Логические слои
1. New Diagram → Class Diagram
2. Название: `Logical View Layers Architecture`
3. Создайте пакеты:
   - **Application Layer** (прикладной слой):
     - `WebBookingBoundary` <<boundary>> (веб-интерфейс)
     - `CashierBoundary` <<boundary>> (кассовый терминал)
     - `BookingWorkflow` <<control>> (рабочий процесс)
   - **Business Services Layer** (сервисный слой):
     - `BookingController` <<control>>
     - `ScheduleController` <<control>>
     - `BoardingPass` <<entity>>
   - **Integration Boundary Layer** (интеграционный слой):
     - `PersistenceBoundary` <<boundary>> (БД)
     - `PaymentGatewayBoundary` <<boundary>> (платёжный шлюз)
     - `NotificationBoundary` <<boundary>> (уведомления)
     - `LegacyFlightCatalogBoundary` <<boundary>> (внешний каталог)
4. Установите зависимости (Dependency):
   - WebBookingBoundary → BookingWorkflow
   - CashierBoundary → BookingWorkflow
   - BookingWorkflow → BookingController
   - BookingWorkflow → ScheduleController
   - BookingController → BoardingPass
   - BookingController → PersistenceBoundary
   - BookingController → PaymentGatewayBoundary
   - BookingController → NotificationBoundary
   - ScheduleController → LegacyFlightCatalogBoundary
   - ScheduleController → PersistenceBoundary

**Справка:** см. образец `materials/lab_3/diagrams/06_logical_view_layers_architecture.puml`

### 9. Диаграмма 7: Зависимости подсистем
1. New Diagram → Class Diagram
2. Название: `Subsystem Dependencies`
3. Добавьте подсистемы (Subsystem или Package):
   - `Booking Subsystem` (подсистема бронирования)
   - `Flight Catalog Subsystem` (подсистема каталога рейсов)
   - `Seat Management Subsystem` (подсистема управления местами)
   - `Payment Subsystem` (подсистема платежей)
   - `Notification Subsystem` (подсистема уведомлений)
4. Установите зависимости (Dependency):
   - Booking Subsystem → Flight Catalog Subsystem
   - Booking Subsystem → Seat Management Subsystem
   - Booking Subsystem → Payment Subsystem
   - Booking Subsystem → Notification Subsystem

**Справка:** см. образец `materials/lab_3/diagrams/07_subsystem_dependencies.puml`

### 10. Диаграмма 8: Интерфейс каталога
1. New Diagram → Class Diagram
2. Название: `Subsystem Interface Classes`
3. Добавьте классы:
   - `IFlightCatalog` <<interface>> (интерфейс каталога)
     - `+getFlights(criteria): List<Flight>`
     - `+getFlight(flightId): Flight`
   - `FlightCatalogBoundary` <<boundary>> (реализация интерфейса)
     - `+getFlights(criteria): List<Flight>`
     - `+getFlight(flightId): Flight`
   - `LegacyFlightCatalogBoundary` <<boundary>> (внешний каталог)
     - `+checkReadOnlyConnection(): Boolean`
   - `FlightMapper` <<entity>> (маппер)
     - `+mapFromRow(row): Flight`
4. Установите связи:
   - FlightCatalogBoundary → IFlightCatalog (Realization)
   - FlightCatalogBoundary → LegacyFlightCatalogBoundary (Association)
   - FlightCatalogBoundary → FlightMapper (Association)

**Справка:** см. образец `materials/lab_3/diagrams/08_subsystem_interface_classes.puml`

### 11. Диаграмма 9: Чтение каталога: последовательность
1. New Diagram → Sequence Diagram
2. Название: `Subsystem Get Flights Sequence`
3. Добавьте объекты (Lifeline):
   - `:BookingController`
   - `:IFlightCatalog`
   - `:FlightCatalogBoundary`
   - `:LegacyFlightCatalogBoundary`
   - `:FlightMapper`
4. Добавьте сообщения:
   - BookingController → IFlightCatalog: `getFlights(criteria)`
   - FlightCatalogBoundary → LegacyFlightCatalogBoundary: `checkReadOnlyConnection()`
   - LegacyFlightCatalogBoundary → FlightCatalogBoundary: `true`
   - FlightCatalogBoundary → LegacyFlightCatalogBoundary: `queryFlights(criteria)`
   - LegacyFlightCatalogBoundary → FlightCatalogBoundary: `rows`
   - FlightCatalogBoundary → FlightMapper: `mapFromRow(row)`
   - FlightMapper → FlightCatalogBoundary: `flight`
   - FlightCatalogBoundary → BookingController: `flights`

**Справка:** см. образец `materials/lab_3/diagrams/09_subsystem_get_movies_sequence.puml`

### 12. Диаграмма 10: Инициализация каталога: последовательность
1. New Diagram → Sequence Diagram
2. Название: `Subsystem Initialize Sequence`
3. Добавьте объекты:
   - `:FlightCatalogBoundary`
   - `:LegacyFlightCatalogBoundary`
4. Добавьте сообщения:
   - FlightCatalogBoundary → FlightCatalogBoundary: `startup()`
   - FlightCatalogBoundary → LegacyFlightCatalogBoundary: `checkReadOnlyConnection()`
   - LegacyFlightCatalogBoundary → FlightCatalogBoundary: `true`
   - FlightCatalogBoundary → FlightCatalogBoundary: `readyToServe()`

**Справка:** см. образец `materials/lab_3/diagrams/10_subsystem_initialize_sequence.puml`

### 13. Диаграмма 11: Развёртывание
1. New Diagram → Deployment Diagram
2. Название: `Deployment Airport System`
3. Добавьте узлы (Node):
   - `Устройство пассажира` <<device>> (браузер)
   - `Кассовый терминал` <<device>>
   - `Сервер приложения\nBooking / Schedule\nFlightCatalogBoundary` <<device>>
   - `PostgreSQL\nAirport OLTP` <<device>>
   - `Redis\nSeatHold TTL` <<device>>
   - `Внешний PostgreSQL\nКаталог рейсов: read-only` <<device>>
   - `Платёжный провайдер` <<external>>
   - `Провайдер уведомлений` <<external>>
4. Установите связи (Communication Path) с протоколами:
   - Устройство пассажира → Сервер приложения: `HTTP/1.1 / TLS 1.3\nTCP 443 / IPv4\nIEEE 802.11 → 802.3`
   - Кассовый терминал → Сервер приложения: `HTTP/1.1 / TLS 1.3\nTCP 443 / IPv4 / IEEE 802.3`
   - Сервер приложения → PostgreSQL: `PostgreSQL wire v3 / TLS 1.3\nTCP 5432 / IPv4 / IEEE 802.3`
   - Сервер приложения → Redis: `RESP2 / TLS 1.3\nTCP 6380 / IPv4 / IEEE 802.3`
   - Сервер приложения → Внешний PostgreSQL: `PostgreSQL wire v3 / TLS 1.3\nTCP 5432 / IPv4 / IEEE 802.3`
   - Сервер приложения → Платёжный провайдер: `HTTP/1.1 / TLS 1.3\nTCP 443 / IPv4 / Ethernet`
   - Сервер приложения → Провайдер уведомлений: `HTTP/1.1 / TLS 1.3\nTCP 443 / IPv4 / Ethernet`

**Справка:** см. образец `materials/lab_3/diagrams/11_deployment_cinema_system.puml`

## Экспорт диаграмм
1. Для каждой диаграммы: Diagram → Export → Image (PNG или JPG)
2. Сохраните в папку `solution/lab_05/lab3/img/` с именами:
   - `01_classes_with_analysis_operations.png`
   - `02_classes_with_attributes_and_operations.png`
   - `03_entity_classes_specialization.png`
   - `04_association_classes_seat_availability.png`
   - `05_full_vopc_class_diagram.png`
   - `06_logical_view_layers_architecture.png`
   - `07_subsystem_dependencies.png`
   - `08_subsystem_interface_classes.png`
   - `09_subsystem_get_flights_sequence.png`
   - `10_subsystem_initialize_sequence.png`
   - `11_deployment_airport_system.png`

## Контрольные вопросы
- Каково назначение диаграммы классов проектирования?
- Чем отличаются классы анализа от классов проектирования?
- Зачем нужны логические слои в архитектуре?
- Что показывает диаграмма развёртывания?
- Как класс-ассоциация SeatAvailability отражает состояние места?

## Источники
- Методология: `materials/notes/UML (2).md` <!-- стр. 84–101 (глава 3.6 Проектирование) -->
- Образец структуры: `materials/notes/lab_3_REPORT.md`
- PlantUML-исходники образца: `materials/lab_3/diagrams/*.puml`
- Предметная область: ЛР 2 (вариант 5 — Аэропорт)
