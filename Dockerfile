FROM python:3-slim

MAINTAINER Sebastien LANGOUREAUX <linuxworkgroup@hotmail.com>

ARG http_proxy
ARG https_proxy

ENV \
    ECS_VERSION=v1.12.1


# Install package needed by ecs
RUN \
    apt-get update &&\
    apt-get install -y --no-install-recommends git make golang-go &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
    pip install virtualenv

# Create regular user
RUN \
    addgroup --gid 1000 user && \
    useradd -c "User" -m -g user -s /bin/sh -u 1000 user &&\
    mkdir /code &&\
    chown -R user:user /code

USER user
    
RUN \
    cd /code &&\
    git clone https://github.com/elastic/ecs.git -b ${ECS_VERSION} &&\
    cd ecs &&\
    make setup &&\
    make generator
    
WORKDIR "/code/ecs"