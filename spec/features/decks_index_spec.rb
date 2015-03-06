require "rails_helper"

describe "list of decks page tests" do
  let(:user) { FactoryGirl.create :user, password: "password" }
  let(:deck) { FactoryGirl.create :deck, title: "title" }

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
    visit decks_path
  end

  it "do not allow to delete current deck" do
    @test_deck = FactoryGirl.create :deck, title: "Title",
                                           user_id: user.id
    visit decks_path
    click_link("Сделать текущей")
    expect(page).not_to have_content "Удалить"
  end
end
