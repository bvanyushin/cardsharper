class Deck < ActiveRecord::Base
  belongs_to :user
  validates :title, presence: true

  has_many :cards, dependent: :destroy

  def current? user_id
    return self.id == user.current_deck_id
  end
end
