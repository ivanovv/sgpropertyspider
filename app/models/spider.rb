require_dependency 'crawler_factory'
class Spider < ActiveRecord::Base
  def crawl
    return unless enabled?
    crawler = CrawlerFactory.create_crawler_for(self.agent_list_url, self.id)
    begin
      logger.info "Start parsing letter #{letter} page number #{number}"
      next_letter, next_number = crawler.parse_page(letter, number)

      send_next_letter_notification(next_letter)

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
      error_message ="Spider # #{id}. Got an error while parsing letter #{letter} page number #{number}\nThe error is #{e.message}"
      logger.error error_message

      begin
        Notificator.error(error_message).deliver
      rescue => e2
        logger.error e2.message
      end

      raise e
    end
  end

  def send_next_letter_notification (next_letter)
    if next_letter != self.letter
      begin
        Notificator.next_letter(next_letter).deliver
      rescue => e
        logger.error e.message
      end
    end
  end

end