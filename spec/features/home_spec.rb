require "rails_helper"

describe "main page tests" do
  it "Opens with text 'Флэшкарточкер'" do
    visit root_path
    expect(page).to have_content "Флэшкарточкер"
  end

  it "opens add_a_new_card_page, after clicking on link 'Добавить карточку'" do
    visit root_path
    click_link("Добавить карточку")
    expect(page).to have_content "Новая карточка"
  end

  it "opens page containing all cards, after clicking on link 'Все карточки'" do
    visit root_path
    click_link("Все карточки")
    page.has_selector?("all-cards-list")
  end
end
