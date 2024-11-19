# Defined in .setup_scripts/environment.fish @ line 72
function dotfiles
        if test $argv[1] = "selection"
            python3 $HOME/dotfiles_selection.py
        else
            git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $argv
        end
    
end
