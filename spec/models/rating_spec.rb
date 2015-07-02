require 'rails_helper'

describe Rating do
  subject { FactoryGirl.create :rating }

  it { expect(subject).to validate_inclusion_of(:rating_number).in_range(1..10) }

  it { expect(subject).to belong_to(:customer) }
  it { expect(subject).to belong_to(:book) }
end