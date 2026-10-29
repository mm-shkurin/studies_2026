# Инструкция: ЛР 2 в Visual Paradigm (вариант 10 — Таксопарк)

## Цель
Перенести PlantUML-диаграммы из `diagrams/*.puml` в Visual Paradigm для UML-анализа системы заказа такси.

## Что нужно построить
По методологии главы 3 UML (2).pdf (стр. 53–105):

1. **Диаграмма вариантов использования** — актёры и прецеденты
2. **Диаграмма трассировки прецедентов** — связь Use Case → Use-Case Realization → классы
3. **Диаграмма классов анализа VOPC** — граничные, управляющие, сущностные классы
4. **Диаграммы последовательности** — 4 фазы основного сценария Purchase Ride
5. **Диаграмма кооперации** — коммуникационная диаграмма для того же сценария
6. **Диаграмма ключевых абстракций** — предметные классы таксопарка

## Пошаговая инструкция

### 1. Создание проекта
1. Откройте Visual Paradigm
2. File → New Project → UML Project
3. Название проекта: `TaxiPark` (или `TaxiService`)
4. Создайте пустой проект

### 2. Организация пакетов
В Project Browser создайте структуру:
```
Design Model
└── Use-Case Realizations
    ├── Purchase Ride Realization
    ├── Cancel Ride Realization
    └── Rate Ride Realization
```

### 3. Диаграмма вариантов использования
1. Щёлкните правой кнопкой на `Design Model` → New Diagram → Use Case Diagram
2. Название: `Use Case Diagram`
3. Добавьте элементы:
   - **Система** (System Boundary): `Система заказа такси`
   - **Актёры** (Actor):
     - `Пассажир`
     - `Водитель`
     - `Диспетчер`
   - **Прецеденты** (Use Case):
     - `Заказать такси` (основной)
     - `Выполнить поездку` (основной)
     - `Проверить наличие свободных машин` (include для Заказать такси)
     - `Назначить водителя` (include для Выполнить поездку)
     - `Рассчитать стоимость` (include для Заказать такси)
     - `Оплатить поездку` (include для Заказать такси)
     - `Отменить заказ` (extend для Заказать такси)
     - `Оценить поездку` (extend для Выполнить поездку)
4. Установите связи:
   - Association: Пассажир → Заказать такси, Выполнить поездку, Оценить поездку
   - Association: Водитель → Выполнить поездку
   - Association: Диспетчер → Выполнить поездку
   - Include: Заказать такси include Проверить наличие свободных машин, Рассчитать стоимость, Оплатить поездку
   - Include: Выполнить поездку include Назначить водителя
   - Extend: Отменить заказ extend Заказать такси
   - Extend: Оценить поездку extend Выполнить поездку
5. Установите кратность (Multiplicity) на связях:
   - Пассажир → Заказать такси: `1..*` (один пассажир делает много заказов)
   - Водитель → Выполнить поездку: `1..*` (один водитель выполняет много поездок)

**Справка:** см. PlantUML-исходник `diagrams/01_use_case_diagram.puml`

### 4. Диаграмма трассировки прецедентов
1. Щёлкните правой кнопкой на `Use-Case Realizations` → New Diagram → Class Diagram
2. Название: `Traceability Diagram`
3. Добавьте элементы:
   - **Прецеденты** (Use Case): Заказать такси, Выполнить поездку, Отменить заказ, Оценить поездку
   - **Реализации** (Use-Case Realization): Purchase Ride Realization, Cancel Ride Realization, Rate Ride Realization
   - **Классы** (Class): RideController, Ride, Driver, Vehicle, Payment, Rating
4. Установите связи (Dependency):
   - Закать такси → Purchase Ride Realization
   - Выполнить поездку → Purchase Ride Realization
   - Отменить заказ → Cancel Ride Realization
   - Оценить поездку → Rate Ride Realization
   - Purchase Ride Realization → RideController, Ride, Driver, Vehicle, Payment
   - Cancel Ride Realization → Ride, Driver
   - Rate Ride Realization → Rating, Ride

**Справка:** см. PlantUML-исходник `diagrams/02_traceabilities_diagram.puml`

### 5. Диаграмма классов анализа VOPC
1. Щёлкните правой кнопкой на `Purchase Ride Realization` → New Diagram → Class Diagram
2. Название: `VOPC Analysis Diagram`
3. Добавьте классы со стереотипами:
   - **Граничные** (<<Boundary>>):
     - `RideUI` — интерфейс пассажира
     - `PaymentGateway` — внешний платёжный шлюз
     - `LocationService` — внешний сервис геолокации
   - **Управляющие** (<<Control>>):
     - `RideController` — контроллер заказа
   - **Сущностные** (<<Entity>>):
     - `Ride` — заказ на поездку
     - `Driver` — водитель
     - `Vehicle` — автомобиль
     - `Location` — местоположение
     - `Payment` — платёж
     - `Rating` — оценка
