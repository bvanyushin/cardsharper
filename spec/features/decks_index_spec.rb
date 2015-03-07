require "rails_helper"

describe "list of decks page tests" do
  let(:user) { FactoryGirl.create :user, password: "password" }
  let(:deck) { FactoryGirl.create :deck, title: "title" }

  before :each do
    visit root_path
    LoginMacros.login_user
    visit decks_path
  end

  it "do not allow to delete current deck" do
    @test_deck = FactoryGirl.create :deck, user_id: user.id
    visit decks_path
    click_link("Сделать текущей")
    expect(page).not_to have_content "Удалить"
  end
end
