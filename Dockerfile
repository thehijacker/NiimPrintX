FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install system dependencies required for image processing and building
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
       build-essential \
       imagemagick \
       libmagickwand-dev \
       pkg-config \
       libcairo2-dev \
       libgirepository1.0-dev \
       libjpeg-dev \
       zlib1g-dev \
       libffi-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy only what's needed for install first to leverage Docker cache
COPY pyproject.toml pyproject.toml
COPY README.md README.md
COPY NiimPrintX NiimPrintX

# Install Python packages (uses PEP 517 via pyproject.toml)
RUN pip install --upgrade pip setuptools wheel && \
    pip install --no-cache-dir .

# Default CLI entrypoint
ENTRYPOINT ["python", "-m", "NiimPrintX.cli"]
CMD ["--help"]
