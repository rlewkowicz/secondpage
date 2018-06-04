FROM python:3-stretch

RUN git clone https://github.com/pika/pika.git && cd pika && git checkout e2f26db && python setup.py install

RUN pip install cassandra-driver bs4 metadata_parser requests uuid newspaper3k gensim python-dotenv timeout-decorator

COPY ./secondpage-pythonutils /secondpage-pythonutils

WORKDIR /secondpage-pythonutils
