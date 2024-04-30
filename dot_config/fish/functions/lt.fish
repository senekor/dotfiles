function lt --argument-names level
    if test "$level" = ""
        eza --tree --level 2
    else
        eza --tree --level $level
    end
end
