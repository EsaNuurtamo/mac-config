function create_playlist
    set dir "/Users/Esa/Dropbox/Reaper/Covers"

    # Create the playlist directory if it doesn't exist
    mkdir -p $dir/Playlist

    # Find all .wav and .mp3 files and select the latest file from each folder
    for folder in (find $dir -type d)
        set latest_file ""
        set latest_timestamp 0

        for file in (ls -t $folder/*.wav $folder/*.mp3)
            set timestamp (stat -c %Y $file)
            if math $timestamp -gt $latest_timestamp
                set latest_timestamp $timestamp
                set latest_file $file
            end
        end

        if test -n $latest_file
            set filename (basename $latest_file)
            set first_character (string sub -l 1 $filename)
            if string match -r '[[:alpha:]]' $first_character
                set source $latest_file
                set destination "$dir/Playlist/$filename"

                # Check if the file already exists in the playlist directory
                if not test -f $destination
                    # Copy the file to the playlist directory
                    cp $source $destination
                    echo "Adding $filename to playlist"
                end
            end
        end
    end
end

