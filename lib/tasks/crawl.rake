desc 'Parse next agent page'
task :crawl => :environment do
  Spider.all.each do |spider|
    puts "#{spider.id} #{spider.agent_list_url} #{spider.letter} #{spider.number}"
    begin
    spider.crawl
    rescue => e
      # do nothing
    end
  end
end
