require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let!(:categories) { FactoryGirl.create_list(:category, 2) }
  let!(:books) {FactoryGirl.create_list(:book,2, category: categories[0])}
  let!(:books_in_other_category) {FactoryGirl.create_list(:book,2, category: categories[1])}

  describe 'GET #show' do 
    before do
      get :show, id: categories[0].id
    end
 
    it 'assigns @category variable' do
      expect(assigns(:category)).to eq categories[0]
    end

    it 'assigns @categories variable' do
      expect(assigns(:categories)).to match_array categories
    end

    it 'assigns @books variable' do
      expect(assigns(:books)).to match_array books
      expect(assigns(:books)).not_to match_array books_in_other_category
    end
 
    it 'renders new template' do
      expect(response).to render_template :show
    end
  end
end
