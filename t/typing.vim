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

end

