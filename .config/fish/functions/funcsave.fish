function funcsave
    if not functions -q $argv[1]
        echo "Function '$argv[1]' does not exist"
        return 1
    end

    set -l funcname $argv[1]
    set -l filepath ~/.config/fish/functions/$funcname.fish

    # Save the function definition to a file
    functions $funcname >$filepath
    for i in (seq 2 (count $argv))
      switch $argv[$i]
        case --commit
          dotfiles add $filepath
          dotfiles commit -m "added $funcname.fish"
          dotfiles push --set-upstream origin main
        case '--*'
          echo "Unknown flag '$argv[$i]'"
      end
    end
  end

