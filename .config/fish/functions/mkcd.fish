# Defined via `source`
function mkcd --wraps='mkdir $1 && cd $1' --wraps='mkdir $argv && cd $argv' --wraps='mkdir $argv[0] && cd $argv[0]' --wraps='mkdir "$argv[0]" && cd "$argv[0]"' --wraps='mkdir $argv; cd $argv' --description 'alias mkcd=mkdir $1 && cd $1'
  mkdir $1 && cd $1 $argv
        
end
