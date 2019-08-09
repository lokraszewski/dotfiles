#!/bin/sh
set -e

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

error() {
	echo ${RED}"Error: $@"${RESET} >&2
}

setup_color() {
	# Only use colors if connected to a terminal
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
}

setup_zgen() {
	local ZGEN_URL=https://github.com/tarjoilija/zgen.git
	local ZGEN_DIR="${HOME}/.zgen"
	git clone "${ZGEN_URL}" "${ZGEN_DIR}" 2> /dev/null || git -C "${ZGEN_DIR}" pull
}

main() {
	# Parse arguments
	while [ $# -gt 0 ]; do
		case $1 in
			--skip-chsh) CHSH=no ;;
		esac
		shift
	done

	setup_color
	setup_zgen


	if ! command_exists zsh; then
		echo "${YELLOW}Zsh is not installed.${RESET} Please install zsh first."
		exit 1
	fi
}

main "$@"
