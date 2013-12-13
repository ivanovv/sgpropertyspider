class Notificator < ActionMailer::Base
  default from: "crawler@sgproperty.com", to: "vic.ivanoff@gmail.com"

  def error(message)
    @error = error
    mail
  end

  def next_letter(letter)
    @letter = letter
    mail
  end
end
