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
      correct_answer_handler
    else
      wrong_answer_handler
    end
  end

  private

  def set_review_date
    self.review_date ||= Time.now
  end

  def correct_answer_handler
    self.attempt_count += 1
    self.failed_attempt_count = 0
    case self.attempt_count
    when 1
      addition = 12.hours
    when 2
      addition = 3.days
    when 3
      addition = 7.days
    when 4
      addition = 14.days
    else
      addition = 1.month
    end
    update_attributes(review_date: Time.now + addition)
    true
  end

  def wrong_answer_handler
    self.failed_attempt_count += 1
    if self.failed_attempt_count >= 3
      self.attempt_count = 0
      self.failed_attempt_count = 0
      update_attributes(review_date: Time.now + 12.hours)
    end
    false
  end
end
