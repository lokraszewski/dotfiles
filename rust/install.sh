#!/bin/bash
source $1/common.sh

check_if_installed() {
    if command_exists $1 ; then
        echo "$1 is installed."
    else
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
}


check_if_installed rustc
source ~/.cargo/env
