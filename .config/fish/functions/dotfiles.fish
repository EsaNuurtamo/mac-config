# Defined interactively
function dotfiles
      if test $argv[1] = "selection"
        python3 $HOME/.setup_scripts/dotfiles_selection.py
      else
        git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $argv
      end
    
end
