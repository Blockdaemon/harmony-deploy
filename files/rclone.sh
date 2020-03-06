#!/bin/bash
sudo -u harmony mkdir -p /data/harmony/archive
for i in 0 1 2 3; do
  sudo -u harmony rclone sync -v mainnet:pub.harmony.one/mainnet.min/harmony_db_$i /data/harmony/archive/harmony_db_$i > /data/harmony/archive/archive-$i.log 2>&1
done
