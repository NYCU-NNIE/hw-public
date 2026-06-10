#!/bin/bash
NAME=hw3

cd "$(dirname "${BASH_SOURCE[0]}")"

mkdir -p jump-host-data
chmod 777 jump-host-data

clab --log-level warn destroy -acy || true
docker build -t nnie-linux ../image
clab --log-level warn deploy -t ${1-./hw3.init.clab.yaml}
sleep 10
clab --log-level warn exec --name $NAME --cmd "sh -lc '[ -x /tmp/init.sh ] && /tmp/init.sh || true'"