4. Установите связи (Association):
   - RideUI → RideController (создаёт заказ)
   - RideController → Ride (создаёт/изменяет)
   - RideController → Driver (запрашивает доступность)
   - RideController → Vehicle (проверяет)
   - RideController → PaymentGateway (оправляет платёж)
   - RideController → LocationService (запрашивает геолокацию)
   - Ride → Driver (назначение)
   - Ride → Vehicle (через водителя)
   - Ride → Location (адрес подачи/назначения)
   - Ride → Payment (оплатный статус)
   - Ride → Rating (оценка после завершения)
5. Установите кратность:
   - Ride → Driver: `1..1` (один водитель на заказ)
   - Ride → Location: `2..2` (адрес подачи и назначения)

**Справка:** см. PlantUML-исходник `diagrams/03_vopc_analysis_diagram.puml`

### 6. Диаграммы последовательности (4 фазы)

#### Фаза 1: Поиск машин
1. Щёлкните правой кнопкой на `Purchase Ride Realization` → New Diagram → Sequence Diagram
2. Название: `Sequence Part 1 - Search Available Vehicles`
3. Добавьте объекты (Lifeline):
   - `:Passenger` (пассажир)
   - `:RideUI` (интерфейс)
   - `:RideController` (контроллер)
   - `:Driver` (водитель)
   - `:Vehicle` (автомобиль)
4. Добавьте сообщения:
   - Passenger → RideUI: `searchAvailableVehicles(location)`
   - RideUI → RideController: `searchAvailableVehicles(location)`
   - RideController → Driver: `checkAvailability()`
   - Driver → Vehicle: `isAvailable()`
   - Vehicle → Driver: `true`
   - Driver → RideController: `available`
   - RideController → RideUI: `listOfAvailableDrivers`
   - RideUI → Passenger: `displayResults()`

**Справка:** см. PlantUML-исходник `diagrams/04_sequence_basic_flow_part1.puml`

#### Фаза 2: Назначение водителя
1. New Diagram → Sequence Diagram
2. Название: `Sequence Part 2 - Assign Driver`
3. Объекты:
   - `:Passenger`
   - `:RideUI`
   - `:RideController`
   - `:Ride` (заказ)
   - `:Driver`
4. Сообщения:
   - Passenger → RideUI: `selectDriver(driverId)`
   - RideUI → RideController: `assignDriver(driverId, location)`
   - RideController → Ride: `create(passenger, driver, location)`
   - Ride → RideController: `rideId`
   - RideController → Driver: `confirmAssignment(rideId)`
   - Driver → RideController: `confirmed`
   - RideController → RideUI: `assignmentConfirmed(rideId)`
   - RideUI → Passenger: `showConfirmation()`

**Справка:** см. PlantUML-исходник `diagrams/05_sequence_basic_flow_part2.puml`

#### Фаза 3: Оплата
1. New Diagram → Sequence Diagram
2. Название: `Sequence Part 3 - Payment`
3. Объекты:
   - `:Passenger`
   - `:RideUI`
   - `:RideController`
   - `:PaymentGateway`
   - `:Payment`
4. Сообщения:
   - Passenger → RideUI: `confirmPayment(rideId, paymentMethod)`
   - RideUI → RideController: `processPayment(rideId, paymentMethod)`
   - RideController → Payment: `create(rideId, amount)`
   - Payment → RideController: `paymentId`
   - RideController → PaymentGateway: `charge(paymentId, amount)`
   - PaymentGateway → RideController: `success`
   - RideController → Ride: `markAsPaid()`
   - Ride → RideController: `updated`
   - RideController → RideUI: `paymentSuccessful()`

**Справка:** см. PlantUML-исходник `diagrams/06_sequence_basic_flow_part3.puml`

#### Фаза 4: Выполнение поездки
1. New Diagram → Sequence Diagram
2. Название: `Sequence Part 4 - Complete Ride`
3. Объекты:
   - `:Driver`
   - `:RideController`
   - `:Ride`
   - `:Rating`
   - `:Passenger`
4. Сообщения:
   - Driver → RideController: `startRide(rideId)`
   - RideController → Ride: `updateStatus(in_progress)`
   - Driver → RideController: `completeRide(rideId)`
   - RideController → Ride: `updateStatus(completed)`
   - Passenger → RideController: `rateRide(rideId, rating)`
   - RideController → Rating: `create(rideId, rating)`
   - Rating → RideController: `ratingId`
   - RideController → Ride: `addRating(ratingId)`

