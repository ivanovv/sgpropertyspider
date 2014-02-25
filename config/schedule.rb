set :output, '/home/deploy/apps/sgpropertyspider/shared/log/cron.log'

env :SHELL, '/bin/bash'
env :HOME, '/home/deploy'
env :PATH, '/bin:/usr/bin:/usr/local/bin'

every 12.minutes do
  rake 'crawl'
end

