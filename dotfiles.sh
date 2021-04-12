#!/bin/bash

cd $HOME
export GOPATH=$HOME/go
mkdir $HOME/bin
curl -sfL https://git.io/chezmoi | sh
bin/chezmoi init --apply https://github.com/joamaki/dotfiles.git
bin/chezmoi update

# Install kak-lsp
# TODO make part of chezmoi config
cd "$(mktemp -d)"
curl -sL https://github.com/kak-lsp/kak-lsp/releases/download/v9.0.0/kak-lsp-v9.0.0-x86_64-unknown-linux-musl.tar.gz
tar xzf kak-lsp-v9.0.0-x86_64-unknown-linux-musl.tar.gz
mv -f kak-lsp ~/bin/
mkdir -p ~/.config/kak-lsp
test -f ~/.config/kak-lsp || mv kak-lsp.toml ~/.config/kak-lsp/
