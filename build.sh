#!/bin/bash
# since I'm not interested in using or learning github actions and its syntax, I translated the zmk build actions into a local script using the steps from the github actions pipeline
# run this script inside docker build container using:
# docker run -v ./:/app --name zmk-builder -it zmkfirmware/zmk-build-arm:stable bash
# or if this isn't the first time and the container already exists:
# docker start zmk-builder
# docker exec -it zmk-builder bash
# there, cd into the volume (/app by default) and run this ./build.sh
CYOA_DIR=$(pwd)
mkdir -p /tmp/zmk-config/config # to avoid filling the repo with junk build deps
cp config/* /tmp/zmk-config/config
cd /tmp/zmk-config
west init -l config
west update
west zephyr-export
west build -s zmk/app --board="nice_nano_v2" -- -DSHIELD="sthlmkb_cyoa" -DZMK_CONFIG=$(pwd)/config -DZMK_EXTRA_MODULES=${CYOA_DIR}
if [ -e /tmp/zmk-config/build/zephyr/zmk.uf2 ]; then
    cp /tmp/zmk-config/build/zephyr/zmk.uf2 ${CYOA_DIR} # copy back build artifact so host has it available on the mount
fi
