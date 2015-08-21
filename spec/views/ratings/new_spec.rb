require 'rails_helper'

describe "ratings/new.html.haml" do
  before do 
    @book = FactoryGirl.build_stubbed(:book)
    assign(:book, @book) 
    assign(:rating, Rating.new)
    render 
  end
  
  it "renders link to book user adding a rating for" do
    expect(rendered).to have_content "New review for #{@book.title}" 
    expect(rendered).to have_link "#{@book.title}", href: book_path(@book) 
  end
  
  it "renders new_rating form" do
    expect(rendered).to have_selector('form#new_rating') 
  end

  it "renders rating_review field" do
    expect(rendered).to have_selector('form#new_rating textarea#rating_review') 
  end
 
  it "renders 5 radio-buttons for rating" do
    expect(rendered).to have_selector('form#new_rating input#rating_rating_number_1') 
    expect(rendered).to have_selector('form#new_rating input#rating_rating_number_2') 
    expect(rendered).to have_selector('form#new_rating input#rating_rating_number_3') 
    expect(rendered).to have_selector('form#new_rating input#rating_rating_number_4') 
    expect(rendered).to have_selector('form#new_rating input#rating_rating_number_5')  
  end
 
  it "renders submit button" do
    expect(rendered).to have_selector('input[type="submit"]')
  end
end