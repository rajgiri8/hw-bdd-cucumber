# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
  
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  #puts find(/#{e1}.*[\s\S]*#{e2}/, text: page.body)
  expect(page.text).to match(/#{e1}.*[\s\S]*#{e2}/)
  #assert page.body =~ /#{e1}.*[\s\S]*#{e2}/
   
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When (/I (un)?check the following ratings: (.*)/) do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list = rating_list.split(', ')
    rating_list.each do |rating|
      if uncheck 
        uncheck('ratings_' + rating)
      else 
        check('ratings_' + rating)
      end
    end
end

When(/^I submit the search form on the homepage$/) do
  click_button('Refresh')
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end


Then(/^I should see movie with ratings PG, R$/) do
  page.body.should match('<td>R</td>')
  page.body.should match('<td>PG</td>')
end

Then(/^I should not see movie with ratings: PG-13, G$/) do
  page.body.should_not match('<td>G</td>')
  page.body.should_not match('<td>PG-13</td>')
end



Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  # One row is for the
  expect(page.all(:html, 'table tr').size-1).to eq Movie.count
end
