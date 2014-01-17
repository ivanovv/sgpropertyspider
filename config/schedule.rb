set :output, '/home/deploy/apps/sgpropertyspider/shared/log/cron.log'

every 10.minutes do
  rake 'crawl'
end

