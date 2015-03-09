class Card < ActiveRecord::Base
  has_attached_file :picture,
                    styles: { medium: "360x360>" },
                    default_url: "/images/:style/missing.png"

  before_validation :set_review_date

  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
  validates :translated_text, :original_text, :review_date, :deck_id,
            presence: true
  validates_with CardTextFieldsDifferenceValidator

  belongs_to :user
  belongs_to :deck

  scope :relevant_for_today, -> { where("review_date <= ?", Time.now).order("RANDOM()") }

  def review(user_answer)
    if translated_text.mb_chars.strip.downcase == user_answer.mb_chars.strip.downcase
      attempt_count += 1
      failed_attempt_count = 0
      # Case Block to set value of addition
      update_attributes(review_date: Date.today + addition)
      return true
    else
      failed_attempt_count += 1
      if failed_attempt_count >= 3 
        attempt_count = 1
        failed_attempt_count = 0
      end
      return false
    end
  end

  private

  def set_review_date
    self.review_date ||= Date.today
  end
end
