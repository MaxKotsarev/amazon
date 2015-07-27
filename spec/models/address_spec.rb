require 'rails_helper'

describe Address do
  subject { FactoryGirl.create :address }

  it { expect(subject).to validate_presence_of(:address) }
  it { expect(subject).to validate_presence_of(:zipcode) }
  it { expect(subject).to validate_presence_of(:city) }
  it { expect(subject).to validate_presence_of(:phone) }
  it { expect(subject).to validate_presence_of(:country) }
  it { expect(subject).to validate_presence_of(:lastname) }
  it { expect(subject).to validate_presence_of(:firstname) }

  it { expect(subject).to belong_to(:country) }
end