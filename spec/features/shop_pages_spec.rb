require 'features/features_spec_helper'

feature "Shop and book pages" do
  scenario "visitor can see books list on shop page and go to any book page with ditailed info" do 
    books = FactoryGirl.create_list(:book, 2)
    visit books_path
    expect(page).to have_content books[0].title
    expect(page).to have_content books[1].title
    click_link(books[0].title)
    expect(page).to have_content books[0].title
    expect(page).to have_content books[0].description
  end
end