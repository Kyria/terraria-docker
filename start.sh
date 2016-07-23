#!/bin/bash
TMP_INI=/tmp/serverconfig.txt
FINAL_INI=/data/config/serverconfig.txt
BANLIST_INI=/data/config/banlist.txt

set -e

# force UID / GID of murmur user, in case we want it to match host values
# and no usermod available...
if [[ $GID != 1000 || $UID != 1000 ]]
then
    deluser terraria
    groupadd -g $GID terraria
    useradd -M -s /bin/false -u $GID -g terraria terraria
fi

# if no banlist, create it
if [[ ! -f "$BANLIST_INI" ]]
then
    echo "[INFO] Create $BANLIST_INI file"
    touch $BANLIST_INI
fi

# if no terraria config file has been given / already set, set values and move it
if [[ ! -f "$FINAL_INI" ]]
then
    # required as the game put _ in name...
    FIXED_WORLD_NAME=$(echo $WORLD_NAME | tr ' ' _ )

    echo "[INFO] Create $FINAL_INI file"
    sed -i "/world\s*=/ c world=\/data\/worlds\/$FIXED_WORLD_NAME" $TMP_INI
    sed -i "/autocreate\s*=/ c autocreate=$WORLD_SIZE" $TMP_INI
    sed -i "/worldname\s*=/ c worldname=$WORLD_NAME" $TMP_INI
    sed -i "/difficulty\s*=/ c difficulty=$DIFFICULTY" $TMP_INI
    sed -i "/maxplayers\s*=/ c maxplayers=$MAXPLAYER" $TMP_INI
    sed -i "/motd\s*=/ c motd='$MOTD'" $TMP_INI
    sed -i "/password\s*=/ c password=$SERVER_PASSWORD" $TMP_INI
    sed -i "/lang\s*=/ c lang=$LANGUAGE" $TMP_INI

    mv -f $TMP_INI $FINAL_INI
fi

if [[ ! -f /opt/terraria/TerrariaServer.bin.${BIN_ARCHITECTURE} || ! -f version_${TERRARIA_BIN_VERSION} ]]
then
    wget ${TERRARIA_BIN_URL}${TERRARIA_BIN_NAME}${TERRARIA_BIN_VERSION}.zip
    unzip -jo ${TERRARIA_BIN_NAME}${TERRARIA_BIN_VERSION}.zip "*/Linux/*" -d ./
    chmod 755 TerrariaServer.*
    rm -f ${TERRARIA_BIN_NAME}${TERRARIA_BIN_VERSION}.zip
    touch version_${TERRARIA_BIN_VERSION}
fi

# start terraria !
/opt/terraria/TerrariaServer.bin.${BIN_ARCHITECTURE} -config $FINAL_INI
