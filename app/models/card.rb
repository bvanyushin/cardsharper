class Card < ActiveRecord::Base
  validates :translated_text, :original_text, presence: true
  validates_with CardTextFieldsDifferenceValidator
  after_create :set_review_date
  scope :relevant_for_today, -> { where("review_date <= ?", Time.now).order("RANDOM()") }
  
  def review(user_answer)
    if translated_text.strip.downcase == user_answer.strip.downcase
      update_attributes(review_date: Time.now.midnight + 3.day)
      return true
    else
      return false
    end
  end

  private

  def set_review_date
    update_attributes(review_date: Time.now.midnight)
  end
end
