require "rails_helper"

describe Card do
  let(:user) { FactoryGirl.create :user }
  let(:deck) { FactoryGirl.create :deck, title: "title" }
  let(:card) { FactoryGirl.create :card, translated_text: " Correct value ",
                                         user_id: user.id,
                                         deck_id: deck.id
  }

  it "checks for correct translation without capitalization, leading and trailing spaces" do
    expect(card.review("  Correct vaLUe")).to be true
  end

  it "checks for correct translation" do
    expect(card.review("Incorrect value")).to be false
  end

  it "moves the review date if answer is correct 3 days from today if review date is today" do
    card.review_date = Date.today
    card.review("Correct value")
    expect(card.review_date).to eql Date.today + 3.day
  end

  it "moves the review date if answer is correct 3 days from today for any date in past" do
    card.review_date = Date.yesterday
    card.review("Correct value")
    expect(
      card.review_date).to eql Date.today + 3.day
  end
end
