"""Сборка отчёта по ЛР 8 (СУБД): python build_report.py -> report.docx."""
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
    para(doc, "Лабораторная работа № 8", bold=True, align=c, size=16)
    para(doc, "по дисциплине «Системы управления базами данных»", align=c)
    para(doc, "Тема: Создание хранимых процедур и триггеров средствами PL/pgSQL", align=c)
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
    para(doc, "Научиться создавать триггеры модификации данных на PL/pgSQL: журнал изменений строки и запрет недопустимого значения при вставке.")

    heading(doc, "Задание")
    para(doc, "По практической работе пособия «Работа с СУБД PostgreSQL», с. 157, для созданной базы данных нужно написать два триггера, срабатывающих при модификации данных, и составить отчёт. Образец аудита — с. 157–158, образец запрета вставки — с. 159. Предметная область — чемпионат «Формула-1».")

    heading(doc, "1. Триггер аудита пилотов")
    para(doc, "Таблица driver_audit хранит код операции, время, имя пользователя и поля строки drivers. Триггер driver_audit срабатывает AFTER INSERT OR UPDATE OR DELETE FOR EACH ROW и вызывает функцию process_driver_audit. Для DELETE в журнал берётся OLD, для INSERT и UPDATE — NEW. Функция возвращает NULL, как в листинге образца для триггера AFTER.")
    code(doc, (HERE / "triggers.sql").read_text(encoding="utf-8"))

    heading(doc, "2. Проверка")
    para(doc, "На PostgreSQL 15 после вставки, изменения страны и удаления пилота Charles Leclerc в журнале три строки с кодами I, U и D. Вставка спонсора с именем «Брудастый Орест Сергеевич» отклонена сообщением «спонсор не обслуживается». Спонсор Rolex вставлен. Команда DROP TRIGGER brud выполнена внутри транзакции и отменена ROLLBACK: оба триггера остались в базе.")

    heading(doc, "Рисунки")
    img = HERE / "img"
    names = [
        ("01_audit.png", "Журнал driver_audit после вставки, изменения и удаления пилота"),
        ("02_forbid.png", "Ошибка при вставке спонсора с фамилией Брудастый"),
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
        para(doc, "Рисунки из pgAdmin в отчёт ещё не вставлены. Их снимает студент и кладёт в каталог img под именами 01_audit.png и 02_forbid.png, после чего отчёт собирается заново.")

    heading(doc, "Вывод")
    para(doc, "В базе formula1 работают два триггера. Первый фиксирует любое добавление, изменение и удаление пилота. Второй не даёт добавить спонсора, чьё имя начинается с фамилии из образца пособия. Обойти триггер приложением нельзя: он выполняется в той же транзакции, что и оператор, который его вызвал.")

    doc.save(HERE / "report.docx")


if __name__ == "__main__":
    main()
