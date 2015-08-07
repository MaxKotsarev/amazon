require 'rails_helper'

describe CreditCard do
  subject { FactoryGirl.build :credit_card }

  it { expect(subject).to validate_presence_of(:number) }
  it { expect(subject).to validate_presence_of(:cvv) }
  it { expect(subject).to validate_presence_of(:exp_month) }
  it { expect(subject).to validate_presence_of(:exp_year) }
  it { expect(subject).to validate_presence_of(:firstname) }
  it { expect(subject).to validate_presence_of(:lastname) }

  it { expect(subject).to allow_value('1234123412341234').for(:number) }
  it { expect(subject).not_to allow_value('FG3412Re1234aded').for(:number) }
  it { expect(subject).to allow_value('123', '560').for(:cvv) }
  it { expect(subject).not_to allow_value('1234', "23", "df3").for(:cvv) }
  it { expect(subject).to allow_value('18', '30', '22').for(:exp_year) }
  it { expect(subject).not_to allow_value('5','2015', '14', '33').for(:exp_year) }
  it { expect(subject).to allow_value("01","02","03","04","05","06","07","08","09","11","12").for(:exp_month) }
  it { expect(subject).not_to allow_value('5', '34', '324', "2d", "14").for(:exp_month) }

  it { expect(subject).to validate_length_of(:number).is_equal_to(16) }
  it { expect(subject).to validate_length_of(:cvv).is_equal_to(3) }
  it { expect(subject).to validate_length_of(:exp_month).is_equal_to(2) }
  it { expect(subject).to validate_length_of(:exp_year).is_equal_to(2) }

  it { expect(subject).to have_many(:orders) }
  it { expect(subject).to belong_to(:customer) }

end