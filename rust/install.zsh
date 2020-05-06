#!/bin/zsh
source $(pwd)/common.zsh
info "Running $0"

[ -f ~/.cargo/env ] && source ~/.cargo/env || warn "~/.cargo/env not found"

if command_exists rustc ; then
	info "rust is installed."
else
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sudo sh
fi

