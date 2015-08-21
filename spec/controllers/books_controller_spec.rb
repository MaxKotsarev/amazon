require 'rails_helper'

RSpec.describe BooksController, type: :controller do
  describe 'GET #index' do 
    before { get :index }
 
    it 'assigns @books variable' do
      books = FactoryGirl.create_list(:book, 2)
      expect(assigns(:books)).to match_array(books)
    end

    it 'assigns @categories variable' do
      categories = FactoryGirl.create_list(:category, 2)
      expect(assigns(:categories)).to match_array(categories)
    end
 
    it 'renders index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do 
    let(:book) { FactoryGirl.build_stubbed(:book) }
    before do 
      Book.stub(:find).and_return book
      get :show, id: book.id 
    end

    it "receives find and return book", skip_before: true do
      expect(Book).to receive(:find).with(book.id.to_s)
      get :show, id: book.id 
    end
 
    it 'assigns @book variable' do
      expect(assigns(:book)).not_to be_nil
    end

    it 'assigns @ratings variable' do
      ratings = FactoryGirl.create_list(:rating, 2, approved: true, book: book)
      expect(assigns(:ratings)).to match_array(ratings)
    end
 
    it 'renders show template' do
      expect(response).to render_template :show
    end
  end
end
