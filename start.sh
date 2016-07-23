#!/bin/bash
set -e

usermod --uid $UID terraria
groupmod --gid $GID terraria

su - terraria -c /start_terraria

exec sudo -E -u terraria -c /start_terraria
