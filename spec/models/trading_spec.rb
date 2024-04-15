require 'rails_helper'

RSpec.describe Trading do
  describe 'validations' do
    it 'validates number as amount' do
      trading = FactoryBot.create(:trading)
      expect(trading).to be_valid
    end

    it 'validates numerical floating amount' do
      trading = FactoryBot.create(:trading)
      trading.amount = 3.14
      expect(trading).to be_valid
    end

    it 'invalidates emptiness of amount' do
      trading = Trading.new
      expect(trading).not_to be_valid
    end

    it 'invalidates non-numericality of amount' do
      trading = Trading.new(amount: 'abc')
      expect(trading).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to organization' do
      association = described_class.reflect_on_association(:organization)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
