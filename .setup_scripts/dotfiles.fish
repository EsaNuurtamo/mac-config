#!/usr/bin/env fish
#
# bootstrap installs things.

function info
    echo [(set_color --bold) ' .. ' (set_color normal)] $argv
end

function user
    echo [(set_color --bold) ' ?? ' (set_color normal)] $argv
end

function success
    echo [(set_color --bold green) ' OK ' (set_color normal)] $argv
end

function abort
    echo [(set_color --bold yellow) ABRT (set_color normal)] $argv
    exit 1
end

function on_exit -p %self
    if not contains $argv[3] 0
        echo [(set_color --bold red) FAIL (set_color normal)] "Couldn't setup dotfiles, please open an issue at https://github.com/caarlos0/dotfiles"
    end
end

function setup_gitconfig
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
end

#Get's the dotfiles to HOME from the repo and adds command "dotfiles" for interacting with the repo
function setup_dotfiles
    function dotfiles
      if test $argv[1] = "selection"
        python3 $HOME/dotfiles_selection.py
      else
        git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $argv
      end
    end
    funcsave dotfiles

    dotfiles checkout
    mkdir -p .dotfiles-backup

    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | while read -l line
        mv $line .dotfiles-backup/$line
    end

    dotfiles config --local status.showUntrackedFiles no
end

setup_dotfiles
and success dotfiles
or abort dotfiles

setup_gitconfig
and success gitconfig
or abort gitconfig

fisher update
and success plugins
or abort plugins


mkdir -p $__fish_config_dir/completions/
and success completions
or abort completions

for installer in */install.fish
    $installer
    and success $installer
    or abort $installer
end


success 'dotfiles installed/updated!'
