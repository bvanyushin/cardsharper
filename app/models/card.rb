class Card < ActiveRecord::Base
  validates :translated_text, :original_text, presence: true
  validates_with CardTextFieldsDifferenceValidator
  scope :actual_on, -> due_date { where("review_date <= ?", due_date) } 

  def move_review_date!(days_to_move = 3)
    self.review_date = Time.now.midnight + days_to_move.day
    self.save
  end

  def answer_correct?(user_answer)
    self.translated_text == user_answer
  end
end
