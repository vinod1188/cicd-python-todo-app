FROM python:3.9-slim

RUN pip install django==3.2

RUN pip install --upgrade pip

WORKDIR /app
COPY requirements.txt /app/
COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

RUN python manage.py migrate
EXPOSE 8000
CMD ["python","manage.py","runserver","0.0.0.0:8000"]


