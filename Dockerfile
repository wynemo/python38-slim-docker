FROM python:3.8-slim as base
WORKDIR /
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN sed -i 's/security.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt-get update

FROM base as dependency
RUN apt-get install -y g++ libssl-dev libffi-dev

FROM dependency as builder
RUN python -m venv venv

FROM base as release
COPY --from=builder /venv /venv
ENV PATH=/venv/bin:$PATH
