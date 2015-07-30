##Crocodile

Crocodile is a [gem](https://rubygems.org/gems/crocodile) for running periodic [background] jobs written in Ruby.
Crocodile provides a worker binary that's in charge of running the jobs you define, it also provides a base class for those jobs.

###Install

```
gem install crocodile
```

###Jobs

Crocodile is based on some conventions for running your jobs:

* It will look for the jobs files in the `jobs` directory of your application
* The job file name is the name of the job to run
* The job class name must be the filename ending in `Job`, so if your file is `dummy.rb`, the class defined inside the file must be `DummyJob`.

Your job class must respond to an interface in order to be ran by crocodile, for this, Crocodile provides the `CrocodileJob` class for you to inherit from there.

However, the interface is very simple, you can write your own class and forget about CrocodileJob as long as:

* You have a class method `YourClass#message` that returns a string
* You have a class method `YourClass#interval` that returns an integer which indicates, in seconds, how often your job will be ran
* You have a class method `YourClass#one_run_only` that returns a boolean indicating if crocodile has to run it only once
* You have a class method `YourClass#logger` that returns a `Logger` object
* You have a class method `YourClass#run` that implements the logic of your job

If you use the `CrocodileJob` as the base class, you only need to reimplement:

* `CrocodileJob#interval`
* `CrocodileJob#run`

The default logger will log to `STDOUT`, if you want to log to a file, reimplement `CrocodileJob#logger` with something like `Logger.new("jobs/logs/dummy.log")`

###Example

Suppose you have an application, let's say `dummy_app` and you need to run periodic background jobs on it.
Go to the `dummy_app` dir and create the necessary directories:

```
mkdir -p jobs/pids
```

Then define a dummy job for your dummy app:

```Ruby
# file: jobs/dummy.rb

require 'crocodile'

class DummyJob < CrocodileJob
  def self.interval
    ENV['DUMMY_JOB_INTERVAL'] || 10
  end

  def self.run
    puts "Look ma, I'm running!!"
  end
end
```

Once the job is defined, go to the terminal and run it:

```
crocodile dummy start
```

You will see the output of the `run` method every 10 seconds. If you want to override the interval, just export the evn var:

```
DUMMY_JOB_INTERVAL=3 crocodile dummy start
```

This is useful for testing your job works correcly, however, it won't be very useful when you need to run it in a server, since you will want to log out from the server and keep the job running, so you need to _daemonize_ your job. Also, to keep track of what your job is doing, you might want to use a log file:

```Ruby
# file: jobs/dummy.rb

require 'crocodile'

class DummyJob < CrocodileJob
  def self.interval
    ENV['DUMMY_JOB_INTERVAL'] || 10
  end

  def self.run
    puts "Look ma, I'm running!!"
  end

  def self.logger
    Logger.new("/tmp/dummy.log")
  end
end
```

Then, run it as a daemon:

```
crocodile -d dummy start
```

Now you can check the file `/tmp/dummy.log` for the output of your job at any given time.

The file `jobs/pids/dummy.pid` will show the PID of the running job.

If you need to stop the job, you do it through command line as well:

```
crocodile dummy stop
```

If you need just schedule the job instead to run it immediately, you do it through command line as well:

```
crocodile dummy schedule
```

By default job will be scheduled to start after `interval`.

If you want to schedule your job to start at certain hour you can redefine `start_at` method with format `hh:mm`:

```
class DummyJob < CrocodileJob
  def self.start_at
    "05:00"
  end
end

crocodile dummy schedule
```

When `start_at` is defined your job will start working at `start_at` and will execute each `interval`.

So, that's pretty much it. We hope you enjoy it.

###How to collaborate

If you find a bug or want to collaborate with the code, you can:

* Report issues trhough the issue tracker
* Fork the repository into your own account and submit a Pull Request

