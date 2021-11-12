require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/minitest'
require_relative '../../lib/crocodile/crocodile_job'

describe 'CrocodileJob' do
  it 'should respond to basic methods' do
    _(CrocodileJob).must_respond_to :message
    _(CrocodileJob).must_respond_to :interval
    _(CrocodileJob).must_respond_to :run
    _(CrocodileJob).must_respond_to :one_run_only
    _(CrocodileJob).must_respond_to :logger
  end
end

