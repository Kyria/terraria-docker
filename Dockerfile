FROM mono:latest

COPY start.sh /start
COPY serverconfig.txt /tmp/serverconfig.txt

RUN apt-get -qq update && apt-get install -qqy zip \
    && groupadd -g 1000 terraria \
    && useradd -MD -s /bin/false -u 1000 -g terraria terraria \
    && mkdir -p \
        /opt/terraria/ \
        /world/ \
        /var/log/terraria \
        /data/ \
    && chmod 755 /start

EXPOSE 7777

VOLUME ["/opt/terraria/", "/var/log/terraria", "/data/worlds", "/data/config"]

WORKDIR /opt/terraria

ENTRYPOINT ["/start"]

ENV UID=1000 GID=1000 \
    TERRARIA_BIN_VERSION=1321 \
    TERRARIA_BIN_URL=http://terraria.org/server/ \
    TERRARIA_BIN_NAME=terraria-server- \
    BIN_ARCHITECTURE=x86_64 \
    LANGUAGE=1 \
    WORLDNAME=terraria \
    DIFFICULTY=1 \
    MAXPLAYER=8 \
    SERVER_PASSWORD= \
    MOTD="Please don<92>t cut the purple trees!" \
    WORLD_SIZE=3

