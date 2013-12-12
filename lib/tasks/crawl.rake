desc 'Parse next agent   page'
task :crawl => :environment do
  spider = Spider.first
  unless spider
    spider = Spider.new(:letter => 'A', :number => 1, :enabled => true)
    spider.save
  end
  spider.crawl
end
