describe 'Buffer'
    before
    end

    after
         close!
    end

    it '...'
        TODO
    end

    it 'should create buffer'
        call typing#open('')
        Expect typing#is_open() ==# 1
    end

    it 'should create text buffer'
        call typing#_open_text('')
        Expect typing#is_open() ==# 1
        Expect &modifiable ==# 0
    end

    it 'should create input buffer'
        call typing#_open_input()
        Expect typing#is_open() ==# 1
        Expect &modifiable ==# 1
    end

    it 'should set filetype'
        call typing#open('')
        Expect &filetype ==# 'typing'
        Expect &filetype !=# 'vim'
    end

    it 'should set buftype'
        call typing#open('')
        Expect &buftype ==# 'nofile'
        Expect &buftype !=# 'nowrite'
    end

    it 'should be closed'
        call typing#close()
        Expect typing#is_open() ==# 0
        Expect typing#_is_open_text() ==# 0
        Expect typing#_is_open_input() ==# 0
    end

    it 'text should be closed'
        call typing#_close_text()
        Expect typing#_is_open_text() ==# 0
    end

    it 'input should be closed'
        call typing#_close_input()
        Expect typing#_is_open_input() ==# 0
    end

end

describe 'Mapping'
    it 'should be closed by q'
        call typing#open('')
        Expect hasmapto(':call typing#close()<CR>', 'n') ==# 1
    end
end

