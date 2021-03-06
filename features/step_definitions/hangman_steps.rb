require 'capybara/cucumber'
require 'sinatra'
require 'hangman_interface'

Capybara.app = Sinatra::Application
Sinatra::Application::settings.environment = 'test'
Sinatra::Application.set :root, "./lib"

Given(/^a correct letter$/) do
  visit "/hangman"
end

When(/^the player guesses the correct letter$/) do
  fill_in("guess", :with => 'H')
  click_button("submit")
end

Then(/^the letter should be revealed in the answer$/) do
  page.has_content?("H _ _ _ _ _ _") 
end

Given(/^an incorrect letter$/) do
  visit "/hangman"
end

When(/^the player guesses the incorrect letter$/) do
  fill_in("guess", :with => 'T')
  click_button("submit")
end

Then(/^the letter should go into the trash$/) do
  page.should have_content("")
end

Then(/^the player should lose a life$/) do
  page.should have_content("Lives: 2")
end

Given(/^the player has three lives left$/) do
  visit "/hangman"
end

When(/^the player guesses incorrectly several times$/) do
  fill_in("guess", :with => 'T')
  click_button("submit")
  fill_in("guess", :with => 'B')
  click_button("submit")
  fill_in("guess", :with => 'Z')
  click_button("submit")
end

Then(/^the game should be over$/) do
 page.should have_content("UNLUCKY YOU HAVE LOST!")
end

Given(/^there is only one letter left to guess$/) do
  visit "/hangman"
end

When(/^the player guesses the letter correctly$/) do
  fill_in("guess", :with => 'H')
  click_button("submit")
  fill_in("guess", :with => 'A')
  click_button("submit")
  fill_in("guess", :with => 'N')
  click_button("submit")
  fill_in("guess", :with => 'G')
  click_button("submit")
  fill_in("guess", :with => 'M')
  click_button("submit")
end

Then(/^the game should be won$/) do
  page.should have_content("CONGRATULATIONS YOU HAVE WON!")
end

Given(/^a letter has already been guessed correctly$/) do
  visit "/hangman"
  fill_in("guess", :with => 'A')
  click_button("submit")
end

When(/^the player guesses that letter again$/) do
  fill_in("guess", :with => 'A')
  click_button("submit")
end

Then(/^the player will not lose a life$/) do
  page.should have_content("Lives: 3")
end

Given(/^a letter has already been guessed incorrectly$/) do
  visit "/hangman"
  fill_in("guess", :with => 'Z')
  click_button("submit")
end

When(/^the player guesses the incorrect letter again$/) do
  fill_in("guess", :with => 'Z')
  click_button("submit")
end

Then(/^the player will lose a life$/) do
  page.should have_content("Lives: 1")
end

# World(Helper)