#!/bin/bash
set -e

usermod --uid $UID terraria
groupmod --gid $GID terraria

mv -f /tmp/serverconfig.txt /data/config/serverconfig_tmp.txt

chown -R terraria:terraria /opt/terraria/ /world/ /data/ /start_terraria
chmod -R 755 /opt/terraria/ /world/ /data/ /start_terraria

exec sudo -E -u terraria /start_terraria
