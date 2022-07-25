FROM postgres:latest

RUN apt-get update

ADD db_export.exe /bin/db_export.exe

VOLUME /dump
WORKDIR /dump

CMD ../bin/db_export.exe
