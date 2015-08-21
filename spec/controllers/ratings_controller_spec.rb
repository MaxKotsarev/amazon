require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  let(:book) { FactoryGirl.build_stubbed(:book) }
  let(:rating_params) { FactoryGirl.attributes_for(:rating).stringify_keys.merge({"book_id" => book.id.to_s})}
  let(:rating) { FactoryGirl.build(:rating) }
  let(:customer) { FactoryGirl.create(:customer) }

  before do 
    controller.class.skip_before_action :authenticate_customer!
    controller.class.skip_before_action :find_book
    controller.params[:book_id] = book.id.to_s
  end
  
  describe 'GET #new' do 
    before do
      get :new, book_id: book.id
    end
 
    it 'assigns @rating variable' do
      expect(assigns[:rating]).to be_a_new(Rating)
    end
 
    it 'renders new template' do
      expect(response).to render_template :new
    end
  end

  describe "#find_book" do
    before do
      Book.stub(:find).and_return book
    end
  
    it "receives find and return book" do
      expect(Book).to receive(:find).with(book.id.to_s)
      controller.send(:find_book)
    end
  
    it "assigns @book" do
      controller.send(:find_book)
      expect(assigns(:book)).not_to be_nil
    end
  end

#=begin
  describe "#create" do
    before do
      
    end

    context "with valid attributes" do
      before do 
        controller.stub(:current_customer).and_return customer
        customer.stub_chain(:ratings, :build).and_return rating
        rating.stub(:save).and_return true
      end 

      xit "assigns @rating" do
        post :create, book_id: book.id, rating: rating_params
        expect(assigns(:rating)).not_to be_nil
      end
    end

    context "with invalid attributes" do
    end 
  end
#=end
end
