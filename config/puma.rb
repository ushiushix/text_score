pidfile './tmp/puma.pid'
state_path './tmp/puma.state'
workers 0
threads 0, 16
bind 'tcp://0.0.0.0:8080'
stdout_redirect './log/puma.stdout.log', './log/puma.stderr.log'

before_fork do
  require 'puma_worker_killer'
  PumaWorkerKiller.enable_rolling_restart # Default is every 6 hours
end
