#use slim image to reduce image size
FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libgl1 \
    libglib2.0-0 && \
    #remove the apt cache to reduce image size
    rm -rf /var/lib/apt/lists/* 

COPY . /app/
RUN pip install --upgrade pip && pip install -r requirements.txt &&  pip install --no-cache-dir -r requirements.txt


EXPOSE 8501
CMD ["streamlit", "run", "my_app.py", "--server.port=8501", "--server.address=0.0.0.0"]
