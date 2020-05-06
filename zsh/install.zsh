#!/bin/zsh

source $(pwd)/common.zsh


setup_zgen() {
	local ZGEN_URL=https://github.com/tarjoilija/zgen.git
	local ZGEN_DIR="${HOME}/.zgen"
	git clone "${ZGEN_URL}" "${ZGEN_DIR}" 2> /dev/null || git -C "${ZGEN_DIR}" pull
}

main() {
	

	
	if ! command_exists zsh; then
		error "Zsh is not installed. Please install zsh first."
		exit 1
	fi

	setup_zgen
}

info "Running $0"
main "$@"
