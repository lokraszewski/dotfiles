#!/bin/bash

if [ -t 1 ]; then
    RED=$(printf '\033[31m')
    GREEN=$(printf '\033[32m')
    YELLOW=$(printf '\033[33m')
    BLUE=$(printf '\033[34m')
    BOLD=$(printf '\033[1m')
    RESET=$(printf '\033[m')
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    RESET=""
fi


info () {
  printf "\r  [ ${BLUE}..${RESET} ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r  [ ${GREEN}OK${RESET} ] $1\n"
}

fail () {
  printf "\r  [ ${RED}FAIL${RESET} ] $1\n"
  echo ''
  exit
}

command_exists () {
    type "$1" &> /dev/null ;
}
