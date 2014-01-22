set :output, '/home/deploy/apps/sgpropertyspider/shared/log/cron.log'

every 12.minutes do
  rake 'crawl'
end

