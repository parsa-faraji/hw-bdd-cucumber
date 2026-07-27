# Add a declarative step for populating the database with movies.

Given(/^the following movies exist:$/) do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then(/^(\d+) seed movies should exist$/) do |n_seeds|
  expect(Movie.count).to eq(n_seeds.to_i)
end

# Ensure that one movie occurs before another in the displayed movie list.
# This matches steps both with and without "in the movie list".

Then(
  /^I should see "([^"]*)" before "([^"]*)"(?: in the movie list)?$/
) do |first_movie, second_movie|
  movie_list = page.find("#movies").text

  expect(movie_list).to include(first_movie)
  expect(movie_list).to include(second_movie)

  expect(movie_list.index(first_movie)).to be < movie_list.index(second_movie)
end

# Check several rating boxes at once.
# This checks only the specified ratings and leaves other boxes unchanged.

When(/^I check the following ratings: (.*)$/) do |rating_list|
  rating_list.split(/\s*,\s*/).each do |rating|
    check(rating)
  end
end

# Check whether multiple movies are visible or not visible.

Then(/^I should (not )?see the following movies: (.*)$/) do |not_visible, movie_list|
  movie_list.split(/\s*,\s*/).each do |movie|
    if not_visible
      expect(page).not_to have_content(movie)
    else
      expect(page).to have_content(movie)
    end
  end
end

Then(/^I should see all the movies$/) do
  rows = page.all('#movies > div[id^="movie_"]').count
  expect(rows).to eq(Movie.count)
end

### Utility Steps Just for this assignment.

Then(/^debug$/) do
  # Use "Then debug" in a scenario to open a console.
  require "byebug"
  byebug
  1
end

Then(/^debug javascript$/) do
  # Use "Then debug javascript" to open a JavaScript console.
  page.driver.debugger
  1
end

Then(/complete the rest of of this scenario/) do
  # Leave this definition here, but remove this step from feature scenarios.
  raise "Remove this step from your .feature files"
end