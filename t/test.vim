describe ':Expect'
  it 'succeeds if an actual value matches to an expected value'
    let something = 'foo'
    Expect something ==# 'foo'
  end
end
