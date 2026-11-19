.PHONY: install hooks format lint test check package repro compare serve up down build deploy clean

install:
	pip install -e ".[dev]"

# local quality checks before each commit (to run once after cloning)
hooks:
	pre-commit install

format:
	black . && ruff check --fix .

lint:
	black --check . && ruff check . && mypy src api

test:
	pytest -q --cov --cov-report=term-missing

# everything CI runs on a pull request
check:
	pre-commit run --all-files && $(MAKE) test

# build wheel + sdist into dist/
package:
	python -m build

repro:
	dvc repro

# le chiffre central du projet : ecart entre protocole aleatoire et split par scene
compare:
	dvc exp run -S split.protocol=random -n random-split
	dvc exp run -S split.protocol=scene  -n scene-split
	dvc exp show --only-changed

serve:
	uvicorn api.main:app --reload --port 8000

up:
	docker compose up -d

down:
	docker compose down

build:
	docker build -t planesnet-api:$$(git rev-parse --short HEAD) .

deploy:
	kubectl apply -k k8s/

clean:
	rm -rf artifacts/ dist/ .pytest_cache .ruff_cache .mypy_cache .coverage
