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

  scope :have_pending_cards, -> { where("review_date <= ?", Time.now).order("RANDOM()") }

  def set_deck(deck_id)
    update_attributes(current_deck_id: deck_id)
  end

  def self.notify_pending_cards 
    card_set = Card.select("user_id").where("review_date <= ?", Time.now).group("user_id")
    card_set.each do |card|
      NotificationMailer.pending_cards(card.user)
    end
  end
end
