# -----------------------------
# Stage 1: Builder
# -----------------------------
FROM python:3.11-slim AS builder

WORKDIR /app

# Upgrade pip first
RUN pip install --upgrade pip

# Copy requirements first for caching
COPY requirements.txt .

# Install PyTorch CPU 2.6.0 and app dependencies
RUN pip install --no-cache-dir torch==2.6.0 -f https://download.pytorch.org/whl/torch_stable.html \
    && pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# -----------------------------
# Stage 2: Runtime
# -----------------------------
FROM python:3.11-slim

WORKDIR /app

# Copy installed packages + binaries (important!)
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /usr/local/bin /usr/local/bin

# Copy app code
COPY --from=builder /app /app

# Expose port for FastAPI
EXPOSE 8000

# Start API
CMD ["uvicorn", "day02:app", "--host", "0.0.0.0", "--port", "8000"]