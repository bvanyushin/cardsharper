class Deck < ActiveRecord::Base
  belongs_to :user
  validates  :title, presence: true

  has_many   :cards, dependent: :destroy

  def set_current
    update_attributes(is_current: true)
  end
end
