require 'rails_helper'

describe Rating do
  subject { FactoryGirl.create :rating }

  it { expect(subject).to validate_presence_of(:rating_number) }
  it { expect(subject).to validate_presence_of(:review) }
  it { expect(subject).to validate_presence_of(:book) }
  it { expect(subject).to validate_presence_of(:customer) }

  it { expect(subject).to belong_to(:customer) }
  it { expect(subject).to belong_to(:book) }
end