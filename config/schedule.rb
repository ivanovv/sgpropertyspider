set :output, "/home/deploy/apps/sgpropertyspider/shared/logs/cron.log"

every 2.minutes do
  rake "crawl"
end

