require_dependency 'crawler_factory'
class Spider < ActiveRecord::Base
  has_many :agents

  def crawl
    return unless enabled?

    attempt = CrawledPage.find_or_create_by!(:spider => self, :letter => letter, :number => number)
    attempt.update(:started_at => DateTime.now)
    start_time = Time.now

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
        next_message = "Spider updated:  next letter #{self.letter}, next page number #{self.number}, enabled: #{self.enabled}"
      end
      logger.info next_message
      save
      attempt.update(:finished_at => DateTime.now,
                     :duration => (Time.now - start_time).to_i)
    rescue => e
      error_message = "Spider # #{id}. Got an error while parsing letter #{letter} page number #{number}\nThe error is #{e.message}\nStack: #{e.backtrace.join("\n")}"
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
        Notificator.next_letter(self.id, next_letter).deliver
      rescue => e
        logger.error e.message
      end
    end
  end

end