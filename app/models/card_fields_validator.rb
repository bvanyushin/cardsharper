class CardFieldsValidator < ActiveModel::Validator
  def validate(card)
    if card.original_text == card.translated_text
      card.errors[:base] << "Fields must have different values."
    end
  end
end
