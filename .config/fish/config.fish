# Set up the path
set -gx PATH /usr/local/bin $PATH

# Set up any aliases or functions you need here

# You can uncomment this later if you set up VS Code
# if type -q code
#     . (code --locate-shell-integration-path fish)
# end

# Generated for envman. Do not edit.
if test -s "$HOME/.config/envman/load.fish"
    source "$HOME/.config/envman/load.fish"
end


# pnpm
set -gx PNPM_HOME "/Users/esa/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
