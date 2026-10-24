# Flask Auth Application

![CI](https://img.shields.io/github/actions/workflow/status/msh04q/msh04q-flask-auth/ci.yml?branch=main)
![Python](https://img.shields.io/badge/python-3.12-blue)
![Code Style](https://img.shields.io/badge/code%20style-Ruff-black)
![Docker](https://img.shields.io/badge/containerized-Docker-2496ED?logo=docker)
![Infrastructure](https://img.shields.io/badge/IaC-Terraform%20%2B%20Ansible-7B42BC)

Веб-приложение аутентификации на Flask, созданное в результате рефакторинга учебного проекта. Проект демонстрирует применение современных практик Python-разработки, контейнеризации, автоматизированного тестирования, CI/CD и Infrastructure as Code (IaC).

## Содержание

- [Возможности](#возможности)
- [Технологический стек](#технологический-стек)
- [Архитектура проекта](#архитектура-проекта)
- [Локальный запуск](#локальный-запуск)
- [Разработка и тестирование](#разработка-и-тестирование)
- [Docker](#docker)
- [CI/CD](#cicd)
- [Инфраструктура как код](#инфраструктура-как-код)
- [Деплой приложения](#деплой-приложения)
- [Проверка работоспособности сервера](#проверка-работоспособности-сервера)
- [Безопасность](#безопасность)
- [Ограничения и планы развития](#ограничения-и-планы-развития)

## Возможности

- Регистрация и аутентификация пользователей.
- Работа с базой данных через SQLAlchemy.
- Конфигурация приложения через переменные окружения.
- Проверка состояния приложения через эндпоинт `/health`.
- Контейнеризация с помощью Docker и Docker Compose.
- Запуск приложения под непривилегированным пользователем.
- Production WSGI-сервер Gunicorn.
- Автоматизированные тесты с pytest.
- Проверка качества кода с Ruff.
- Pre-commit hooks для проверок перед коммитом.
- CI/CD на базе GitHub Actions.
- Публикация Docker-образа в GitHub Container Registry (GHCR).
- Создание и настройка VPS с помощью Terraform и Ansible.

## Технологический стек

| Категория | Технологии |
|---|---|
| Язык | Python 3.12 |
| Веб-фреймворк | Flask |
| Работа с БД | Flask-SQLAlchemy, SQLAlchemy |
| База данных | SQLite |
| WSGI-сервер | Gunicorn |
| Контейнеризация | Docker, Docker Compose |
| Тестирование | pytest, pytest-flask |
| Линтинг и форматирование | Ruff |
| Git hooks | pre-commit |
| CI/CD | GitHub Actions |
| Реестр образов | GitHub Container Registry |
| Инфраструктура | Terraform, Timeweb Cloud |
| Конфигурация сервера | Ansible |
| Межсетевой экран | UFW |

## Архитектура проекта

```text
msh04q-flask-auth/
├── .github/
│   └── workflows/
│       └── ci.yml                 # CI/CD pipeline
├── infra/
│   ├── terraform/                 # Создание VPS
│   │   ├── main.tf
│   │   └── variables.tf
│   └── ansible/                   # Настройка сервера
│       ├── inventory.ini.example  # Шаблон инвентаря
│       └── playbook.yml
├── static/                        # CSS и статические файлы
├── templates/                     # HTML-шаблоны Jinja2
├── tests/                         # Автоматизированные тесты
├── .dockerignore
├── .env.example                   # Пример конфигурации
├── .gitignore
├── .pre-commit-config.yaml
├── conftest.py
├── Dockerfile
├── docker-compose.yml
├── Makefile
├── main.py
├── pyproject.toml
├── requirements-dev.txt
├── requirements.txt
└── ruff.toml
```

Фактическая структура репозитория может отличаться от приведённой схемы. Файл `infra/ansible/inventory.ini` создаётся локально на основе шаблона `inventory.ini.example` и не коммитится в Git, так как содержит IP-адрес конкретного сервера.

## Локальный запуск

### Требования

- Git
- Python 3.12
- Docker Engine и Docker Compose — для запуска в контейнерах

### 1. Клонирование репозитория

```bash
git clone https://github.com/msh04q/msh04q-flask-auth.git
cd msh04q-flask-auth
```

### 2. Подготовка конфигурации

Создайте локальный файл окружения на основе шаблона:

```bash
cp .env.example .env
```

Откройте `.env` и задайте необходимые значения переменных окружения. Используйте уникальный секретный ключ и не добавляйте файл `.env` в Git.

### 3. Запуск через Docker Compose

Если в проекте настроены соответствующие цели Makefile:

```bash
make docker-up
```

Альтернативный вариант:

```bash
docker compose up --build -d
```

После запуска приложение должно быть доступно по адресу:

http://localhost:5000

Проверить состояние контейнеров:

```bash
docker compose ps
```

Посмотреть логи:

```bash
docker compose logs --tail=100 web
```

Остановить приложение:

```bash
docker compose down
```

Данные SQLite хранятся в настроенном Docker Volume, чтобы сохраняться при пересоздании контейнера.

## Разработка и тестирование

### Установка зависимостей

Создайте виртуальное окружение:

```bash
python3.12 -m venv .venv
source .venv/bin/activate
```

Установите зависимости:

```bash
pip install -r requirements.txt
pip install -r requirements-dev.txt
```

Если команда `make install-dev` настроена в Makefile, можно использовать её вместо ручной установки зависимостей разработки и pre-commit hooks.

### Запуск приложения

```bash
make run
```

### Тестирование

```bash
pytest
```

### Проверка кода

```bash
ruff check .
ruff format --check .
```

Автоматическое исправление замечаний Ruff:

```bash
ruff check --fix .
ruff format .
```

### Makefile

Посмотреть доступные команды:

```bash
make help
```

| Команда | Назначение |
|---|---|
| `make install-dev` | Установка зависимостей разработки |
| `make run` | Запуск приложения |
| `make test` | Запуск тестов |
| `make lint` | Проверка кода Ruff |
| `make format` | Форматирование кода |
| `make docker-up` | Запуск Docker Compose |
| `make docker-down` | Остановка Docker Compose |
| `make clean` | Очистка временных файлов |

## Docker

Проект использует Docker для воспроизводимого запуска приложения.

Основные компоненты конфигурации:

- `Dockerfile` — сборка образа приложения.
- `docker-compose.yml` — описание сервисов и настроек запуска.
- `.dockerignore` — исключение ненужных файлов из контекста сборки.
- Docker Volume — постоянное хранение данных SQLite.
- Пользователь `app` — запуск процесса приложения без root-привилегий.
- Gunicorn — обработка HTTP-запросов в production-режиме.
- `HEALTHCHECK` — проверка состояния приложения.

Сборка и запуск:

```bash
docker compose up --build -d
```

Проверка контейнеров:

```bash
docker compose ps
```

Просмотр логов:

```bash
docker compose logs -f web
```

## CI/CD

Автоматизация сборки и развёртывания выполняется через GitHub Actions. Конфигурация находится в `.github/workflows/ci.yml`.

Пайплайн состоит из трёх job'ов:

1. **Lint and test** — проверка кода с помощью `ruff check`, `ruff format --check` и запуск `pytest`.
2. **Build and push** — сборка Docker-образа и публикация в GitHub Container Registry при push в `main`.
3. **Deploy** — копирование `docker-compose.yml` на VPS через `scp` и перезапуск приложения по SSH (`docker compose pull && docker compose up -d`).

Образ доступен в реестре:

```text
ghcr.io/msh04q/flask-auth:latest
```

### GitHub Secrets

Для автоматического деплоя используются следующие секреты репозитория:

| Secret | Назначение |
|---|---|
| `VPS_HOST` | IP-адрес сервера |
| `VPS_USER` | Пользователь для SSH-подключения (`deployer`) |
| `VPS_SSH_KEY` | Приватный SSH-ключ |
| `VPS_PORT` | SSH-порт, обычно `22` |

Добавляйте секреты через **GitHub → Settings → Secrets and variables → Actions**.

Не храните приватные ключи, токены и пароли непосредственно в исходном коде или README.

## Инфраструктура как код

Для управления инфраструктурой используются Terraform и Ansible.

### Terraform

Terraform создаёт инфраструктуру в Timeweb Cloud: VPS в зоне `ams-1` (Амстердам), SSH-ключ и плавающий IP (`twc_floating_ip`). Конфигурация находится в `infra/terraform/`.

Основные команды:

```bash
cd infra/terraform
terraform init
terraform validate
```

Токен Timeweb передаётся через переменную окружения `TF_VAR_twc_token` или через `-var`:

```bash
export TF_VAR_twc_token="ВАШ_ТОКЕН_TIMEWEB"
terraform plan
terraform apply
```

Либо одной командой:

```bash
terraform apply -var="twc_token=ВАШ_ТОКЕН_TIMEWEB"
```

После создания инфраструктуры получите публичный IP-адрес из выходных значений Terraform (`server_ip`) и настройте Ansible inventory.

**Важно:** не публикуйте токены и файлы состояния Terraform (`*.tfstate`). Для рабочего окружения рекомендуется настроить защищённое удалённое хранилище состояния (например, S3 или Terraform Cloud).

### Ansible

Ansible используется для конфигурирования сервера после создания VPS.

Задачи, которые выполняет playbook:

- установка Docker и Docker Compose;
- настройка UFW (разрешены порты 22 и 80, входящие по умолчанию запрещены);
- создание пользователя `deployer`;
- добавление SSH-ключа для `deployer`;
- настройка `NOPASSWD sudo` для `deployer`;
- добавление `deployer` в группу `docker`;
- отключение прямого SSH-входа для `root`;
- создание каталога `/opt/flask-auth` с владельцем `deployer`;
- подготовка каталога named volume с правами `1000:1000`, чтобы контейнер мог писать в SQLite.

Перед запуском скопируйте шаблон инвентаря и укажите IP-адрес сервера:

```bash
cd infra/ansible
cp inventory.ini.example inventory.ini
# отредактируйте inventory.ini, указав IP и путь к приватному ключу
ansible-playbook -i inventory.ini playbook.yml
```

### Удаление инфраструктуры

Если сервер был создан Terraform и его необходимо удалить:

```bash
cd infra/terraform
terraform plan -destroy -var="twc_token=ВАШ_ТОКЕН_TIMEWEB"
terraform destroy -var="twc_token=ВАШ_ТОКЕН_TIMEWEB"
```

Удаление инфраструктуры может привести к потере данных. Перед подтверждением убедитесь, что нужные данные сохранены.

## Деплой приложения

Деплой выполняется автоматически после push в ветку `main`.

Типовой процесс:

1. Внести изменения в код.
2. Проверить тесты и качество кода локально.
3. Создать коммит.
4. Отправить изменения в GitHub.
5. Проверить выполнение workflow в разделе **Actions**.
6. Убедиться, что новый контейнер запущен и приложение отвечает.

Пример:

```bash
git add .
git commit -m "feat: improve application"
git push origin main
```

Статус CI/CD:

https://github.com/msh04q/msh04q-flask-auth/actions

Если деплой не запускается, проверьте триггеры workflow, имена GitHub Secrets, права доступа к GHCR и SSH-доступ к серверу.

**Первый деплой:** перед первым запуском пайплайна на сервере должен существовать файл `/opt/flask-auth/.env` с переменными окружения (`SECRET_KEY`, `DATABASE_URL`). Он не попадает в Git и создаётся вручную после настройки сервера через Ansible.

## Проверка работоспособности сервера

Для приведённых ниже команд используется тестовый VPS:

```text
129.101.xxx.xx
```

Путь к Compose-файлу и имя сервиса должны соответствовать реальной конфигурации сервера.

### 1. Состояние контейнера

```bash
ssh -i ~/.ssh/flask_auth_deploy deployer@129.101.xxx.xx \
  "docker compose -f /opt/flask-auth/docker-compose.yml ps"
```

Проверьте, что контейнер запущен. Если настроен Docker Healthcheck, его состояние должно быть `healthy`.

### 2. Проверка health endpoint

```bash
curl -i http://129.101.xxx.xx:5000/health
```

Ожидаемый результат при успешной проверке:

- HTTP-статус `200 OK`;
- JSON-ответ `{"status":"ok"}`.

### 3. Проверка главной страницы

```bash
curl -I http://129.101.xxx.xx:5000/
```

Ожидается HTTP-статус `200 OK`.

### 4. Проверка прав на каталог базы данных

Каталог `/var/lib/docker/volumes/` принадлежит `root`, поэтому смотреть его с хоста под `deployer` не получится. Проверяйте состояние базы **изнутри контейнера**:

```bash
ssh -i ~/.ssh/flask_auth_deploy deployer@129.101.xxx.xx \
  "docker compose -f /opt/flask-auth/docker-compose.yml exec web ls -la /app/instance"
```

Если приложение работает под пользователем с UID/GID `1000:1000`, файл базы (например, `users.db`) должен принадлежать `app:app`. Наличие файла и его размер больше нуля означают, что права на volume настроены корректно.

### 5. Проверка логов

```bash
ssh -i ~/.ssh/flask_auth_deploy deployer@129.101.124.32 \
  "docker compose -f /opt/flask-auth/docker-compose.yml logs --tail=50 web"
```

Проверьте отсутствие ошибок запуска, подключения к базе данных и записи файлов. Отдельные сообщения `WORKER TIMEOUT` от Gunicorn могут появляться при медленных клиентах — это не ошибка приложения, воркер автоматически перезапускается.

### 6. Ручная проверка регистрации

После проверки сервера можно открыть:

http://129.101.xxx.xx:5000

Используйте только тестовые данные. Поскольку демонстрационный адрес работает по HTTP без HTTPS, не вводите реальные пароли и другие конфиденциальные данные.

## Безопасность

В проекте применяются следующие подходы:

- конфигурация через переменные окружения;
- исключение секретов из Git (`.env`, `*.tfstate`, `inventory.ini`);
- запуск приложения от непривилегированного пользователя;
- изоляция приложения в Docker-контейнере;
- отключение прямого SSH-входа для `root`;
- настройка UFW с политикой `deny incoming` по умолчанию;
- автоматизированные проверки качества кода и тесты;
- сохранение данных в постоянном томе Docker.

### Рекомендации для production

Перед использованием приложения с реальными пользователями рекомендуется:

- настроить HTTPS через Nginx, Traefik или другой reverse proxy;
- ограничить внешний доступ к порту приложения и оставить публичными только необходимые порты;
- использовать надёжный случайный `SECRET_KEY`;
- проверить защиту паролей, сессий, форм и механизмов аутентификации;
- ограничить доступ к SSH и GitHub Secrets;
- регулярно обновлять системные пакеты и зависимости;
- настроить резервное копирование базы данных;
- не считать членство в группе `docker` безопасным эквивалентом обычных пользовательских прав: такая группа фактически предоставляет широкие привилегии на хосте;
- не использовать SQLite для нескольких параллельных экземпляров приложения без отдельного решения для общей базы данных.

## Ограничения и планы развития

Текущая реализация предназначена прежде всего для демонстрации практик разработки и развёртывания.

Возможные направления развития:

- **HTTPS и reverse proxy** — безопасный доступ к приложению.
- **PostgreSQL** — более подходящая база данных для дальнейшего масштабирования.
- **Мониторинг** — метрики приложения и инфраструктуры, Prometheus и Grafana.
- **Логирование** — централизованный сбор и анализ логов.
- **Резервное копирование** — автоматическое сохранение базы данных.
- **Управление секретами** — более безопасное хранение конфигурации production-окружения.
- **Расширение тестов** — интеграционные проверки и тесты сценариев аутентификации.

Мониторинг Prometheus и Grafana не следует считать реализованным, пока соответствующие сервисы и сбор метрик фактически не настроены.

---

## Автор

GitHub: [@msh04q](https://github.com/msh04q)

Репозиторий: [msh04q-flask-auth](https://github.com/msh04q/msh04q-flask-auth)