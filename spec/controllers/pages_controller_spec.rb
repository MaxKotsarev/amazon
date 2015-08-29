require "rails_helper"

RSpec.describe PagesController, type: :controller do 
  let(:books) {FactoryGirl.create_list(:book, 3)}

  describe "GET #home" do
    before do
      Book.stub(:find).and_return books 
      get :home
    end
    
    it "assign @books variable" do
      expect(assigns(:books)).to match_array(books)
      expect(assigns)
    end 

    it "renders 'home' template" do 
      expect(response).to render_template :home
    end
  end
end 
