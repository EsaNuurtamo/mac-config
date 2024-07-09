#!/bin/bash
echo "Installing xcode-select"
if [ ! -n "$(which xcode-select)" ]
then
  sudo xcode-select install
else
  echo "Xcode already installed"
fi

echo "Installing brew"
if [ ! -n "$(which brew)" ]
then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
  echo "Brew already installed"
fi

#install fisher
curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

npm install -g eslint_d

echo "Updating homebrew..."
brew update
brew tap Homebrew/bundle
brew bundle
brew cleanup
