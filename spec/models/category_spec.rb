require 'rails_helper'

describe Category do
  subject { FactoryGirl.create :category }

  it { expect(subject).to validate_presence_of(:title) }
  it { expect(subject).to validate_uniqueness_of(:title) }

  it { expect(subject).to have_many(:books) }
end