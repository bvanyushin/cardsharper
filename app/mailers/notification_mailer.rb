class NotificationMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def pending_cards(user)
    @user = user
    @url  = "http://cardsharper.herokuapp.com/"
    @sample_word = user.cards.relevant_for_today.first.original_text
    mail(to: @user.email, subject: "Как переводится #{@sample_word}?")
  end
end
