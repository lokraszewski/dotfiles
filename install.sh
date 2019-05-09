#!/bin/bash

prompt_install() {
    echo -n "$1 is not installed. Would you like to install it? (y/n) " >&2
    old_stty_cfg=$(stty -g)
    stty raw -echo
    answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
    stty $old_stty_cfg && echo
    if echo "$answer" | grep -iq "^y" ;then
        # This could def use community support
        if [ -x "$(command -v apt-get)" ]; then
            sudo apt-get install $1 -y

        elif [ -x "$(command -v brew)" ]; then
            brew install $1

        elif [ -x "$(command -v pkg)" ]; then
            sudo pkg install $1

        elif [ -x "$(command -v pacman)" ]; then
            sudo pacman -S $1

        else
            echo "No valid package manager found!"
        fi
    fi
}

check_if_installed() {
    if ! [ -x "$(command -v $1)" ]; then
        prompt_install $1
    else
        echo "$1 is installed."
    fi
}


check_default_shell() {
    if [ -z "${SHELL##*bash*}" ] ;then
            echo "Default shell is bash."
    else
        echo -n "Default shell is not bash. Do you want to chsh -s \$(which bash)? (y/n)"
        old_stty_cfg=$(stty -g)
        stty raw -echo
        answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
        stty $old_stty_cfg && echo
        if echo "$answer" | grep -iq "^y" ;then
            chsh -s $(which bash)
        else
            echo "Warning: Your configuration won't work properly. If you exec bash, it'll exec tmux which will exec your default shell which isn't bash."
        fi
    fi
}

# git pull origin master
check_if_installed vim
check_if_installed tmux
check_default_shell

rsync   --exclude ".git/" \
        --exclude "install.sh" \
        --exclude "README.md" \
        -avh --no-perms . ~

source ~/.bash_profile

