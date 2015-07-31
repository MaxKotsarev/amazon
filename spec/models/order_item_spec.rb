require 'rails_helper'

describe OrderItem do
  subject { FactoryGirl.create :order_item }

  it { expect(subject).to validate_presence_of(:price) }
  it { expect(subject).to validate_presence_of(:quantity) }
  it { expect(subject).to validate_presence_of(:order) }
  it { expect(subject).to validate_presence_of(:book) }

  it { expect(subject).to belong_to(:order) }
  it { expect(subject).to belong_to(:book) }
end