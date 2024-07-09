#!/bin/bash

# Install Homebrew and Git
echo "Installing Homebrew and Git..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew install git

# Clone the dotfiles repository as a bare repository
echo "Cloning dotfiles repository..."
echo ".dotfiles" >> .gitignore
git clone --bare git@github.com:EsaNuurtamo/dotfiles.git $HOME/.dotfiles

# Define the 'dotfiles' alias
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Hide files which are not explicitly tracked
dotfiles config --local status.showUntrackedFiles no

dotfiles checkout

# Install brew and all the applications and tools
echo "Installing brew applications and tools..."
sh .setup_scripts/brew.sh

# Setup gitconfig and default shell to fish
echo "Setting up environment..."
fish .setup_scripts/environment.fish

# Add dotfiles to your home directory
echo "Adding dotfiles to home directory..."
fish .setup_scripts/dotfiles.fish

# Configure neovim
echo "Configuring neovim..."
ln -s $(which nvim) /usr/local/bin/vim

echo "Setup complete!"
