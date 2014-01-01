describe 'Match'
    before
        new
        call typing#_open_text('')
        call typing#reset()
        call setline(1,'Happy Vimming!')
        call typing#_open_input()
        call setline(1,'Happy Vimming!')
    end

    after
        close!
    end

    it '...'
        TODO
    end

    it 'should be matched whole'
        Expect typing#is_match_whole() ==# 1
    end

    it 'should not be matched'
        call setline(1,'')
        Expect typing#is_match_whole() ==# 0
    end

    it 'should get text contents correctly'
        Expect typing#_get_text_content() ==# ['Happy Vimming!']
    end

    it 'should get input contents correctly'
        Expect typing#_get_input_content() ==# ['Happy Vimming!']
    end

    it 'should get linediff index'
        call setline(1,'Happy Emacs!')
        Expect typing#get_linediff_index(0) ==# 6
        call setline(1,'happy Emacs!')
        Expect typing#get_linediff_index(0) ==# 0
    end

end
