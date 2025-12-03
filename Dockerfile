# Stage 1: Build
FROM python:3.11-slim AS builder
WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

COPY . .

# Stage 2: Runtime
FROM python:3.11-slim
WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /install /usr/local
COPY --from=builder /app /app

EXPOSE 8000

ENTRYPOINT ["python"]
CMD ["day02.py"]