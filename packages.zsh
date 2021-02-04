#!/usr/bin/env zsh
# Run this to install required packages.

INSTALL_TYPE=min

command_exists () {
    type "$1" &> /dev/null ;
}


if [ "$#" -ge 1 ] ; then
    INSTALL_TYPE=$1
fi

INSTALL_FILE=$(pwd)/packages_${INSTALL_TYPE}.txt

if [[ ! -f $INSTALL_FILE ]]
then
    echo "${INSTALL_FILE} does not exist, cannot install!"
    exit 1
fi

if command_exists apt-get ; then
    cat ${INSTALL_FILE} | xargs sudo apt-get -y -qq install 
elif command_exists brew ; then
    cat ${INSTALL_FILE} | xargs sudo brew install 
elif command_exists pacman ; then
    cat ${INSTALL_FILE} | xargs sudo pacman -S 
else
    error "No valid package manager found!"
fi