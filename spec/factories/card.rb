FactoryGirl.define do
  factory :card do
    original_text "Правильное значение"
    translated_text "Correct Value"
    review_date Date.today
  end
end
