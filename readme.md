# Flask Auth Application (Production-Ready Refactoring)

![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/msh04q/msh04q-flask-auth/ci.yml?branch=main)
![Python Version](https://img.shields.io/badge/python-3.12-blue)
![Code Style: Ruff](https://img.shields.io/badge/code%20style-ruff-000000.svg)

Веб-приложение аутентификации на Flask, созданное путем глубокого рефакторинга учебного проекта с внедрением современных стандартов разработки (Production Ready Best Practices), контейнеризации и CI/CD процессов.

---

## 🛠 Ключевые изменения и улучшения

- **Безопасность и конфигурация:**
  - Убраны жестко зашитые ключи (`SECRET_KEY`, `SQLALCHEMY_DATABASE_URI`). Конфигурация полностью переведена на переменные окружения (`python-dotenv` / `.env`).
  - Исправлены баги и оптимизирована работа с ORM: переход на безопасный `db.session.get()`, инициализация БД в контексте приложения (`app_context()`).
- **Контейнеризация и оркестрация:**
  - Написан multi-stage `Dockerfile` на базе `python:3.12-slim`.
  - Реализован запуск под не-root пользователем (`app`) для безопасности.
  - Настроен `HEALTHCHECK` с проверкой эндпоинта `/health`.
  - Настроен Production WSGI-сервер `Gunicorn` (3 воркера, асинхронное логирование).
  - Создан `docker-compose.yml` с сохранением данных через Docker Volume для SQLite.
- **Инфраструктура качества кода (QA / DevOps):**
  - **Makefile:** Автоматизированы основные команды для сборки, тестирования и запуска проекта.
  - **Линтинг и форматирование:** Интегрирован быстрый линтер/форматтер `Ruff` с набором правил `E, W, F, I, B, UP`.
  - **Pre-commit hooks:** Автоматическая проверка и исправление форматирования кода перед каждым коммитом.
  - **Тестирование:** Написаны тесты на `pytest` и `pytest-flask` (включая проверку `/health`).
  - **CI/CD:** Настроен пайплайн GitHub Actions (`.github/workflows/ci.yml`) для автоматической проверки линтерами и запуска тестов на каждый Push / PR.

---

## 📂 Структура проекта

```text
msh04q-flask-auth/
├── .github/workflows/ci.yml   # CI/CD пайплайн (Ruff + Pytest)
├── static/                     # Статические файлы (CSS)
├── templates/                  # Jinja2 шаблоны
├── tests/                      # Pytest модульные и интеграционные тесты
├── .dockerignore
├── .env.example                # Шаблон переменных окружения
├── .pre-commit-config.yaml     # Pre-commit конфигурация
├── conftest.py                 # Pytest фикстуры и настройка sys.path
├── Dockerfile                  # Production Docker image
├── docker-compose.yml          # Локальный запуск и оркестрация
├── Makefile                    # Команды автоматизации
├── main.py                     # Основное приложение Flask
├── pyproject.toml              # Метаданные и настройки инструментов
├── requirements-dev.txt        # Зависимости для разработки
├── requirements.txt            # Production зависимости
└── ruff.toml                   # Конфигурация Ruff
```

---

## ⚡ Использование Makefile

Для удобства управления проектом предусмотрен `Makefile`. Чтобы увидеть все доступные команды, выполните:

```bash
make help
```

### Основные команды:

| Команда | Описание |
| :--- | :--- |
| `make install-dev` | Создает `venv`, устанавливает зависимости для разработки и хуки `pre-commit` |
| `make run` | Запускает локальный сервер разработки |
| `make test` | Запускает тесты через `pytest` |
| `make lint` | Проверяет код с помощью `Ruff` |
| `make format` | Автоматически форматирует код через `Ruff` |
| `make docker-up` | Запускает проект в контейнерах через `docker-compose` |
| `make docker-down` | Останавливает контейнеры `docker-compose` |
| `make clean` | Удаляет кэш, временные файлы и виртуальное окружение |

---

## 🚀 Быстрый запуск

1. **Клонируйте репозиторий и подготовьте окружение:**
   ```bash
   git clone https://github.com/msh04q/msh04q-flask-auth.git
   cd msh04q-flask-auth
   cp .env.example .env
   ```

2. **Запуск через Docker Compose (Рекомендуется):**
   ```bash
   make docker-up
   ```
   Приложение будет доступно по адресу `http://localhost:5000`.

3. **Запуск локально (для разработки):**
   ```bash
   make install-dev
   make run
   ```