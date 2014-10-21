#!/bin/bash

# re-source dotfiles from git repo
wells_update() {
    echo
    read -p "Do you want to update and re-source from the remote wells_dotfiles repository? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        wells_install
    else
        read -p "Do you want to re-source from the local wells_dotfiles repository? " -n 1 -r
        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            wells_source
        fi
    fi
}
alias wupdate="wells_update"

# re-source local dotfiles
wells_source() {
    echo "Re-sourcing local dotfiles..."
    source ~/.wells_dotfiles/bash/profile
    echo
    read -p "Re-load tmux config? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Re-sourcing tmux config..."
        tmux source ~/.tmux.conf
    fi
}
alias wsource="wells_source"

# push local dotfiles to repo
wells_push() {
    echo
    echo "Showing diff..."
    echo
    local cur_dir=${PWD}
    cd ~/.wells_dotfiles
    git diff
    git status
    echo
    read -p "Do you want to update the remote git repository? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo "Updating repository..."
        git add .
        git commit -m "updated from running wells_push"
        git push
    fi
    cd ${cur_dir}
}
alias wpush="wells_push"

# Setup the dotfiles repo locally, or pull latest version from github.
# Create symlinks in the $HOME directory to elements in the repo
wells_install() {

    echo -e "\nInstalling wells_dotfiles..."

    local REPO='https://github.com/wellsjo/wells_dotfiles'

    # If the dotfiles dir already exists
    if [ -d "${HOME}/.wells_dotfiles" ] ; then
        cd "${HOME}/.wells_dotfiles"
        git reset --hard HEAD >/dev/null 2>&1
        echo "Updating from git repo..."
        git pull
    else
        echo "wells_dotfiles not present"
        echo -e "Cloning git repo from ${REPO}..."
        cd "${HOME}"
        git clone --depth 1 ${REPO} .wells_dotfiles
        cd "${HOME}/.wells_dotfiles"
    fi

    echo -e "\nSetting symlinks..."
    h.symlink "${HOME}/.wells_dotfiles/vim/vimrc" "${HOME}/.vimrc"
    h.symlink "${HOME}/.wells_dotfiles/vim" "${HOME}/.vim"
    h.symlink "${HOME}/.wells_dotfiles/bash/profile" "${HOME}/.profile"
    h.symlink "${HOME}/.wells_dotfiles/bash/profile" "${HOME}/.bashrc"
    h.symlink "${HOME}/.wells_dotfiles/bash/profile" "${HOME}/.bash_profile"
    h.symlink "${HOME}/.wells_dotfiles/bash" "${HOME}/.bash"
    h.symlink "${HOME}/.wells_dotfiles/git/gitconfig" "${HOME}/.gitconfig"
    h.symlink "${HOME}/.wells_dotfiles/git/gitignore_global" "${HOME}/.gitignore_global"
    h.symlink "${HOME}/.wells_dotfiles/bash/fzf" "${HOME}/.fzf"
    h.symlink "${HOME}/.wells_dotfiles/tmux/tmux.conf" "${HOME}/.tmux.conf"

    # source tmux
    echo -e "\nSourcing tmux..."
    tmux source ~/.tmux.conf

    cd "${HOME}"

    # Delete any broken symlinks in the homedir
    find -L . -maxdepth 1 -type l -exec rm -- {} +

    # Source the profile to get things going
    . "${HOME}/.profile"

    echo -e "\nDone!"
    echo -e "\nType 'wells_settings' to get a list of available commands"
}
alias winstall="wells_install"

wells_uninstall() {
    cd ~
    rm -rf .wells_dotfiles
    rm .fzf .bash .bash_profile .bashrc .gitconfig .gitignore_global .profile .tmux.conf .vim .vimrc
}

# Simple wrapper for ssh which makes wells_update() available in the remote session
# regardless of whether .dotfiles is present remotely or not
wellssh() {
    local func=$(typeset -f wells_install)
    local func2=$(typeset -f symlink)
    ssh -A -t "$@" \
    "${func2} ;
    ${func} ;
    [ -r /etc/motd ] && cat /etc/motd ;
    [ -r \"\$HOME/.profile\" ] && . \"\$HOME/.profile\" ;
    type wellssh >/dev/null 2>&1 ||  wells_update;
    exec env -i SSH_AUTH_SOCK=\"\$SSH_AUTH_SOCK\" \
      SSH_CONNECTION=\"\$SSH_CONNECTION\" \
      SSH_CLIENT=\"\$SSH_CLIENT\" SSH_TTY=\"\$SSH_TTY\" \
      HOME=\"\$HOME\" TERM=\"\$TERM\" \
      PATH=\"\$PATH\" SHELL=\"\$SHELL\" \
      USER=\"\$USER\" \$SHELL -i"
}

# display available functions/readme
function wells_help() {
    # spit out the README while stripping ugly tags
    cat ~/.wells_dotfiles/README.md | sed -r 's/<\/?pre>//'
}
alias wsettings="wells_help"
alias whelp="wells_help"

# Simple helper to remove and make symlinks
function h.symlink() {
    # If this isnt a symlink
    if [ ! -L "$2" ]; then
        # Backup the file
        mv "$2" "$2.backup" >/dev/null 2>&1

        # Now remove it, dirs too
        rm -rf "$2" >/dev/null 2>&1
    fi

    # If the target is already a symlink
    if [ -L "$2" ]; then
        rm "$2" >/dev/null 2>&1
    fi

    # Create that symlink!
    ln -s $1 $2
}
