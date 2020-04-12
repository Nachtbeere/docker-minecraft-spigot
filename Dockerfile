FROM openjdk:8-jdk-alpine
LABEL maintainer="Mirai Kim <me@euc-kr.net>"

ARG WORK_DIR="/srv/minecraft"
ARG VERSION="latest"
ENV DOCKER="TRUE"

WORKDIR "/tmp"

RUN set -x \
    && apk add -U --no-cache bash openrc curl openssl imagemagick rsync ca-certificates tmux \
    && apk add --virtual .build-deps wget git \
    && wget -O BuildTools.jar https://hub.spigotmc.org/jenkins/job/BuildTools/lastStableBuild/artifact/target/BuildTools.jar \
    && java -Xmx1024M -jar BuildTools.jar --rev ${VERSION} \
    && mkdir -p /srv/minecraft \
    && cd . \
    && for file in $(find . -maxdepth 1 -type f); do case "${file}" in *spigot*) mv "${file}" /srv/minecraft/server.jar;; esac; done \
    && apk del --purge .build-deps \
	&& rm -rf /var/cache/apk/* \
	&& rm -rf /tmp/*

COPY scripts/server.properties /tmp/server.properties.default
COPY scripts/start /srv/start
COPY scripts/initialize.sh /srv/initialize.sh
COPY scripts/run-minecraft.sh /srv/run-minecraft.sh

WORKDIR ${WORK_DIR}
EXPOSE 25565
EXPOSE 8080

CMD ["/srv/start"]
