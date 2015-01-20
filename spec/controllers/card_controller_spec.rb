require 'rails_helper'

describe CardsController do
  before :each do
    @test_card = Card.create(original_text: "Правильное значение", 
                            translated_text: "Correct value")
  end
  it "sets review_date for today when creates card" do
    expect(@test_card.review_date).to eql Date.today
  end
end
