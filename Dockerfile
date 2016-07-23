FROM mono:latest

COPY start.sh /start
COPY serverconfig.txt /tmp/serverconfig.txt

RUN apt-get install -y zip \
    && addgroup -g 1000 terraria \
    && adduser -DS -s /bin/false -u 1000 -G terraria terraria \
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
    TERRARIA_BIN_VERSION=1321 \ #1.3.2.1
    TERRARIA_BIN_URL=http://terraria.org/server/ \
    TERRARIA_BIN_NAME=terraria-server- \
    BIN_ARCHITECTURE=x86_64 \
    LANGUAGE=1 \ # 1:English, 2:German, 3:Italian, 4:French, 5:Spanish
    WORLDNAME=terraria
    DIFFICULTY=1 \ #1: expert, 0:normal
    MAXPLAYER=8
    SERVER_PASSWORD=
    MOTD=Please don<92>t cut the purple trees!
    WORLD_SIZE=3 \ # 1(small), 2(medium), and 3(large)

