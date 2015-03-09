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

  describe "review process" do
    it "increment attempt counter if answer is correct" do
      card.attempt_count = 0
      card.review("Correct value")
      expect(card.attempt_count).to eql 1
    end

    it "nullify fail attempts counter if answer is correct" do
      card.failed_attempt_count = 2
      card.review("Correct value")
      expect(card.failed_attempt_count).to eql 0
    end

    it "increment fail attempts counter if answer is incorrect" do
      card.failed_attempt_count = 0
      card.review("Incorrect")
      expect(card.failed_attempt_count).to eql 1
    end

    it "nullify fail attempts counter after 3 incorrect answers" do
      card.failed_attempt_count = 2
      card.review("Incorrect")
      expect(card.failed_attempt_count).to eql 0
    end

    it "nullify attempts counter after 3 incorrect answers" do
      card.failed_attempt_count = 2
      card.attempt_count = 3
      card.review("Incorrect")
      expect(card.attempt_count).to eql 0
    end

    it "set review date 12 hours from now for 3 incorrect answers in row" do
      card.failed_attempt_count = 2
      card.attempt_count = 3
      card.review("Incorrect")
      expect(card.review_date).to be_within(20.seconds).of(Time.now + 12.hours)
    end

    describe "moves review_date for correct answer for" do
      it "12 hours from now if this is first review" do
        card.review_date = Date.today
        card.attempt_count = 0
        card.review("Correct value")
        expect(card.review_date).to be_within(20.seconds).of(Time.now + 12.hours)
      end

      it "12 hours from now if this is first review and previous date was in past" do
        card.review_date = Date.today - 1.year
        card.attempt_count = 0
        card.review("Correct value")
        expect(card.review_date).to be_within(20.seconds).of(Time.now + 12.hours)
      end

      it "3 days from now if this is second review" do
        card.review_date = Date.today
        card.attempt_count = 1
        card.review("Correct value")
        expect(card.review_date).to be_within(20.seconds).of(Time.now + 3.days)
      end

      it "1 week from now if this is third review" do
        card.review_date = Date.today
        card.attempt_count = 2
        card.review("Correct value")
        expect(card.review_date).to be_within(20.seconds).of(Time.now + 1.week)
      end

      it "2 weeks from now if this is fourth review" do
        card.review_date = Date.today
        card.attempt_count = 3
        card.review("Correct value")
        expect(card.review_date).to be_within(20.seconds).of(Time.now + 2.weeks)
      end

      it "1 month from now if this is fifth review" do
        card.review_date = Date.today
        card.attempt_count = 4
        card.review("Correct value")
        expect(card.review_date).to be_within(20.seconds).of(Time.now + 1.month)
      end
    end
  end
end
