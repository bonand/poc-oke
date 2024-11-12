# Usa un'immagine base di Python
FROM python:3.9-slim

# Installa le dipendenze
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copia i file del microservizio
COPY microservice-workload-identity.py /app/microservice-workload-identity.py
WORKDIR /app

# Espone la porta
EXPOSE 5000

# Avvia il microservizio
CMD ["python", "microservice-workload-identity.py"]
