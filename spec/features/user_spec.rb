require "rails_helper"

describe "New user" do
  it "is being created" do
    visit root_path
    click_link("Зарегистрироваться")
    fill_in "Email", with: "email"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button("Create User")
    expect(page).to have_content "User was successfully created."
  end
end
