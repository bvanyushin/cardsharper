require "rails_helper"

describe "main page card selection process" do
  after :each do
    DatabaseCleaner.clean
  end

  it "displays No_Card_message when there isn`t relevant cards to display" do
    # Assume that database is empty before running this test
    visit root_path
    expect(page).to have_content "Нет карточек для повторения"
  end

  it "displays a relevant card when there is one" do
    @test_card = FactoryGirl.create :card, original_text: "Правильное значение", 
                                           review_date: Date.today
    visit root_path
    expect(page).to have_content "Правильное значение"
  end

  it "selects only relevant cards to display" do
    @test_card = FactoryGirl.create :card, review_date: Date.tomorrow
    visit root_path
    expect(page).to have_content "Нет карточек для повторения"
  end
end
