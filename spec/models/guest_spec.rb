require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe '.associations' do
    it { should have_many(:reservations) }
  end

  describe '.validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_uniqueness_of :email }
  end
end
