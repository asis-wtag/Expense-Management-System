require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe 'associations' do
    it 'has many tradings' do
      association = described_class.reflect_on_association(:tradings)
      expect(association.macro).to eq(:has_many)
    end
  end

  describe 'validations' do
    it 'validates name with body' do
      organization = FactoryBot.create(:organization)
      expect(organization).to be_valid
    end

    it 'validates uniqueness of name' do
      organization = FactoryBot.create(:organization)
      expect(organization).to be_valid
    end

    it 'validates length of name' do
      organization = Organization.new(name: 'a' * 30)
      expect(organization).to be_valid
    end

    it 'invalidates empty name' do
      organization = Organization.new
      expect(organization).not_to be_valid
    end

    it 'invalidates duplicate name' do
      Organization.create(name: 'Test Organization')
      organization = Organization.new(name: 'Test Organization')
      expect(organization).not_to be_valid
    end

    it 'invalidates access length of name' do
      organization = Organization.new(name: 'a' * 31)
      expect(organization).not_to be_valid
    end
  end
end
