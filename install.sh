#!/bin/bash
source $(pwd)/common.sh 


TYPE_MIN=1
TYPE_DEV=2
TYPE_FULL=4
TYPE_DOT=8
TYPE=$(( $TYPE_MIN | $TYPE_DOT ))

POSITIONAL=()
USAGE="Usage: $0  [ full | dev ]"

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


install_home_dotfiles () {
  info 'installing dotfiles for ~'
  for src in $(find -H "$(pwd)/link" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}


install_config_dotfiles () {
  mkdir -p ~/.config/
  info 'installing dotfiles for .config'
  for src in $(find -H "$(pwd)/config" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.config/$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done
}

setup_tmux() {
    # install TPM for tmux plugins
	local TMUX_URL=hhttps://github.com/tmux-plugins/tpm
    [ ! -d ~/.tmux/plugins/tpm ] && git clone $TMUX_URL ~/.tmux/plugins/tpm || info "tpm already installed!"
}

setup_zgen() {
	local ZGEN_URL=https://github.com/tarjoilija/zgen.git
	local ZGEN_DIR="${HOME}/.zgen"
    [ ! -d $ZGEN_DIR ] &&
	git clone "${ZGEN_URL}" "${ZGEN_DIR}" 2> /dev/null || git -C "${ZGEN_DIR}" pull --ff-only
}

setup_vim() {
    local VIM_PLUG_URL=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    local VIM_PLUG_PATH="${HOME}/.vim/autoload/plug.vim"
    [ ! -f $VIM_PLUG_PATH ] && info "Fetching plug for vim" &&
    curl -fLo $VIM_PLUG_PATH --create-dirs $VIM_PLUG_URL
}


while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        dev) TYPE=$(( $TYPE | $TYPE_DEV )); shift;;
        full) TYPE=$(( $TYPE | $TYPE_FULL | $TYPE_DEV )); shift;;
        -h|--help)
        echo "$USAGE"
        exit 0
        ;;
        *)    
        POSITIONAL+=("$1") 
        shift # past argument
        ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters


[[ $(( $TYPE & $TYPE_MIN )) ]] && install "$(cat $(pwd)/packages/minimum)"
[[ $(( $TYPE & $TYPE_DEV )) ]] && install "$(cat $(pwd)/packages/dev)"
[[ $(( $TYPE & $TYPE_FULL )) ]] && install "$(cat $(pwd)/packages/full)"
[[ $(( $TYPE & $TYPE_MIN )) ]] && setup_tmux
[[ $(( $TYPE & $TYPE_MIN )) ]] && setup_zgen
[[ $(( $TYPE & $TYPE_DEV )) ]] && setup_vim
[[ $(( $TYPE & $TYPE_DOT )) ]] && install_home_dotfiles 
[[ $(( $TYPE & $TYPE_DOT )) ]] && install_config_dotfiles
