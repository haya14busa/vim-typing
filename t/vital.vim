describe 'Vital'
  it 'succeeds if import Vital BufferManager'
    Expect typing#TestBufferManager() ==# 'tabpage'
    Expect typing#TestBufferManager() !=# ''
  end

  it 'succeeds if import Vital DataString'
    Expect typing#TestDataString() ==# 'foozzzbazbar'
    Expect typing#TestDataString() !=# 'hoge'
  end

  it 'succeeds if import Vital Random.Xor128'
    Expect typing#TestRandom() ==# -593279510
    Expect typing#TestRandom() ==# 458299110
  end
end
