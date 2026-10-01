.PHONY: help install install-dev lint format format-check test check run docker-build docker-up docker-down clean

help:
	@echo "Доступные команды:"
	@echo "  make install        — установить прод-зависимости"
	@echo "  make install-dev    — установить dev-зависимости"
	@echo "  make lint           — запустить ruff check"
	@echo "  make format         — отформатировать код ruff format"
	@echo "  make format-check   — проверить форматирование без изменений"
	@echo "  make test           — запустить тесты"
	@echo "  make check          — lint + format-check + test"
	@echo "  make run            — запустить приложение локально"
	@echo "  make docker-build   — собрать Docker-образ"
	@echo "  make docker-up      — запустить docker compose"
	@echo "  make docker-down    — остановить docker compose"
	@echo "  make clean          — удалить кэши и артефакты"

install:
	pip install -r requirements.txt

install-dev:
	pip install -r requirements-dev.txt
	pre-commit install

lint:
	ruff check .

format:
	ruff format .

format-check:
	ruff format --check .

test:
	pytest -v

check: lint format-check test

run:
	python main.py

docker-build:
	docker compose build

docker-up:
	docker compose up -d

docker-down:
	docker compose down

clean:
	rm -rf __pycache__ */__pycache__ .pytest_cache .ruff_cache .coverage htmlcov build dist *.egg-info
	find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true