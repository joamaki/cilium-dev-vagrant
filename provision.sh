#!/bin/bash
set -euxo pipefail

function install_k8s() {
    echo KUBELET_EXTRA_ARGS=\"--node-ip=$(ip -4 -o a show enp0s9 | awk '{print $4}' | cut -d/ -f1)\" | \
        sudo tee -a /etc/default/kubelet
    apt-get update && apt-get install -y git apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    apt-get update
    apt-get install -y docker-ce || true
    apt-get update && sudo apt-get install -y apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    cat <<EOF | tee /etc/apt/sources.list.d/kubernetes.list
    deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
    apt-get update
    apt-get install -y kubelet kubeadm kubectl wireguard
    apt-mark hold kubelet kubeadm kubectl
}

function install_kak() {
    pushd $HOME
    apt install -y libncursesw5-dev pkg-config
    test -d kakoune || git clone https://github.com/mawww/kakoune.git
    pushd kakoune
    git pull
    pushd src
    make all install
    popd
    popd
    popd
}

function install_packages() {
    apt install -y tmux zsh
}

function fix_vagrant_user() {
    chown -R vagrant:vagrant /home/vagrant
    chsh vagrant -s /usr/bin/zsh
}

install_k8s
install_kak
install_packages
fix_vagrant_user
