FROM python:3.11-alpine

WORKDIR /app

RUN apk add --no-cache postgresql-client bash gcc musl-dev postgresql-dev

COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

COPY . /app

ENV FLASK_DEBUG=0
ENV FLASK_ENV=production
ENV FLASK_APP=main.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=8000

EXPOSE ${FLASK_RUN_PORT}

CMD ["flask", "run"]