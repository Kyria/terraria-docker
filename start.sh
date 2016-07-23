#!/bin/sh
TMP_INI=/tmp/serverconfig.txt
FINAL_INI=/data/config/serverconfig.txt
BANLIST_INI=/data/config/banlist.txt

set -e

function setServerProp {
  local prop=$1
  local var=$2
  if [ -n "$var" ]; then
    echo "Setting $prop to $var"
    sed -i "/$prop\s*=/ c $prop=$var" $TMP_INI
  fi
}

# force UID / GID of murmur user, in case we want it to match host values
# and no usermod available...
if [[ $GID != 1000 || $UID != 1000 ]]
then
    deluser terraria
    addgroup -g $GID terraria
    adduser -DS -s /bin/false -u $UID -G terraria terraria
fi

# if no banlist, create it
if [[ ! -f "$BANLIST_INI" ]]
then
    echo "[INFO] Create $BANLIST_INI file"
    touch $BANLIST_INI
fi

# if no murmur ini has been given / already set, set values and move it
if [[ ! -f "$FINAL_INI" ]]
then
    # required as the game put _ in name...
    FIXED_WORLD_NAME=$(echo $WORLD_NAME | tr ' ' _ )

    echo "[INFO] Create $FINAL_INI file"
    setServerProp "world" "/data/worlds/$FIXED_WORLD_NAME"
    setServerProp "autocreate" "$WORLD_SIZE"
    setServerProp "worldname" "$WORLD_NAME"
    setServerProp "difficulty" "$DIFFICULTY"
    setServerProp "maxplayers" "$MAXPLAYER"
    setServerProp "motd" "'$MOTD'"
    setServerProp "password" "'$SERVER_PASSWORD'"
    setServerProp "lang" "$LANGUAGE"

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
