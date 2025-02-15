if status is-interactive
    abbr --add -- lt eza --tree --level 2

    # facilitate hybrid usage of git and jj
    function gg --on-variable PWD
        set --local current_dir (pwd)
        while true
            if [ -d "$current_dir/.jj" ]
                abbr --add -- t jj
                abbr --add -- f jj # for US qwerty keyboards
                break
            end
            if [ -d "$current_dir/.git" ]
                abbr --add -- t git
                abbr --add -- f git # for US qwerty keyboards
                break
            end
            if [ $current_dir = / ]
                abbr --add -- t jj
                abbr --add -- f jj # for US qwerty keyboards
                break
            end
            set current_dir (path dirname $current_dir)
        end
    end

    gg
end
