require 'minitest/autorun'
require 'minitest/spec'
require 'mocha/mini_test'
require_relative '../../lib/crocodile/crocodile_process'
require_relative '../../lib/crocodile/crocodile_job'

describe 'CrocodileProcess' do
  def setup
    job =<<-CLASS
    class TestJob < CrocodileJob
      def self.interval;1;end
      def self.logger;Logger.new('/dev/null');end
      def self.run;end
    end
    CLASS

    Dir.mkdir("jobs") unless File.exist? "jobs"
    File.open("jobs/test.rb", "w") do |f|
      f.puts job
    end
  end

  def teardown
    File.unlink("jobs/test.rb")
  end
  

  it 'should run the job' do
    require './jobs/test' #required to be able to set expectation

    process = CrocodileProcess.new('test', '/tmp')
    TestJob.expects(:interval).returns(0.1)
    TestJob.expects(:message).returns("Testing Process")
    TestJob.expects(:run)
    TestJob.expects(:one_run_only).returns(true)

    process.start
  end

  it 'should daemonize the process' do
    process = CrocodileProcess.new('test', '/tmp')

    Process.expects(:daemon).returns(true)
    process.daemonize!
  end
end

