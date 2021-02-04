#!/usr/bin/env zsh
DESIRED_SHELL=zsh

# stow all dirs 
for d in *(/); stow -v -t ~/ -S $d

# Check if zsh is default shell
if [[ ! $(grep $USER /etc/passwd | grep $DESIRED_SHELL)  ]]; then
	if [[ $(type "$DESIRED_SHELL") ]]; then
		chsh -s $(which $DESIRED_SHELL)
	fi
fi