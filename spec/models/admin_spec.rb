require 'rails_helper'

RSpec.describe Admin, type: :model do
  subject { FactoryGirl.create :admin }

  it { expect(subject).to validate_presence_of(:email) }

  it "is invalid with incorrect email" do
    expect(FactoryGirl.build :admin, email: "myemail").not_to be_valid
  end
end
