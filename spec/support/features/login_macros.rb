require "rails_helper"
require 'capybara/rails'

module LoginMacros
  def LoginMacros.login_user
    visit root_path
    click_link("Войти")
    within("#login-form") do
      fill_in "email", with: user.email
      fill_in "password", with: "password"
    end
    click_button "Войти"
  end
end
