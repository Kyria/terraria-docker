#!/bin/bash

TMP_INI=/data/config/serverconfig_tmp.txt
FINAL_INI=/data/config/serverconfig.txt
BANLIST_INI=/data/config/banlist.txt

# if no banlist, create it
if [[ ! -e "$BANLIST_INI" ]]
then
    touch $BANLIST_INI
fi

# if no terraria config file has been given / already set, set values and move it
if [[ ! -e "$FINAL_INI" ]]
then
    # required as the game put _ in name...
    FIXED_WORLD_NAME=$(echo $WORLD_NAME | tr ' ' _ )

    sed -i "/world\s*=/ c world=/data/worlds/${FIXED_WORLD_NAME}.wld" $TMP_INI
    sed -i "/autocreate\s*=/ c autocreate=$WORLD_SIZE" $TMP_INI
    sed -i "/worldname\s*=/ c worldname=$WORLD_NAME" $TMP_INI
    sed -i "/difficulty\s*=/ c difficulty=$DIFFICULTY" $TMP_INI
    sed -i "/maxplayers\s*=/ c maxplayers=$MAXPLAYER" $TMP_INI
    sed -i "/motd\s*=/ c motd='$MOTD'" $TMP_INI
    sed -i "/password\s*=/ c password=$SERVER_PASSWORD" $TMP_INI
    sed -i "/lang\s*=/ c lang=$LANGUAGE" $TMP_INI

    mv -f $TMP_INI $FINAL_INI
fi

rm -f $TMP_INI

if [[ ! -e /opt/terraria/TerrariaServer.bin.${BIN_ARCHITECTURE} || ! -e /opt/terraria/version_${TERRARIA_BIN_VERSION} ]]
then
    wget ${TERRARIA_BIN_URL}${TERRARIA_BIN_NAME}${TERRARIA_BIN_VERSION}.zip
    unzip -o ${TERRARIA_BIN_NAME}${TERRARIA_BIN_VERSION}.zip "*/Linux/*" -d /opt/terraria/
    mv -f /opt/terraria/"Dedicated Server"/Linux/* /opt/terraria/
    rm -fR /opt/terraria/"Dedicated Server"
    rm -f ${TERRARIA_BIN_NAME}${TERRARIA_BIN_VERSION}.zip
    touch /opt/terraria/version_${TERRARIA_BIN_VERSION}
    chmod 755 *
fi

# start terraria !
chmod 755 /opt/terraria/TerrariaServer.bin.${BIN_ARCHITECTURE}
/opt/terraria/TerrariaServer.bin.${BIN_ARCHITECTURE} -config $FINAL_INI
