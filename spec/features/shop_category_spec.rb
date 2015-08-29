require 'features/features_spec_helper'

feature "Shop categories" do
  scenario "visitor can navigate the shop by categories" do 
    categories = FactoryGirl.create_list(:category, 2)
    book_1 = FactoryGirl.create(:book, category: categories[0])
    book_2 = FactoryGirl.create(:book, category: categories[1])
    visit books_path
    click_link(categories[0].title)
    expect(page).to have_content "Books in category '#{categories[0].title}'"
    expect(page).to have_content book_1.title
    expect(page).not_to have_content book_2.title
  end
end