FROM python:3-stretch

RUN pip install cassandra-driver bs4 metadata_parser pika requests uuid newspaper3k gensim python-dotenv timeout-decorator

COPY ./secondpage-pythonutils /secondpage-pythonutils

WORKDIR /secondpage-pythonutils
