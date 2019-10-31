#!/bin/bash

set -e
source ./common.sh

DOTFILES_DIR=$(pwd -P)
echo ''

link_file () {
  local src=$1 dst=$2
  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ] ; then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ] ; then
      local currentSrc="$(readlink $dst)"
      if [ "$currentSrc" == "$src" ] ; then
        skip=true;
      else
        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action
        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac
      fi
    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ] ; then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ] ; then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ] ; then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ] ; then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

install_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  for src in $(find -H "${DOTFILES_DIR}" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}

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


install_package(){
  PACKAGE_FILE=$(find . -name "package_list")
  while read p; do
      info "Checking $p"
      check_if_installed $p
  done < $PACKAGE_FILE
}

run_all_install () {
  for installer in $(find . -name '*install*' -not -path './install.sh'); do
      info "running ${installer}"
      sh -c "${installer} ${DOTFILES_DIR}"
  done
}


main (){
  echo ''
  install_dotfiles
  install_package
  run_all_install
  success '  All installed!'
}

main "$@"


