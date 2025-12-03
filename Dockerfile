# -----------------------------
# Stage 1: Builder
# -----------------------------
FROM python:3.11-slim AS builder

# Set working directory
WORKDIR /app

# Copy only requirements.txt first to leverage Docker cache
COPY requirements.txt .

# Install dependencies into /install to separate build from runtime
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Copy application code
COPY . .

# -----------------------------
# Stage 2: Runtime
# -----------------------------
FROM gcr.io/distroless/python3:nonroot

WORKDIR /app

COPY --from=builder /install /usr/local
COPY --from=builder /app /app

CMD ["day02.py"]