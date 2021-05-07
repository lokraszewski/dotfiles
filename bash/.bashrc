if [ -z "${NOZSH}" ] && [ $TERM = "xterm" -o $TERM = "xterm-256color" -o $TERM = "screen" -o $TERM = "screen-256color" ] && type zsh &> /dev/null
then
    export SHELL=$(which zsh)
    if [[ -o login ]]
    then
        exec zsh -l
    else
        exec zsh
    fi
fi
. "$HOME/.cargo/env"
