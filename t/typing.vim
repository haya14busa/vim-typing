filetype plugin on
runtime! plugin/typing.vim

describe 'vim-typing'
    before
    end
    after
        close!
    end

    it 'provide :Typing command'
        Expect exists(':Typing') !=# 0
    end

    it 'open own typing buffer'
        Typing
        Expect typing#is_open() ==# 1
    end

    it 'match text while insertmode'
        " call typing#_open_text()
        " call typing#reset()
        " call setline(1,'Happy Vimming!')
        "
        " call typing#_open_input()
        Typing

        exec "normal! \<C-w>k"
        call typing#reset()
        call setline(1,'Happy Vimming!')
        set nomodifiable
        exec "normal! \<C-w>j"
        exec "normal! iHappy Vimming!"
        let input_txt = getline(1)
        Expect input_txt ==# ''
    end

end
