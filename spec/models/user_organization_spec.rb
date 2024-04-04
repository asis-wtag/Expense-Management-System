require 'rails_helper'

RSpec.describe UserOrganization do
  describe 'validations' do
    it 'validates presence of invitation' do
      user_organization = FactoryBot.create(:user_organization)
      expect(user_organization).to be_valid
    end

    it 'validates inclusion type among predefined' do
      user_organization = UserOrganization.new(user: User.new, organization: Organization.new, invitation: 'pending')
      expect(user_organization).to be_valid
    end

    it 'invalidates null invitation' do
      user_organization = UserOrganization.new(user: User.new, organization: Organization.new)
      expect(user_organization).not_to be_valid
    end

    it 'invalidates invitation type not among predefined' do
      user_organization = UserOrganization.new(user: User.new, organization: Organization.new, invitation: 'invalid')
      expect(user_organization).not_to be_valid
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
