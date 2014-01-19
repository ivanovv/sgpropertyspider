class Notificator < ActionMailer::Base
  default from: "crawler@sgproperty.com", to: "vic.ivanoff@gmail.com"

  def error(message)
    @error = message
    mail
  end

  def next_letter(spider_id, letter)
    @spider_id = spider_id
    @letter = letter
    mail
  end
end
