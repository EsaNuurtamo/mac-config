#!/usr/bin/env fish

function success
    echo [(set_color --bold green) ' OK ' (set_color normal)] $argv
end

function abort
    echo [(set_color --bold yellow) ABRT (set_color normal)] $argv
    exit 1
end

#Setup github settings
set managed (git config --global --get dotfiles.managed)
# if there is no user.email, we'll assume it's a new machine/setup and ask it
if test -z (git config --global --get user.email)
    user 'What is your github author name?'
    read user_name
    user 'What is your github author email?'
    read user_email

    test -n $user_name
    or echo "please inform the git author name"
    test -n $user_email
    or abort "please inform the git author email"

    git config --global user.name $user_name
    and git config --global user.email $user_email
    or abort 'failed to setup git user name and email'
else if test "$managed" != true
    # if user.email exists, let's check for dotfiles.managed config. If it is
    # not true, we'll backup the gitconfig file and set previous user.email and
    # user.name in the new one
    set user_name (git config --global --get user.name)
    and set user_email (git config --global --get user.email)
    and mv ~/.gitconfig ~/.gitconfig.backup
    and git config --global user.name $user_name
    and git config --global user.email $user_email
    and success "moved ~/.gitconfig to ~/.gitconfig.backup"
    or abort 'failed to setup git user name and email'
else
    # otherwise this gitconfig was already made by the dotfiles
    info "already managed by dotfiles"
end
# include the gitconfig.local file
# finally make git knows this is a managed config already, preventing later
# overrides by this script
git config --global include.path ~/.gitconfig.local
and git config --global dotfiles.managed true
or abort 'failed to setup git'

user 'Do you want to create SSH key? (y/n)'
read create_ssh
if test $create_ssh ='y'
    echo "Creating an SSH key for you..."
    ssh-keygen -t rsa
    echo "Please add this public key to Github \n"
    echo "https://github.com/account/ssh \n"
    read -p "Press [Enter] key after this..."
end


echo "Making fish the default shell"
if ! grep (command -v fish) /etc/shells
    command -v fish | sudo tee -a /etc/shells
    and success 'added fish to /etc/shells'
    or abort 'setup /etc/shells'
    echo
end

test (which fish) = $SHELL
and success 'Fish is already the default shell!'
and exit 0

chsh -s (which fish)
and success set (fish --version) as the default shell
or abort 'set fish as default shell'
