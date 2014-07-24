require 'eventmachine'

class CrocodileProcess
  def initialize(job_name, pids_dir)
    @name = job_name
    @job_path = File.expand_path("jobs/#{job_name}")
    @pid_path = File.expand_path("#{job_name}.pid", pids_dir)
  end

  def start
    schedule(launch_immediately=true)
  end

  def schedule(launch_immediately=false)
    require @job_path
    job_class = constantize(@name)

    Signal.trap("INT")  { EventMachine.stop }
    Signal.trap("TERM") { EventMachine.stop }

    EventMachine.run do
      EventMachine.next_tick do
        job_class.logger.info job_class.message
        job_class.run
        EventMachine.stop if job_class.dismiss?
      end if launch_immediately

      timer = EventMachine::PeriodicTimer.new(job_class.interval || 60) do
        job_class.logger.info job_class.message
        job_class.run
        if job_class.dismiss?
          timer.cancel
          EventMachine.stop
        end
      end
    end
  end

  def stop
    if File.exists?(@pid_path)
      Process.kill :TERM, File.open(@pid_path).read.strip.to_i
      File.delete(@pid_path)
      true
    else
      false
    end
  end

  def daemonize!
    Process.daemon(true)
    File.open(@pid_path, File::RDWR|File::EXCL|File::CREAT, 0600) { |io| io.write(Process.pid) }
  end

  def clean
    if File.exists?(@pid_path)
      File.delete(@pid_path)
    end
  end

  def constantize(name)
    Kernel.const_get(name.split("_").push("job").map(&:capitalize).join)
  end

end
