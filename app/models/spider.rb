require_dependency 'list_crawler'
class Spider < ActiveRecord::Base
  def crawl
    return unless enabled?
    crawler = ListCrawler.new
    begin
      logger.info "Start parsing letter #{letter} page number #{number}"
      next_letter, next_number = crawler.parse_page(letter, number)

      if next_letter != self.letter
        begin
          Notificator.next_letter(next_letter).deliver
        rescue => e
          logger.error e.message
        end
      end

      self.letter = next_letter
      self.number = next_number

      next_message = "Spider updated:  next letter #{self.letter}, next page number #{self.number}"
      if next_letter == 'AA'
        self.enabled = false
        next_message =  "Spider updated:  next letter #{self.letter}, next page number #{self.number}, enabled: #{self.enabled}"
      end
      logger.info next_message
      save
    rescue => e
      error_message ="Got an error while parsing letter #{letter} page number #{number}\nThe error is #{e.message}"
      logger.error error_message

      begin
        Notificator.error(error_message).deliver
      rescue => e
        logger.error e.message
      end

      raise e
    end
  end
end