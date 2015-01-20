require 'rails_helper'

describe CardsController do
  before :each do
    @test_card = FactoryGirl.create :card, review_date: nil
  end
  it "sets review_date for today when creates card" do
    expect(@test_card.review_date).to eql Date.today
  end
end
