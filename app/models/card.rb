class CardFieldsValidator < ActiveModel::Validator
  def validate(card)
    if card.original_text == card.translated_text
      card.errors[:base] << "Fields must have different values."
    end
  end
end

class Card < ActiveRecord::Base
  validates :original_text, presence: true
  validates :translated_text, presence: true
  validates_with CardFieldsValidator

end
