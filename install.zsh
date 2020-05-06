#!/bin/zsh

set -e

DOTFILES_DIR=$(pwd -P)
source ${DOTFILES_DIR}/common.zsh

overwrite_all=false 
backup_all=false 
skip_all=false

link_file () {
  local src=$1 dst=$2
  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ] ; then

    if [ "$overwrite_all" = "false" ] && [ "$backup_all" = "false" ] && [ "$skip_all" = "false" ] ; then
      local currentSrc="$(readlink $dst)"
      if [ "$currentSrc" = "$src" ] ; then
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

    if [ "$overwrite" = "true" ] ; then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" = "true" ] ; then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" = "true" ] ; then
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
  for src in $(find -H "${DOTFILES_DIR}" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}


install_package(){
	if command_exists apt-get ; then
		xargs -a ${DOTFILES_DIR}/packages/package_list sudo apt-get -y -q install 
	elif command_exists brew ; then
		xargs -a ${DOTFILES_DIR}/packages/package_list sudo brew install
	elif command_exists pacman ; then
		xargs -a ${DOTFILES_DIR}/packages/package_list sudo pacman -S
	else
	    error "No valid package manager found!"
	fi
}

main (){
  info "Using shell: $(eval "${SHELL} --version")"

  install_dotfiles

  install_package
  
  eval "${SHELL} -c ./fonts/install.zsh"
  eval "${SHELL} -c ./zsh/install.zsh"
  eval "${SHELL} -c ./tmux/install.zsh"
  eval "${SHELL} -c ./pip/install.zsh"
  eval "${SHELL} -c ./vim/install.zsh"
  eval "${SHELL} -c ./rust/install.zsh"

  success '  All installed!'
}

main "$@"


