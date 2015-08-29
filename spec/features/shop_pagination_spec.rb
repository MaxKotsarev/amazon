require 'features/features_spec_helper'

feature "Pagination" do 
  given!(:books) {FactoryGirl.create_list(:book, 10)}
  before do 
    visit books_path
  end

  shared_examples "pagination links" do
    describe "link" do
      it "navigate throug books list pages" do
        expect(page).to have_content books[0].title
        expect(page).not_to have_content books[9].title
        within ".pagination-wrap" do
          click_link(link)
        end
        expect(page).not_to have_content books[0].title
        expect(page).to have_content books[9].title
      end
    end
  end

  it_behaves_like "pagination links" do
    let(:link) { '2' } 
  end

  it_behaves_like "pagination links" do
    let(:link) { 'Next ›' } 
  end

  it_behaves_like "pagination links" do
    let(:link) { 'Last »' } 
  end
end