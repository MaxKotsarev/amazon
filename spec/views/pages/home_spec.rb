require 'rails_helper'

describe "pages/home.html.haml" do
  let(:author) {FactoryGirl.create(:author)}
  let(:books) {FactoryGirl.create_list(:book, 3, author: author)}

  before do
    assign(:books, books) 
    render 
  end
  
  it "renders page title and subtitle" do
    expect(rendered).to have_content "Welcome to our amazing Bookstore!"
    expect(rendered).to have_content "Choose anything you wish, we'll ship it anywhere."
  end
  
  describe "carusel with books" do
    it "renders books titles" do
      books.each {|book| expect(rendered).to have_content book.title}
    end

    it "renders books prices" do
      books.each {|book| expect(rendered).to have_content book.price}
    end

    it "renders author first and last names" do
      3.times {expect(rendered).to have_content "by #{author.firstname} #{author.lastname}"}
    end

    it "renders books short descriptions" do
      books.each {|book| expect(rendered).to have_content book.short_description}
    end

    it "renders books short descriptions" do
      books.each {|book| expect(rendered).to have_content book.short_description}
    end

    it "renders links to books as book title" do
      books.each {|book| expect(rendered).to have_link "#{book.title}", href: book_path(book) }
    end

    it "renders links to books as book cover image" do
      books.each {|book| expect(rendered).to have_selector "a[href='#{book_path(book)}'] img[src='#{book.image.url}']" }
    end

    describe "add to order form" do
      it "renders form" do
        3.times { expect(rendered).to have_selector "form[action='/orders/add_to_order']"}
      end

      it "renders field for amount" do
        3.times { expect(rendered).to have_selector "form[action='/orders/add_to_order'] input#quantity"}
      end

      it "renders hidden field with book_id" do
        books.each {|book| expect(rendered).to have_selector "form[action='/orders/add_to_order'] input[value='#{book.id}']", visible: false }
      end

      it "renders submit button" do
        3.times {expect(rendered).to have_selector('input[type="submit"][value="ADD TO CART"]')}
      end
    end
  end
end