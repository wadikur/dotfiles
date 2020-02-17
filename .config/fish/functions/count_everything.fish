function count_everything -d "Recursively count files and directories in the given directory"
    set -l count (find $argv | wc -l)
    printf "Recursively found %d files and directories in %s" $count $argv
end
