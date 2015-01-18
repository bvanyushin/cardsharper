class Card < ActiveRecord::Base
  validates :translated_text, :original_text, presence: true
  validates_with CardTextFieldsDifferenceValidator
  scope :relevant_for_today, -> { where("review_date <= ?", Time.now) } 
  scope :random_sorted, -> { order("RANDOM()") } 

  def move_review_date!(days_to_move = 3)
    self.review_date = Time.now.midnight + days_to_move.day
    save
  end

  def answer_correct?(user_answer)
    translated_text == user_answer
  end
end
