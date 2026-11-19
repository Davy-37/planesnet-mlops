# Multi-stage : torch CPU uniquement, ~800 Mo au lieu de ~6 Go avec CUDA
FROM python:3.11-slim AS builder

WORKDIR /build
COPY pyproject.toml ./
COPY src/ src/
RUN pip install --no-cache-dir --prefix=/install \
      --extra-index-url https://download.pytorch.org/whl/cpu \
      ".[serving]"

FROM python:3.11-slim AS runtime

RUN useradd --create-home --uid 1000 app
WORKDIR /app

COPY --from=builder /install /usr/local
COPY src/ src/
COPY api/ api/

ENV PYTHONPATH=/app/src \
    MLFLOW_TRACKING_URI=http://mlflow:5000 \
    MODEL_URI=models:/planesnet@production

USER app
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD python -c "import urllib.request;urllib.request.urlopen('http://localhost:8000/healthz')"

CMD ["uvicorn", "api.main:app", "--host", "0.0.0.0", "--port", "8000"]
