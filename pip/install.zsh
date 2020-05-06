#!/bin/zsh
#!/bin/zsh
set -e
DOTFILES_DIR=$(pwd -P)
source ${DOTFILES_DIR}/common.zsh
info "Running $0"
sudo pip -q install -r $(pwd)/pip/requirements.txt