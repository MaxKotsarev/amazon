require 'rails_helper'

describe Book do
  subject { FactoryGirl.create :book }

  it { expect(subject).to validate_presence_of(:title) }
  it { expect(subject).to validate_presence_of(:price) }
  it { expect(subject).to validate_presence_of(:amount) }

  it { expect(subject).to have_many(:ratings) }
  it { expect(subject).to belong_to(:category) }
  it { expect(subject).to belong_to(:author) }
end