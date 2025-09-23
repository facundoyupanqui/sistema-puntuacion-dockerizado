FROM python:3.10.18-slim-trixie

# Evitar .pyc y salida bufferizada
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Instalar dependencias del sistema necesarias para compilar mysqlclient y otras libs
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    default-libmysqlclient-dev \
    gcc \
    libssl-dev \
    pkg-config \
    netcat-openbsd \
  && rm -rf /var/lib/apt/lists/*

# Copiar requirements e instalarlas (cache-friendly)
COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r /app/requirements.txt

# Copiar el código de la app
COPY . /app

# Copiar entrypoint y darle permisos
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

EXPOSE 5001

# Entrypoint prepara DB y estáticos y luego arranca gunicorn
ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]

