FROM ubuntu:19.10

RUN apt-get -qq update && apt-get install -qqy \
        zip \
        wget \
        libc6 \
        sudo \
    && apt-get clean \
    && groupadd -g 1000 terraria \
    && useradd -M -s /bin/false -u 1000 -g terraria -d /terraria terraria \
    && mkdir -p \
        /terraria/ \
        /data/worlds \
        /data/config \
    && chmod -R 755 /terraria /data \
    && chown -R terraria:terraria /terraria /data

EXPOSE 7777

COPY bin/* /usr/local/bin
RUN chmod a+x /usr/local/bin/*

# https://terraria.gamepedia.com/Server#Downloads for version
#English = en-US, German = de-DE, Italian = it-IT, French = fr-FR, Spanish = es-ES, Russian = ru-RU, Chinese = zh-Hans, Portuguese = pt-BR, Polish = pl-PL,

ENV TERRARIA_BIN_VERSION=1353 \
    TERRARIA_BIN_URL=http://terraria.org/server/ \
    TERRARIA_BIN_NAME=terraria-server- \
    BIN_ARCHITECTURE=x86_64 \
    LANGUAGE="en-US" \
    WORLD_NAME=terraria \
    DIFFICULTY=1 \
    MAXPLAYER=8 \
    SERVER_PASSWORD= \
    MOTD="Please don<92>t cut the purple trees!" \
    WORLD_SIZE=1 \
    WORLD_SEED=

WORKDIR /terraria
USER terraria:terraria
CMD ["start_terraria"]