class CardTextFieldsDifferenceValidator < ActiveModel::Validator
  def validate(card)
    if card.original_text.mb_chars.strip.downcase == card.translated_text.mb_chars.strip.downcase
      card.errors[:base] << "Fields must have different values."
    end
  end
end
