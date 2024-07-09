# Defined interactively
function _activate_venv_on_start
    if test -d "venv"
        source venv/bin/activate.fish
        echo "Activated virtual environment from 'venv/'"
    else if test -d ".venv"
        source .venv/bin/activate.fish
        echo "Activated virtual environment from '.venv/'"
    end
end
