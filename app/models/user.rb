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

  def set_deck(params)
    update_attributes(current_deck_id: params[:current_deck_id])
  end
end
