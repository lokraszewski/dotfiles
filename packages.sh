#!/bin/bash
# Run this to install required packages.

command_exists () {
    type "$1" &> /dev/null ;
}

INSTALL_FILE=$(pwd)/packages.txt

if [[ ! -f $INSTALL_FILE ]]
then
    echo "${INSTALL_FILE} does not exist, cannot install!"
    exit 1
fi

if command_exists apt-get ; then
    cat ${INSTALL_FILE} | sed -e 's/#.*//' | xargs apt-get --no-install-recommends -y install 
elif command_exists brew ; then
    cat ${INSTALL_FILE} | sed -e 's/#.*//' | xargs brew install 
elif command_exists pacman ; then
    cat ${INSTALL_FILE} | sed -e 's/#.*//' | xargs pacman -S 
else
    error "No valid package manager found!"
fi
