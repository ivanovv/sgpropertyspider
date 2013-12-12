require_dependency 'list_crawler'
class Spider < ActiveRecord::Base
  def crawl
    return unless enabled?
    crawler = ListCrawler.new
    next_letter, next_number = crawler.parse_page(letter, number)
    letter = next_letter
    number = next_number
    save
  end
end