**Справка:** см. PlantUML-исходник `diagrams/07_sequence_basic_flow_part4.puml`

### 7. Диаграмма кооперации
1. Щёлкните правой кнопкой на `Purchase Ride Realization` → New Diagram → Communication Diagram
2. Название: `Collaboration Diagram`
3. Добавьте объекты:
   - `:Passenger`
   - `:RideUI`
   - `:RideController`
   - `:Ride`
   - `:Driver`
   - `:Vehicle`
   - `:Location`
   - `:Payment`
   - `:Rating`
4. Добавьте сообщения с номерами (в том же порядке, что и в диаграммах последовательности):
   - 1: Passenger → RideUI: `searchAvailableVehicles()`
   - 2: RideUI → RideController: `searchAvailableVehicles()`
   - 3: RideController → Driver: `checkAvailability()`
   - 4: Driver → Vehicle: `isAvailable()`
   - 5: Vehicle → Driver: `true`
   - 6: Driver → RideController: `available`
   - 7: RideController → RideUI: `listOfAvailableDrivers`
   - 8: RideUI → Passenger: `displayResults()`
   - 9: Passenger → RideUI: `selectDriver(driverId)`
   - 10: RideUI → RideController: `assignDriver(driverId, location)`
   - 11: RideController → Ride: `create()`
   - 12: Ride → RideController: `rideId`
   - 13: RideController → Driver: `confirmAssignment(rideId)`
   - 14: Driver → RideController: `confirmed`
   - 15: RideController → RideUI: `assignmentConfirmed(rideId)`
   - 16: RideUI → Passenger: `showConfirmation()`
   - 17: Passenger → RideUI: `confirmPayment(rideId, paymentMethod)`
   - 18: RideUI → RideController: `processPayment(rideId, paymentMethod)`
   - 19: RideController → Payment: `create()`
   - 20: Payment → RideController: `paymentId`
   - 21: RideController → PaymentGateway: `charge(paymentId, amount)`
   - 22: PaymentGateway → RideController: `success`
   - 23: RideController → Ride: `markAsPaid()`
   - 24: Ride → RideController: `updated`
   - 25: RideController → RideUI: `paymentSuccessful()`
   - 26: Driver → RideController: `startRide(rideId)`
   - 27: RideController → Ride: `updateStatus(in_progress)`
   - 28: Driver → RideController: `completeRide(rideId)`
   - 29: RideController → Ride: `updateStatus(completed)`
   - 30: Passenger → RideController: `rateRide(rideId, rating)`
   - 31: RideController → Rating: `create(rideId, rating)`
   - 32: Rating → RideController: `ratingId`
   - 33: RideController → Ride: `addRating(ratingId)`

**Справка:** см. PlantUML-исходник `diagrams/08_collaboration_diagram.puml`

### 8. Диаграмма ключевых абстракций
1. Щёлкните правой кнопкой на `Design Model` → New Diagram → Class Diagram
2. Название: `Key Abstractions`
3. Добавьте классы (сущности предметной области):
   - `Passenger` — пассажир
   - `Driver` — водитель
   - `Ride` — заказ на поездку
   - `Vehicle` — автомобиль
   - `Location` — местоположение
   - `Payment` — платёж
   - `Rating` — оценка
4. Установите связи с кратностью:
   - Passenger → Ride: `1..*` (один пассажир делает много заказов)
   - Driver → Ride: `1..*` (один водитель выполняет много поездок)
   - Driver → Vehicle: `1..1` (один водитель — один автомобиль)
   - Ride → Vehicle: `1..1` (один заказ — один автомобиль)
   - Ride → Location: `2..2` (адрес подачи и назначения)
   - Ride → Payment: `0..1` (один платёж на заказ)
   - Ride → Rating: `0..1` (одна оценка на заказ)

**Справка:** см. PlantUML-исходник `diagrams/09_key_abstractions.puml`

## Экспорт диаграмм
1. Для каждой диаграммы: Diagram → Export → Image (PNG или JPG)
2. Сохраните в папку `solution/lab2/img/` с теми же именами, что в PlantUML:
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
1. Замените PNG-изображения в `solution/lab2/img/` на новые из Visual Paradigm
2. Если нужно, обновите `report.docx` через md-to-docx skill или вручную

## Контрольные вопросы (из задания)
- Каково назначение диаграммы вариантов использования?
- Какие основные элементы включает диаграмма вариантов использования?
- Как создать диаграмму вариантов использования в Visual Paradigm?

**Примечание:** Если преподаватель требует отчёт в Word с пошаговым описанием построения — используйте структуру отчёта из ЛР 1 (вариант 10 — Таксопарк, `solution/lab1/README.md`).
