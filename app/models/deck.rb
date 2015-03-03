class Deck < ActiveRecord::Base
  belongs_to :user
  validates  :title, presence: true

  has_many   :cards, dependent: :destroy
end
