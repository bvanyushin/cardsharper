class User < ActiveRecord::Base
  authenticates_with_sorcery!

  validates  :password, length: { minimum: 3 }
  validates  :password, confirmation: true
  validates  :password_confirmation, presence: true

  validates  :email, uniqueness: true

  has_many   :cards, dependent: :destroy
  has_many   :decks, dependent: :destroy

  belongs_to :current_deck

  def set_current_deck(deck)
    update_attributes(current_deck: deck)
  end
end
