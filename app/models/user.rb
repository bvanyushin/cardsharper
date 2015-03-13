class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates :password, length: { minimum: 3 }, if: "new_record? || password.present?"
  validates :password, confirmation: true,     if: "new_record? || password.present?"
  validates :password_confirmation, presence: true, if: "new_record? || password.present?"

  validates :email, uniqueness: true

  has_many :cards, dependent: :destroy
  has_many :decks, dependent: :destroy

  belongs_to :current_deck, class_name: "Deck",
                            foreign_key: "current_deck_id"

  def set_deck(deck_id)
    update_attributes(current_deck_id: deck_id)
  end

  def self.notify_cards
    mail_list = []
    users.each do |user|
      if user.cards.relevant_for_today.first.present
        mail_list.push(user)
      end
    end
    mail_list.each do |user|
      NotificationsMailer.pending_cards(user)
    end
  end
end
