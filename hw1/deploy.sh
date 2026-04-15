#!/bin/bash
NAME=hw1

cd "$(dirname "${BASH_SOURCE[0]}")"

mkdir -p jump-host-data
chmod 777 jump-host-data

create_bridge() {
  local bridge_name=$1
  sudo ip link del "$bridge_name" 2>/dev/null || true
  sudo ip link add name "$bridge_name" type bridge
  sudo ip link set "$bridge_name" up
}

clab --log-level warn destroy -c --name $NAME || true
sudo ip link del ym-sw 2>/dev/null || true
sudo ip link del gf-sw 2>/dev/null || true
docker build -t nnie-linux ../image
create_bridge ym-sw
create_bridge gf-sw
clab --log-level warn deploy -t ${1-./hw1.init.clab.yaml}
sleep 10
clab --log-level warn exec --name $NAME --cmd /tmp/init.sh
