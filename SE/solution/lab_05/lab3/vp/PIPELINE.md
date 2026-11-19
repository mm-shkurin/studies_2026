# PlantUML → Visual Paradigm (вариант 1)

Проверено 2026-11-12 на Visual Paradigm CE 18.1 + [PlantUML-VP Plugin v1.0.0](https://github.com/nbourdi/PlantUML-VP-Plugin).

## Установка (один раз)

1. Скачать `plugin-plantuml-vp-v1.0.0.zip`.
2. Распаковать в `%APPDATA%\VisualParadigm\plugins\plugin-plantuml-vp\` (рядом должны быть `plugin.xml`, `classes/`, `lib/`).
3. Перезапустить Visual Paradigm (или достаточно CLI `Plugin.bat`).

Плагин уже установлен на этой машине.

## Импорт

Пустой шаблон проекта: копия `%APPDATA%\VisualParadigm\ws\.vpprefdata\.systemproject.vpp`.

```powershell
cd SE/solution/lab_05/lab3/vp
Copy-Item "$env:APPDATA\VisualParadigm\ws\.vpprefdata\.systemproject.vpp" .\AirportDesign.vpp
.\import-plantuml.ps1 -ProjectPath .\AirportDesign.vpp -PumlDir ..\diagrams
```

Или вручную из `VP\scripts`:

```text
Plugin.bat -project "...\AirportDesign.vpp" -pluginid "plugins.plantUML" -pluginargs -action "import" -path "...\diagrams"
```

## Экспорт PNG / скриншоты

CLI `ExportDiagramImage.bat` после импорта часто даёт почти пустой PNG (bounds до патча layout). В GUI при открытии появляется «Diagram Patched» — после этого диаграмма видна нормально.

Рабочий путь для сдачи:

1. Открыть `.vpp` в Visual Paradigm.
2. Закрыть «Diagram Patched».
3. Выделить диаграмму → Export / Print preview / скриншот → `../img/`.

Водяной знак Community Edition на экспорте нормален для CE.

## Что умеет плагин

| Тип | Импорт | Замечания |
|---|---|---|
| Class | да | `<<boundary>>` / `<<control>>` / `<<entity>>` рисуются как robustness-иконки, не как прямоугольники классов |
| Sequence простой | да | |
| Sequence `alt`/`else` | да (частично) | |
| Sequence `loop` внутри `alt` | **нет** | NPE в `SequenceDiagramImporter.extractGrouping` — flatten: без вложенных группировок |
| Deployment | да (частично) | проверять layout в GUI |
| Collaboration | нет | не в списке поддержки плагина |

## Smoke-тесты (эта папка)

- `AirportDesign_smoke2.vpp` — class из образца кинотеатра
- `seq_smoke.vpp` / `seq_alt.vpp` — sequence
- `deploy_smoke.vpp` — deployment
- `out/*.png` — CLI-экспорт (часто обрезан; GUI показывает полную модель)

## Следующий шаг для ЛР 3

1. Собрать `../diagrams/*.puml` для Аэропорта (по `README_VP.md` и образцу `materials/lab_3/diagrams/`).
2. Sequence без вложенного `loop` в `alt` (разнести или упростить).
3. `import-plantuml.ps1` → открыть в VP → скриншоты в `../img/`.
