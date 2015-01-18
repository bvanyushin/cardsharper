class Card < ActiveRecord::Base
  validates :translated_text, :original_text, presence: true
  validates_with CardTextFieldsDifferenceValidator
  scope :relevant_for_today, -> { where("review_date <= ?", Time.now) } 
  scope :random_sorted, -> { order("RANDOM()") } 

  def review(user_answer)
    if translated_text == user_answer 
      days_to_move = 3
      update_attributes( { review_date: (Time.now.midnight + days_to_move.day) } )
      return "Правильно"
    else 
      return "Неправильно"
    end
  end

end
