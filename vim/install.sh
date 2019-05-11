#!/bin/sh
vim_config_file=~/.config/vim

mkdir -p ~/.config/

if [ ! -L "$vim_config_file" ]; then
  echo "No nvim config found. Symlinking to dotfiles"
  ln -s ~/.dotfiles/vim/vim.symlink "$vim_config_file"
fi
