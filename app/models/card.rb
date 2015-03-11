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
    if percolate_text(translated_text) == percolate_text(user_answer)
      handle_correct_answer
    else
      handle_wrong_answer
    end
  end

  private

  def set_review_date
    self.review_date ||= Time.now
  end

  def percolate_text(str)
    str.mb_chars.strip.downcase
  end

  def handle_correct_answer
    self.attempt_count += 1
    addition = case self.attempt_count
               when 1
                12.hours
               when 2
                 3.days
               when 3
                 7.days
               when 4
                 14.days
               else
                 1.month
              end
    update_attributes(review_date: Time.now + addition,
                      failed_attempt_count: 0)
  end

  def handle_wrong_answer
    if (self.failed_attempt_count += 1) >= 3
      update_attributes(review_date:   Time.now + 12.hours,
                        attempt_count: 0,
                        failed_attempt_count: 0)
    end
    false
  end
end
