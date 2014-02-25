set :output, '/home/deploy/apps/sgpropertyspider/shared/log/cron.log'
set :bundle_command, 'chruby-exec 2.1 -- bundle exec'

env :SHELL, '/bin/bash'
env :HOME, '/home/deploy'
env :PATH, '/bin:/usr/bin:/usr/local/bin'

every 12.minutes do
  rake 'crawl'
end

