FROM python:3.8-slim as base
WORKDIR /
#RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
#RUN sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y g++ libssl-dev libffi-dev

RUN python -m venv venv
