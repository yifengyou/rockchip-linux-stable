#!/bin/bash

set -ex

TARGET_IP="${1:-192.168.33.39}"
TARGET_USER="root"
TARGET_PASS="admin"
REMOTE_DIR="/boot/linux-stable"

SSH_CMD="sshpass -p ${TARGET_PASS} ssh ${TARGET_USER}@${TARGET_IP}"
RSYNC_CMD="sshpass -p ${TARGET_PASS} rsync -avz"

md5sum release/Image* release/*.dtb

${SSH_CMD} mkdir -p "${REMOTE_DIR}"
${RSYNC_CMD} release/Image-7* "${TARGET_USER}@${TARGET_IP}:${REMOTE_DIR}/"
${RSYNC_CMD} release/*.dtb              "${TARGET_USER}@${TARGET_IP}:${REMOTE_DIR}/"
${SSH_CMD} md5sum "${REMOTE_DIR}/*"

${SSH_CMD}   rm -rf /lib/modules/7.*
${RSYNC_CMD} kos/lib/modules/*           "${TARGET_USER}@${TARGET_IP}:/lib/modules/"

${SSH_CMD} tree "/boot"

