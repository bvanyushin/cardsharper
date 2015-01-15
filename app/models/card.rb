class Card < ActiveRecord::Base
  validates :translated_text, :original_text,  presence: true
  validates_with CardTextFieldsDifferenceValidator
end
