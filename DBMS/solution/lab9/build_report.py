"""Сборка отчёта по ЛР 9 (СУБД): python build_report.py -> report.docx."""
from pathlib import Path

from docx import Document
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_BREAK
from docx.shared import Cm, Pt, Inches

STUDENT = "ФИО"
GROUP = "ФИТ-242"
COURSE = "3"
DIRECTION = "02.03.02 Фундаментальная информатика и информационные технологии"
TEACHER = "Моисеева Н.А."
HERE = Path(__file__).resolve().parent


def para(doc, text="", bold=False, align=None, size=14):
    p = doc.add_paragraph()
    if align is not None:
        p.alignment = align
    p.paragraph_format.space_after = Pt(0)
    p.paragraph_format.space_before = Pt(0)
    if text:
        run = p.add_run(text)
        run.bold = bold
        run.font.size = Pt(size)
        run.font.name = "Times New Roman"
    return p


def heading(doc, text):
    para(doc, text, bold=True)
    para(doc)


def code(doc, text):
    for line in text.splitlines():
        p = para(doc, line if line else " ", size=10)
        p.paragraph_format.left_indent = Cm(0.5)


def main():
    doc = Document()
    sec = doc.sections[0]
    sec.page_height, sec.page_width = Cm(29.7), Cm(21)
    sec.left_margin, sec.right_margin = Cm(3), Cm(1.5)
    sec.top_margin = sec.bottom_margin = Cm(2)
    st = doc.styles["Normal"]
    st.font.name = "Times New Roman"
    st.font.size = Pt(14)

    c = WD_ALIGN_PARAGRAPH.CENTER
    for line in (
        "Министерство науки и высшего образования РФ",
        "федеральное государственное автономное образовательное учреждение высшего образования",
        "«Омский государственный технический университет»",
        "",
        "Факультет информационных технологий и компьютерных систем",
        "Кафедра «Прикладная математика и фундаментальная информатика»",
    ):
        para(doc, line, align=c)
    for _ in range(4):
        para(doc)
    para(doc, "Лабораторная работа № 9", bold=True, align=c, size=16)
    para(doc, "по дисциплине «Системы управления базами данных»", align=c)
    para(doc, "Тема: Работа с курсорами в PostgreSQL", align=c)
    para(doc, "Предметная область: чемпионат «Формула-1»", align=c)
    for _ in range(3):
        para(doc)
    for k, v in (
        ("Студента", STUDENT),
        ("Курс", COURSE),
        ("Группа", GROUP),
        ("Направление", DIRECTION),
        ("Преподаватель", TEACHER),
    ):
        para(doc, f"{k}: {v}", align=WD_ALIGN_PARAGRAPH.RIGHT)
    for _ in range(3):
        para(doc)
    p = para(doc, "Омск 2026", align=c)
    p.runs[0].add_break(WD_BREAK.PAGE)

    heading(doc, "Цель работы")
    para(doc, "Научиться обрабатывать результат запроса построчно: открыть связанный курсор, прочитать строки командой FETCH и закрыть курсор внутри хранимой процедуры.")

    heading(doc, "Задание")
    para(doc, "По практической работе пособия «Работа с СУБД PostgreSQL», с. 147, для созданной базы данных нужно решить несколько задач с курсорами, включив курсор в хранимую процедуру, и составить отчёт. В образце две задачи: выборка с необязательными параметрами (с. 147–149) и перенос подмножества строк в отдельную таблицу (с. 149–150).")

    heading(doc, "1. Выборка результатов гонок")
    para(doc, "Процедура result_select принимает три параметра: код гонки, код пилота и код болида. NULL означает, что по этому полю фильтр не ставится. Курсор объявлен вместе с запросом. Каждая прочитанная строка печатается через RAISE NOTICE: код и название гонки, код и имя пилота, код и модель болида, место и очки.")

    heading(doc, "2. Результаты гонок за май 2026 года")
    para(doc, "Таблица may_results пуста в момент вызова. Процедура fill_may курсором читает результаты тех гонок, чья дата лежит между 1 и 31 мая 2026 года, и вставляет их в эту таблицу. Дата записана литералом DATE, а не строкой вида 01-02-2023 из образца: такая строка зависит от DateStyle сервера. Сама процедура строки не удаляет.")
    code(doc, (HERE / "cursors.sql").read_text(encoding="utf-8"))

    heading(doc, "3. Проверка")
    para(doc, "На контрольных данных четыре результата: две гонки, два пилота, три болида. Вызов со всеми NULL печатает 4 строки. Вызов только с гонкой 1 и только с пилотом 1 печатает по 2 строки. Вызов только с болидом 1 печатает 1 строку: во второй гонке тот же пилот едет на другом болиде. Вызов с гонкой 1 и пилотом 1 печатает 1 строку. После fill_may в may_results две строки майской гонки, и это совпадает с обычным SELECT по той же дате.")

    heading(doc, "Рисунки")
    img = HERE / "img"
    names = [
        ("01_select_all.png", "Все результаты"),
        ("02_select_race.png", "Только гонка 1"),
        ("03_select_driver.png", "Только пилот 1"),
        ("04_select_car.png", "Только болид 1"),
        ("05_select_pair.png", "Гонка 1 и пилот 1"),
        ("06_may_results.png", "Таблица may_results"),
    ]
    found = False
    for i, (name, caption) in enumerate(names, 1):
        path = img / name
        if not path.exists():
            continue
        found = True
        doc.add_picture(str(path), width=Inches(5.5))
        para(doc, f"Рисунок {i}. {caption}", align=c)
    if not found:
        para(doc, "Рисунки из pgAdmin в отчёт ещё не вставлены. Их снимает студент и кладёт в каталог img, после чего отчёт собирается заново.")

    heading(doc, "Вывод")
    para(doc, "Курсор внутри процедуры даёт построчный проход по результату запроса. Первая процедура показывает выбранные строки сразу, вторая переписывает отобранные строки в отдельную таблицу. Оба приёма взяты из образца пособия и перенесены на результаты гонок чемпионата «Формула-1».")

    doc.save(HERE / "report.docx")


if __name__ == "__main__":
    main()
