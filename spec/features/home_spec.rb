require "rails_helper"

describe "main page tests" do
  let(:user) { FactoryGirl.create :user }
  
  it "Opens with text 'Флэшкарточкер'" do
    visit root_path
    expect(page).to have_content "Флэшкарточкер"
  end

  it "opens a new card page, after clicking on link 'Добавить карточку'" do
    visit root_path
    click_link("Добавить карточку")
    expect(page).to have_content "Новая карточка"
  end

  it "opens page containing all cards, after clicking on link 'Все карточки'" do
    visit root_path
    click_link("Все карточки")
    expect(page).to have_content "Список всех карточек"
  end

  describe "card review process" do
    before :each do
      @test_card = FactoryGirl.create :card, translated_text: "Correct value", user_id: user.id
    end

    it "displays success message if answer is valid" do
      visit root_path
      within("#review-form") do
        fill_in "user_answer", with: "Correct value"
      end
      click_button "Проверить"
      expect(page).to have_content "Правильно"
    end

    it "displays error message if answer is not valid" do
      visit root_path
      within("#review-form") do
        fill_in "user_answer", with: "Incorrect value"
      end
      click_button "Проверить"
      expect(page).to have_content "Неправильно"
    end
  end

  describe "card selection process" do
    after :each do
      DatabaseCleaner.clean
    end

    it "displays No Card message when there isn`t relevant cards to display" do
      # Assume that database is empty before running this test
      visit root_path
      expect(page).to have_content "Нет карточек для повторения"
    end

    it "displays a relevant card when there is one" do
      @test_card = FactoryGirl.create :card, original_text: "Правильное значение", 
                                             review_date: Date.today,
                                             user_id: user.id
      visit root_path
      expect(page).to have_content "Правильное значение"
    end

    it "selects only relevant cards to display" do
      @test_card = FactoryGirl.create :card, review_date: Date.tomorrow, 
                                             user_id: user.id
      visit root_path
      expect(page).to have_content "Нет карточек для повторения"
    end
  end
end
