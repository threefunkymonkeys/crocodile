require 'logger'

class CrocodileJob
  def self.message
    "Running..."
  end

  def self.interval
    raise RuntimeError.new("Must reimplement self.interval in a subclass")
  end

  def self.run
    raise RuntimeError.new("Must reimplement self.interval in a subclass")
  end

  def self.one_run_only
    false
  end

  def self.logger
    @@logger ||= Logger.new(STDOUT)
  end
end
