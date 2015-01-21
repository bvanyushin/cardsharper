require "rails_helper"

describe "main page card selection and review process" do
  before :each do
    @test_card = FactoryGirl.create :card, translated_text: "Correct value"
  end

  it "displays 'Правильно' if answer is valid" do
    visit root_path
    within("#review-form") do
      fill_in "user_answer", with: "Correct value"
    end
    click_button "Проверить"
    expect(page).to have_content "Правильно"
  end

  it "displays 'Неправильно' if answer is not valid" do
    visit root_path
    within("#review-form") do
      fill_in "user_answer", with: "Incorrect value"
    end
    click_button "Проверить"
    expect(page).to have_content "Неправильно"
  end
end
