#!/bin/bash
source "$(pwd)/common.sh"

install() {
    if command_exists apt-get ; then
        sudo apt-get install $1 -y
    elif command_exists brew ; then
        brew install $1
    elif command_exists pkg ; then
        sudo pkg install $1
    elif command_exists pacman ; then
        sudo pacman -S $1
    else
        error "No valid package manager found!"
    fi
}

check_if_installed() {
    if command_exists $1 ; then
        success "$1 is installed."
    else
        install $1
    fi
}


PACKAGE_FILE=$(find . -name "package_list")

while read p; do
    info "Checking $p"
    check_if_installed $p
done < $PACKAGE_FILE
