  function organize_files --arguments t/types f/folder -d "Recursevly traverses the folder tree and moves files that are certain type to user named folder in each directory"
    while set -q argv[1]
        switch $argv[1]
            case -t --types
                set types (string split "," $argv[2])
                set -e argv[1..2]
            case -f --folder
                set folder $argv[2]
                set -e argv[1..2]
            case '*'
                echo "Unsupported option: $argv[1]"
                return 1
        end
    end

    for type in $types
        echo "Processing files with .$type extension"
        find . -type f -iname "*.$type" -print | while read -l file
            set -l dir (dirname $file)
            set -l base_dir (basename $dir)
            if test $base_dir = $folder
                continue
            end
            set -l target_dir $dir/$folder
            if not test -d $target_dir
                echo "Creating directory $target_dir"
                mkdir -p $target_dir
            end
            echo "Moving $file to $target_dir"
            mv $file $target_dir/
        end
    end
end
