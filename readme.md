in dockerfile:

```
FROM wynemo/python38:latest as builder
COPY ./pip_cache/* /pip_cache/
COPY ./requirements/prod.txt /requirements/
RUN venv/bin/pip wheel --wheel-dir=/pip_cache -i https://mirrors.aliyun.com/pypi/simple/ --find-links=/pip_cache pip wheel setuptools
RUN venv/bin/pip install --upgrade --no-index --find-links=/pip_cache pip wheel setuptools
RUN venv/bin/pip wheel --wheel-dir=/pip_cache -i https://mirrors.aliyun.com/pypi/simple/ --find-links=/pip_cache -r /requirements/prod.txt
RUN venv/bin/pip install --no-index --find-links=/pip_cache -r /requirements/prod.txt

FROM alpine:latest as pip
COPY --from=builder /pip_cache /pip_cache

FROM wynemo/python38:release as release
ARG user=user
ARG uid=1001
ARG gid=1001
WORKDIR /app
COPY --from=builder /venv /venv
RUN groupadd -g ${gid} $user
RUN useradd -u ${uid} -g ${gid} $user
RUN chown -R ${user}:${user} /sonarx
# Tell docker that all future commands should run as the appuser user
USER ${user}
ENV PATH=/venv/bin:$PATH

```

in build (to reuse pip cache):
```
sudo docker build --target pip --build-arg http_proxy=${http_proxy} --build-arg https_proxy=${https_proxy} -f ./docker/Dockerfile . -t  app_pip
sudo docker build \
  --build-arg http_proxy=${http_proxy} \
  --build-arg https_proxy=${https_proxy} \
  --build-arg user=user \
  --build-arg uid=$(id -u user) \
  --build-arg gid=$(id -g user) \
  -f ./docker/Dockerfile . -t  $MAINIMAGE
sudo docker run --rm --name pip_copyer -v $PWD/pip_cache:/tmp/pip_cache app_pip sh -c 'cp /pip_cache/* /tmp/pip_cache/'

```
