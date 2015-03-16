require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/mini_test'
require_relative '../../lib/crocodile/crocodile_job'

describe 'CrocodileJob' do
  it 'should respond to basic methods' do
    CrocodileJob.must_respond_to :message
    CrocodileJob.must_respond_to :interval
    CrocodileJob.must_respond_to :run
    CrocodileJob.must_respond_to :dismiss?
    CrocodileJob.must_respond_to :logger
  end
end

