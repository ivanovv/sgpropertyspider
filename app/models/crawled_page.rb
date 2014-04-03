class CrawledPage < ActiveRecord::Base
  belongs_to :spider

  def self.find_or_create_attempt(spider)
    month = Date::MONTHNAMES[Date.today.month]
    attempt = CrawledPage.find_or_create_by!({
                                                 :spider => spider,
                                                 :letter => spider.letter,
                                                 :number => spider.number,
                                                 :month => month,
                                                 :year => Date.today.year
                                             })
    attempt.update(:started_at => DateTime.now)
    attempt
  end
end