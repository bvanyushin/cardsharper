class Card < ActiveRecord::Base
  TYPOS_ALLOWED = 1
  
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
    reference = percolate_text(translated_text)
    answer = percolate_text(user_answer)
    if Levenshtein.distance(reference, answer) <= TYPOS_ALLOWED
      handle_correct_answer
      true
    else
      handle_wrong_answer
      false
    end
  end

  private

  def set_review_date
    self.review_date ||= Time.now
  end

  def percolate_text(str)
    str.mb_chars.strip.downcase.to_s
  end

  def handle_correct_answer
    increment(:attempt_count)
    addition = case attempt_count
               when 1 then 12.hours
               when 2 then 3.days
               when 3 then 7.days
               when 4 then 14.days
               else
                 1.month
               end
    update_attributes(review_date: Time.now + addition,
                      failed_attempt_count: 0)
  end

  def handle_wrong_answer
    increment(:failed_attempt_count)
    if failed_attempt_count >= 3
      update_attributes(review_date: Time.now + 12.hours,
                        attempt_count: 0,
                        failed_attempt_count: 0)
    end
  end
end
