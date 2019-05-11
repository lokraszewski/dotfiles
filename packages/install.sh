#!/bin/bash

command_exists () {
    type "$1" &> /dev/null ;
}

prompt_install() {
    echo -n "$1 is not installed. Would you like to install it? (y/n) " >&2
    old_stty_cfg=$(stty -g)
    stty raw -echo
    answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
    stty $old_stty_cfg && echo
    if echo "$answer" | grep -iq "^y" ;then
        if command_exists apt-get ; then
            sudo apt-get install $1 -y
        elif command_exists brew ; then
            brew install $1
        elif command_exists pkg ; then
            sudo pkg install $1
        elif command_exists pacman ; then
            sudo pacman -S $1
        else
            echo "No valid package manager found!"
        fi
    fi
}

check_if_installed() {
    if command_exists $1 ; then
        echo "$1 is installed."
    else
        prompt_install $1
    fi
}

PACKAGE_FILE=$(find . -name "package_list")

while read p; do
    echo "Checking $p"
    check_if_installed $p
done < $PACKAGE_FILE
