#use slim image to reduce image size
FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libgl1 \
    libglib2.0-0 && \
    #remove the apt cache to reduce image size
    rm -rf /var/lib/apt/lists/* 

RUN pip install --upgrade && pip install -r reduirements.txt

COPY . /app/
EXPOSE 8501
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
