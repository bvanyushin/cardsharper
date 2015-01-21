require "rails_helper"

describe Card do
  before :each do
    @test_card = FactoryGirl.create :card, translated_text: " Correct value "
  end

  it "checks for correct translation without capitalization, leading and trailing spaces" do
    expect(@test_card.review("  Correct vaLUe")).to be_true
  end

  it "checks for correct translation" do
    expect(@test_card.review("Incorrect value")).to eql false
  end

  it "moves the review date if answer is correct 3 days from today if review date is today" do
    @test_card.review_date = Date.today
    @test_card.review("Correct value")
    expect(@test_card.review_date).to eql Date.today + 3.day
  end

  it "moves the review date if answer is correct 3 days from today for any date in past" do
    @test_card.review_date = Date.yesterday
    @test_card.review("Correct value")
    expect(@test_card.review_date).to eql Date.today + 3.day
  end
end
