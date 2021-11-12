@env = ARGV[1].nil? ? 'development' : ARGV[1]
task @env do ;  end unless ARGV[1].nil?

desc "Run tests"
task test: [ "test:all" ]

namespace :test do
  desc "Run unit tests"
  task :unit do
    Dir["test/unit/*_test.rb"].each do |f|
      load f
    end
  end

  desc "Run all tests"
  task :all => [:unit]
end
