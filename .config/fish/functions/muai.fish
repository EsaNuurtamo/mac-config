function muai
    # Path to the virtual environment you created for your tool
    set VENV_PATH $HOME/music-ai/.venv

    # Activate the virtual environment
    source $VENV_PATH/bin/activate.fish

    # Run the tool
    python3 $HOME/music-ai/muai.py $argv

    # Deactivate the virtual environment
    deactivate
end

