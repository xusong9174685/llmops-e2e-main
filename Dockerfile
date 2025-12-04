# -----------------------------
# Stage 1: Builder
# -----------------------------
FROM python:3.11-slim AS builder

WORKDIR /app

# Copy requirements.txt first
COPY requirements.txt .

# Install dependencies into standard site-packages (no --prefix)
RUN pip install --no-cache-dir torch==2.2.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY . .

# -----------------------------
# Stage 2: Runtime
# -----------------------------
FROM python:3.11-slim

WORKDIR /app

# Copy installed packages from builder
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /app /app

# Run app
CMD ["python", "day02.py"]