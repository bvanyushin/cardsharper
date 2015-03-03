require "rails_helper"
  
describe "main page tests" do
  let(:user) { FactoryGirl.create :user, email: "unique@example.com",
                                         password: "password" }
  let(:deck) { FactoryGirl.create :deck, title: "title" }
  let(:second_user) { FactoryGirl.create :user }
  let(:card) { FactoryGirl.create :card, translated_text: " Correct value ",
                                         user_id: user.id,
                                         deck_id: deck_id }
  def login_user
    click_link("Войти")
    within("#login-form") do
      fill_in "email", with: user.email
      fill_in "password", with: "password"
    end
    click_button "Войти"
  end

  before :each do
    visit root_path
    login_user
  end

  it "displays successfully login message" do
    expect(page).to have_content "Login successful"
  end

  it "logout link works" do 
    click_link("Выйти")
    expect(page).to have_content "Войти"
  end

  it "edit profile link works" do 
    click_link("Редактировать профиль")
    expect(page).to have_content "Editing User"
  end

  it "Redirects to source page after login" do
    expect(page).to have_content "Флэшкарточкер"
  end

  it "opens a new card page, after clicking on link 'Добавить карточку'" do
    click_link("Добавить карточку")
    expect(page).to have_content "Новая карточка"
  end

  it "opens page containing all cards, after clicking on link 'Все карточки'" do
    click_link("Все карточки")
    expect(page).to have_content "Список всех карточек"
  end

  describe "card review process" do
    before :each do
      @test_card = FactoryGirl.create :card, original_text: "Правильное значение",
                                             translated_text: "Correct value",
                                             deck_id: deck.id,
                                             user_id: user.id
      visit root_path
    end

    it "displays success message if answer is valid" do
      within("#review-form") do
        fill_in "user_answer", with: "Correct value"
      end
      click_button "Проверить"
      expect(page).to have_content "Правильно"
    end

    it "displays error message if answer is not valid" do
      within("#review-form") do
        fill_in "user_answer", with: "Incorrect value"
      end
      click_button "Проверить"
      expect(page).to have_content "Неправильно"
    end
  end

  describe "card selection process with no current deck chosen" do
    after :each do
      DatabaseCleaner.clean
    end

    it "displays No Card message when there isn`t relevant cards to display" do
      # Assume that database has no cards before running this test  
      expect(page).to have_content "Нет карточек для повторения"
    end

    it "displays a relevant card when there is one" do
      @test_card = FactoryGirl.create :card, original_text: "Правильное значение", 
                                             review_date: Date.yesterday,
                                             deck_id: deck.id,
                                             user_id: user.id
      visit root_path
      expect(page).to have_content "Правильное значение"
    end

    it "selects only relevant cards to display" do
      @test_card = FactoryGirl.create :card, review_date: Date.tomorrow,
                                             deck_id: deck.id,
                                             user_id: user.id
      expect(page).to have_content "Нет карточек для повторения"
    end

    it "Doesn`t show cards of other user" do
      @test_card = FactoryGirl.create :card, review_date: Date.today,
                                             deck_id: deck.id,
                                             user_id: second_user.id
      expect(page).to have_content "Нет карточек для повторения"
    end
  end

  describe "card selection process with current deck chosen" do
    let(:alter_deck) { FactoryGirl.create :deck, title: "alter_title",
                                                 user_id: user.id }

    it "displays No Card message when there are no relevant cards in current deck" do
      
      @test_deck = FactoryGirl.create :deck, title: "Title", 
                                             user_id: user.id
      visit decks_path
      click_link('Сделать текущей')
      @test_card = FactoryGirl.create :card, original_text: "Правильное значение", 
                                             review_date: Date.yesterday,
                                             deck_id: alter_deck.id,
                                             user_id: user.id
      visit root_path

      expect(page).to have_content "Нет карточек для повторения"
    end

    it "displays Card when there are relevant cards to display in current deck" do
      
      @test_deck = FactoryGirl.create :deck, title: "Title", 
                                             user_id: user.id
      visit decks_path
      click_link('Сделать текущей')
      @test_card = FactoryGirl.create :card, original_text: "Правильное значение", 
                                             review_date: Date.yesterday,
                                             deck_id: @test_deck.id,
                                             user_id: user.id
      visit root_path

      expect(page).to have_content "Правильное значение"
    end
  end
end
