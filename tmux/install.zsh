#!/bin/zsh
set -e
source $(pwd -P)/common.zsh
info "Running $0"
[ ! -d ~/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm || info "tpm already installed!"
