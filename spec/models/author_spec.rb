require 'rails_helper'

describe Author do
	subject { FactoryGirl.create :author }

	it { expect(subject).to validate_presence_of(:firstname) }
  it { expect(subject).to validate_presence_of(:lastname) }

  it { expect(subject).to have_many(:books) }
end
