require_dependency 'list_crawler'
class Spider < ActiveRecord::Base
  def crawl
    return unless enabled?
    crawler = ListCrawler.new
    begin
      next_letter, next_number = crawler.parse_page(letter, number)
      self.letter = next_letter
      self.number = next_number
      self.enabled = false if next_letter == 'AA'
      save
    rescue => e
      logger.error "Got an error while parsing letter #{letter} page number #{number}"
      logger.error "The error is #{e.message}"
      raise e
    end
  end
end