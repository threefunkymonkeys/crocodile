require 'minitest/autorun'
require 'minitest/spec'

describe 'Executable Worker' do
  it 'should ask for job name' do
    output = `./bin/crocodile 2>&1`

    _(output).must_include "Must indicate a job name"
    _(output).must_include "Usage"
  end

  it 'should ask for an action' do
    output = `./bin/crocodile test 2>&1`

    _(output).must_include "Must indicate an action"
    _(output).must_include "Usage"
  end
end
