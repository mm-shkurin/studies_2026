<!-- source: https://wiki.pmifi.ru/disciplines/nlp -->
<!-- updated: 2026-11-06T05:01:48.386Z -->
<!-- author: Михаил Гуненков -->

# Обработка естественного языка

> Для просмотра материалов прошлых лет используйте `/nlp/<год>`

## Организация

> [Рейтинг по дисциплине](https://docs.google.com/spreadsheets/d/1RDv2rfL3d2Cqw76HGVT7shMQTFFDnmvJj7z8pZsPpUc/edit?usp=sharing) (действует кросс-проверка между Гуненковым М. Ю. и Бугаенко И. Е.)

> [Расписание консультаций Михаила Юрьевича Гуненкова](https://docs.google.com/document/d/12YgoDntaXiODlG3ZKIP9fA8L78O0SqXW/edit?usp=sharing)

> Расписание консультаций Ивана Евгеньевича Бугаенко (скоро)

## Лекционные материалы

### Введение

- [Предварительная обработка текстовых данных](disciplines__nlp__lectures__preprocessing.md)
- [Векторные представления текстовых данных](disciplines__nlp__lectures__vectorization.md)

### Обработка последовательностей

- [Знакомство с рекуррентными нейронными сетями. Архитектуры LSTM и GRU](disciplines__nlp__lectures__rnn-2.md)
- [Архитектура Encoder-Decoder. Задача машинного перевода](disciplines__nlp__lectures__nmt-2.md)

### Трансформеры и альтернативные подходы

- [Архитектура Transformer. Attention is all you need](disciplines__nlp__lectures__transformer-2.md)
- [Transfer Learning Трансформеров (BERT, GPT)](disciplines__nlp__lectures__bert-gpt-2.md)
- [Решение прикладных задач NLP](disciplines__nlp__lectures__problem-solving.md)
- [Модели пространства состояний (SSM, Mamba)](disciplines__nlp__lectures__ssm.md)
- [Продвинутые архитектуры рекуррентных нейронных сетей (xLSTM)](disciplines__nlp__lectures__xlstm.md)

### Большие языковые модели и AI-агенты

- [Основы LLM и RAG](disciplines__nlp__lectures__llms.md)
- [Обучение и механизм рассуждений в LLM](disciplines__nlp__lectures__training-reasoning.md)

## Лабораторные работы (60 баллов)

| № | Материалы ЛР | Баллы |
| --- | --- | --- |
| 1 | [Python и введение NLP. Полносвязная нейронная сеть. Реализация Word2Vec](disciplines__nlp__laboratory-works__torch-w2v.md) | **12 баллов** |
| 2 | [Классификация текстов с применением RNN](disciplines__nlp__laboratory-works__rnn.md) | **12 баллов** |
| 3 | [Архитектура Трансформер. Обучение генеративного трансформера (GPT)](disciplines__nlp__laboratory-works__gpt.md) | **12 баллов** |
| 4 | Решение прикладных задач NLP: суммаризация документов и вопросно-ответные системы | **12 баллов** |
| 5 | Тонкая настройка больших языковых моделей с применением LoRA | **12 баллов** |

## Практические задачи (20 баллов, 5 баллов за задачу)

- [Парсинг текстовых документов с использованием параллельных технологий](disciplines__nlp__laboratory-works__hh.md)
- [Реализация внимания в классической RNN](disciplines__nlp__laboratory-works__attention.md)
- Оптимизация весов больших языковых моделей (дистилляция и квантование)
- [Тематическое моделирование средствами sklearn и gensim](disciplines__nlp__laboratory-works__gensim-sklearn-topic-modeling.md)

## Домашнее задание (20 баллов)

> Обязательно для зачёта на любую оценку

> [Текст домашнего задания](disciplines__nlp__hometasks__agent-harness.md)

## Преподаватели

- Михаил Юрьевич Гуненков
- Иван Евгеньевич Бугаенко
