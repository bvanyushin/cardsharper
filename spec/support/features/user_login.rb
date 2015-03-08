def login_user(email, password)
  visit root_path
  click_link("Войти")
  within("#login-form") do
    fill_in "email", with: email
    fill_in "password", with: "password"
  end
  click_button "Войти"
end
