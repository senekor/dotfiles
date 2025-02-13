if status is-interactive
    abbr --add -- lt eza --tree --level 2

    # facilitate hybrid usage of git and jj
    function gg --on-variable PWD
        if [ -d "$PWD/.git" ]
            abbr --add -- t git
            abbr --add -- f git # for US qwerty keyboards
        end
        if [ -d "$PWD/.jj" ]
            abbr --add -- t jj
            abbr --add -- f jj # for US qwerty keyboards
        end
    end

    gg
end
