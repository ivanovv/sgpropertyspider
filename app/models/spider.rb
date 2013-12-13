require_dependency 'list_crawler'
class Spider < ActiveRecord::Base
  def crawl
    return unless enabled?
    crawler = ListCrawler.new
    begin
      logger.info "Start parsing letter #{letter} page number #{number}"
      next_letter, next_number = crawler.parse_page(letter, number)
      self.letter = next_letter
      self.number = next_number
      if next_letter == 'AA'
        self.enabled = false
        logger.info "Spider updated:  next letter #{self.letter}, next page number #{self.number}, enabled: #{self.enabled}"
      end
      logger.info "Spider updated:  next letter #{self.letter}, next page number #{self.number}"
      save
    rescue => e
      logger.error "Got an error while parsing letter #{letter} page number #{number}"
      logger.error "The error is #{e.message}"
      raise e
    end
  end
end