desc "Parse next agent   page"
task :crawl => :environment do
  spider = Spider.find 1
  spider.crawl
end
