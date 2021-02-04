#  ███████╗███████╗██╗  ██╗
#  ╚══███╔╝██╔════╝██║  ██║
#    ███╔╝ ███████╗███████║
#   ███╔╝  ╚════██║██╔══██║
#  ███████╗███████║██║  ██║
#  ╚══════╝╚══════╝╚═╝  ╚═╝
# zplug

if [[ -z $ZPLUG_HOME ]]; then
    export ZPLUG_HOME=~/.zplug
fi

# Install zplug if it does not exist
[ -d $ZPLUG_HOME ] || source ~/.zsh.d/zplug/installer.zsh

source ~/.zplug/init.zsh

zplug "agkozak/zsh-z"
zplug "zsh-users/zaw"
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/colorize", from:oh-my-zsh # syntax highlight, use ccat 
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh # lots of useful git aliases
zplug "plugins/git-flow", from:oh-my-zsh # same but for git flow
zplug "plugins/python", from:oh-my-zsh #python completions
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "mafredri/zsh-async", from:"github"
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

if ! zplug check; then
    zplug install
fi

zplug load
