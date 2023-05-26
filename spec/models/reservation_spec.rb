require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe '.associations' do
    it { should belong_to(:guest) }
    it { should accept_nested_attributes_for :guest }
  end

  describe '.validations' do
    it { is_expected.to validate_presence_of :code }
    it { is_expected.to validate_uniqueness_of :code }
  end
end
