.PHONY: help install install-dev lint format test docker-build docker-up docker-down clean

# Цвета для вывода в терминал
CYAN  := \033[0;36m
RESET := \033[0m

help: ## Показать справку по командам
	@echo "$(CYAN)Доступные команды:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Установить основные зависимости приложения
	pip install -r requirements.txt

install-dev: ## Установить зависимости для разработки и настроить pre-commit
	pip install -r requirements-dev.txt
	pre-commit install

lint: ## Проверить код линтером Ruff
	ruff check .

format: ## Автоматически отформатировать код с помощью Ruff
	ruff check --fix .
	ruff format .

test: ## Запустить тесты Pytest
	pytest -v

docker-build: ## Собрать Docker-образ
	docker build -t flask-auth:local .

docker-up: ## Запустить сервис в Docker Compose
	docker compose up -d --build

docker-down: ## Остановить и удалить Docker-контейнеры
	docker compose down

clean: ## Очистить кэш Python и тестовые артефакты
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete
	rm -rf .pytest_cache .ruff_cache instance/*.db