require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let(:book) { FactoryGirl.build_stubbed(:book) }
  let(:rating_params) { FactoryGirl.attributes_for(:rating).stringify_keys.merge({"book_id" => book.id.to_s})}
  let(:rating) { FactoryGirl.build(:rating) }
  let(:customer) { FactoryGirl.create(:customer) }


  before do 
    sign_in :customer, customer
    #controller.class.skip_before_action :find_book
    controller.params[:book_id] = book.id.to_s
    Book.stub(:find).and_return book
  end
  
  describe 'GET #new' do 
    before do
      get :new, book_id: book.id
    end
 
    it 'assigns @rating variable' do
      expect(assigns(:rating)).to be_a_new(Rating)
    end
 
    it 'renders new template' do
      expect(response).to render_template :new
    end
  end

  describe "#find_book" do
  
    it "receives find and return book" do
      expect(Book).to receive(:find).with(book.id.to_s)
      controller.send(:find_book)
    end
  
    it "assigns @book" do
      controller.send(:find_book)
      expect(assigns(:book)).not_to be_nil
    end
  end

  describe "POST #create" do
    before do 
      controller.stub(:current_customer).and_return customer
      customer.stub_chain(:ratings, :build).and_return rating
    end

    context "with valid attributes" do
      before do 
        rating.stub(:save).and_return true
        Book.stub(:find).and_return book
        controller.send(:find_book)
        post :create, book_id: book.id, rating: rating_params
      end 

      it "assigns @rating" do     
        expect(assigns(:rating)).not_to be_nil
      end

      it "receives save for @rating" do
        expect(rating).to receive(:save)
        post :create, book_id: book.id, rating: rating_params
      end
  
      it "sends success notice" do
        expect(flash[:notice]).to eq 'Thank you for review! It will appear on this page after moderation.'
      end
  
      it "redirects to book page" do
        expect(response).to redirect_to book
      end
    end

    context "with invalid attributes" do
      before do 
        rating.stub(:save).and_return false
        post :create, book_id: book.id, rating: rating_params
      end 

      it "renders 'new' template" do
        expect(response).to render_template :new
      end
    end 
  end
end
