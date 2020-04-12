FROM openjdk:8-jdk-alpine
LABEL maintainer="Mirai Kim <me@euc-kr.net>"

ARG WORK_DIR="/srv/minecraft"
ARG VERSION="latest"
ENV DOCKER="TRUE"

RUN set -x \
    && apk add -U --no-cache bash curl openssl imagemagick rsync ca-certificates \
    && mkdir -p /srv/minecraft \
    && wget -O /tmp/paperclip.jar https://papermc.io/ci/job/Paper-1.15/lastSuccessfulBuild/artifact/paperclip.jar \
    && mv /tmp/paperclip.jar /srv/minecraft/server.jar \
    && rm -rf /var/cache/apk/*

COPY scripts/server.properties /tmp/server.properties.default
COPY scripts/start /srv/start
COPY scripts/initialize.sh /srv/initialize.sh
COPY scripts/run-minecraft.sh /srv/run-minecraft.sh

WORKDIR ${WORK_DIR}
EXPOSE 25565
EXPOSE 8080

CMD ["/srv/start"]
