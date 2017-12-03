pidfile './tmp/puma.pid'
state_path './tmp/puma.state'
threads 0, 16
bind 'tcp://0.0.0.0:8080'
rackup 'config/config.puma.ru'
stdout_redirect './log/puma.stdout.log', './log/puma.stderr.log'
