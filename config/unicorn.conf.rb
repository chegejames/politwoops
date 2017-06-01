worker_processes 1
working_directory "/web/"
listen 80
preload_app true

stderr_path "/web/log/unicorn.stderr.log"
stdout_path "/web/log/unicorn.stdout.log"

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
