require "rails_helper"

RSpec.describe Card, :type => :model do
  test_card = Card.create(:original_text => "Тест", 
                          :translated_text => "test ")

  it "checks for correct translation without capitalization, 
  leading and trailing spaces" do  
    expect(test_card.review(" tESt   ")).to eql true
  end

  it "checks for correct translation" do
    expect(test_card.review("not test")).to eql false
  end

  it "moves the review date if answer is correct 3 days from today" do
    test_card.review_date = nil
    test_card.review("test")
    expect(test_card.review_date).to eql Date.today + 3.days
  end
end