class NotificationMailer < ApplicationMailer
  default from: ENV["CS_NOTIFICATION_FROM_EMAIL"]

  def pending_cards(user)
    @user = user
    @url  = ENV["CS_URL"]
    @sample_word = user.cards.relevant_for_today.first.original_text
    mail(to: @user.email, subject: "Как переводится #{@sample_word}?")
  end
end
