class Deck < ActiveRecord::Base
  belongs_to :user
  validates :title, presence: true

  has_many :cards, dependent: :destroy

  def current? user
    self.id == user.current_deck_id
  end
end
