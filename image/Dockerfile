FROM debian:13

RUN <<EOF
    set -eux
    apt-get update
    apt-get -qqq install -y --no-install-recommends \
      sudo file less wget curl net-tools iproute2 mtr iputils-ping traceroute \
      socat ncat lsof openssh-server jq tini ca-certificates \
      ssh tmux vim less grep
    rm -rf /var/lib/apt/lists/*
EOF


RUN <<EOF
    set -eux
    cd /tmp
    wget https://github.com/tkjaer/etr/releases/download/v1.2.5/etr_1.2.5_amd64.deb
    dpkg -i etr_1.2.5_amd64.deb
    rm etr_1.2.5_amd64.deb
    setcap cap_net_raw=ep /usr/bin/etr
EOF

RUN <<EOF
    mkdir -p /root/.ssh/
    chmod 700 /root/.ssh/

    useradd --uid 2000 --create-home -s /bin/bash user
    mkdir -p /home/user/.ssh/
    chmod 700 /home/user/.ssh/
    chown user:user /home/user/.ssh/
EOF

COPY --chown=root:root --chmod=0600 ./id_ed25519.pub /root/.ssh/authorized_keys
COPY --chown=user:user --chmod=0600 ./id_ed25519.pub /home/user/.ssh/authorized_keys

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/usr/sbin/sshd", "-D"]
