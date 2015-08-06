require 'rails_helper'

RSpec.describe DeliveryType, type: :model do
  subject { FactoryGirl.create :delivery_type }

  it { expect(subject).to validate_presence_of(:title) }
  it { expect(subject).to validate_presence_of(:price) }
end
