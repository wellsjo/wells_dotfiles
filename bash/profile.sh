#!/bin/bash

EDITOR=vim
TZ=America/New_York
LANG=en_US.UTF-8
HISTFILE="${HOME}/.history"
HISTSIZE=1000

# Darwinism
CLICOLOR=1

# Autoload includes
for includeFile in $(find "${HOME}/.wells_dotfiles/bash/includes" -type f ! -iname *.swp)
do
    . "${includeFile}"
done

# source bash-git-prompt
GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_THEME=Solarized
GIT_PROMPT_START="\n${BoldWhite}\u${ResetColor}${Black}@${BoldCyan}\H:${BoldYellow}\w${ResetColor}"
. ~/.wells_dotfiles/bash/bash-git-prompt/gitprompt.sh

# load my aliases
. ~/.wells_dotfiles/bash/aliases.sh

export EDITOR TZ LANG HISTFILE HISTSIZE CLICOLOR

# Used by bash, unused by mksh
if [ "${0##*/}" = "bash" ] || [ "${0}" = "-bash" ] ; then
    shopt -s expand_aliases
    shopt -s checkwinsize
    HISTFILESIZE=2000
    HISTCONTROL=ignoredups:ignorespace
    export HISTFILESIZE HISTCONTROL
fi

if type -p rbenv >/dev/null 2>&1 ; then
    eval "$(rbenv init -)"
fi

# Load a local profile
[ -r "${HOME}/.localprofile" ] && . "${HOME}/.localprofile"

# for spotify.com website
export PATH=$PATH:/home/wells/src/web-site/Symfony/app
export PATH=$PATH:/home/wells/src/web-site-translations/Symfony/app
export PATH=$PATH:/home/wells/src/web-site-translations/Symfony/Symfony/app
export PATH=$PATH:/home/wells/src/web-site/Symfony/app/Symfony/app
export PATH=$PATH:/home/wells/Symfony/app
