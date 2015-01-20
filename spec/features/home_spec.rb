require "rails_helper"

describe "links tests" do
  it "opens add_a_new_card_page, after clicking on link 'Добавить карточку'" do
    visit "/"
    click_link("Добавить карточку")
    expect(page).to have_content "Новая карточка"
  end

  it "opens page containing all cards, after clicking on link 'Все карточки'" do
    visit "/"
    click_link("Все карточки")
    page.has_selector?("all-cards-list")
  end
end

describe "the card selection process" do
  it "displays No_Card_message if there isn`t relevant cards" do
    visit "/"
    expect(page).to have_content "Нет карточек для повторения"
  end

  it "selects only relevant cards to display" do
    @test_card = FactoryGirl.create :card, review_date: Date.tomorrow
    visit "/"
    expect(page).to have_content "Нет карточек для повторения"
  end
  DatabaseCleaner.clean
end

describe "the card review process" do
  before :each do
    @test_card = FactoryGirl.create :card
  end

  it "displays 'Правильно' if answer is valid" do
    visit "/"
    within("#review-form") do
      fill_in "user_answer", with: "Correct value"
    end
    click_button "Проверить"
    expect(page).to have_content "Правильно"
  end

  it "displays 'Неправильно' if answer is not valid" do
    visit "/"
    within("#review-form") do
      fill_in "user_answer", with: "Incorrect value"
    end
    click_button "Проверить"
    expect(page).to have_content "Неправильно"
  end
end
