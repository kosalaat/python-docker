FROM python:alpine as build

RUN apk upgrade --no-cache 

RUN apk add --no-cache tini gcc musl-dev python3-dev libffi-dev openssl-dev cargo busybox-suid

WORKDIR /source 

RUN adduser -S python --uid 1000 && addgroup -S python --gid 1000

RUN python3 -m venv /source/venv

RUN . /source/venv/bin/activate && python3 -m ensurepip --upgrade && python3 -m pip install simple_salesforce

RUN chown -R python:python /source

USER python:python

# Build the final image
FROM python:alpine as final

RUN apk upgrade --no-cache 

RUN adduser -S python --uid 1000 && addgroup -S python --gid 1000

WORKDIR /source 

RUN chown python:python /source

USER python:python

COPY --from=build --chown=python:python  /source /source

