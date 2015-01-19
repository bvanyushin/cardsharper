require 'rails_helper'

RSpec.describe CardsController, :type => :controller do
  it "sets review_date for today when creates card" do
    test_card = Card.create(:original_text => "Тест", :translated_text => "test")
    expect(test_card.review_date).to eql Date.today
  end
end
