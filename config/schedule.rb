set :output, '/home/deploy/apps/sgpropertyspider/shared/log/cron.log'

every 20.minutes do
  rake 'crawl'
end

