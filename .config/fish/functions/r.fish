function r
    if count $argv > /dev/null
        if [ -d "$argv" ]
            ranger "$argv"
        else
            ranger (fasd_cd "$argv")
        end
    else
        ranger
    end
end
