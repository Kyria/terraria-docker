#!/bin/bash
set -e

# force UID / GID of murmur user, in case we want it to match host values
# and no usermod available...
if [[ $GID != 1000 || $UID != 1000 ]]
then
    deluser terraria
    groupadd -g $GID terraria
    useradd -M -s /bin/false -u $GID -g terraria -d /opt/terraria terraria
fi

su - terraria -c /start_terraria
