require 'rails_helper'

feature "Signing in" do
  fixtures :users
  before :each do
  #  User.new(:email => 'admin@yoursite.net', :password => 'Pa55word')
    Capybara.reset_sessions!
  end

  scenario "Signing in as a valid user" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => 'admin@yoursite.net'
      fill_in 'user_password', :with => 'Pa55word'
    end
    click_button 'Sign in'
    expect(page).to have_content 'successfully'
  end
  scenario "Signing in as an invalid user" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => 'bogus@yoursite.net'
      fill_in 'user_password', :with => 'bogus'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Invalid'
  end

  scenario "check 'Remember me'" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => 'admin@yoursite.net'
      fill_in 'user_password', :with => 'Pa55word'
      check 'user_remember_me'
    end
    click_button 'Sign in'
    expect(page).to have_content 'successfully'
    remember_token = Capybara.current_session.driver.request.cookies['remember_user_token']
    expect(remember_token).to_not be_nil
    Capybara.reset_sessions!
    page.driver.browser.set_cookie("remember_user_token=#{remember_token}")
    visit('/')
    expect(page).to have_content 'Sign Out'
  end

  scenario "'Remember me' not checked." do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'user_email', :with => 'admin@yoursite.net'
      fill_in 'user_password', :with => 'Pa55word'
    end
    click_button 'Sign in'
    expect(page).to have_content 'successfully'
    remember_token = Capybara.current_session.driver.request.cookies['remember_user_token']
    expect(remember_token).to be_nil
    #expect(page).to have_content 'Sign Out'
  end
end

feature "Signing up" do
  scenario "Signing up as a new user" do
    visit '/users/sign_up'
    within("#new_user") do
      fill_in 'user_email', :with => 'bogus@yoursite.net'
      fill_in 'user_password', :with => 'B0gusPa55word'
      fill_in 'user_password_confirmation', :with => 'B0gusPa55word'
    end
    click_button 'Sign up'
    expect(page).to have_content 'successfully'
  end
  scenario "with a too short password" do
    visit '/users/sign_up'
    within("#new_user") do
      fill_in 'user_email', :with => 'bogus@yoursite.net'
      fill_in 'user_password', :with => 'B0gus'
      fill_in 'user_password_confirmation', :with => 'B0gus'
    end
    click_button 'Sign up'
    expect(page).to have_content 'Password is too short'
  end
  scenario "with a mismatched password" do
    visit '/users/sign_up'
    within("#new_user") do
      fill_in 'user_email', :with => 'bogus@yoursite.net'
      fill_in 'user_password', :with => 'B0gus123'
      fill_in 'user_password_confirmation', :with => 'Bogus123'
    end
    click_button 'Sign up'
    expect(page).to have_content 'Password confirmation doesn\'t match Password Email Password'
  end

end