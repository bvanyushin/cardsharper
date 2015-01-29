class Card < ActiveRecord::Base
  belongs_to :user
  has_attached_file :picture, styles: { medium: "360x360>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
  validates :translated_text, :original_text, :review_date,
            presence: true
  validates_with CardTextFieldsDifferenceValidator
  before_validation :set_review_date
  scope :relevant_for_today, -> { where("review_date <= ?", Time.now).order("RANDOM()") }

  def review(user_answer)
    if translated_text.strip.downcase == user_answer.strip.downcase
      update_attributes(review_date: Date.today + 3.day)
      return true
    else
      return false
    end
  end

  private

  def set_review_date
    self.review_date ||= Date.today
  end
end
