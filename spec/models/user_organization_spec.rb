require 'rails_helper'

RSpec.describe UserOrganization do
  describe 'validations' do
    it 'validates presence of invitation' do
      user_organization = FactoryBot.create(:user_organization)
      expect(user_organization).to be_valid
    end

    it 'validates inclusion type among predefined invitation type' do
      user_organization = UserOrganization.new(user: User.new, organization: Organization.new, invitation: 'pending', role: 'non-admin')
      expect(user_organization).to be_valid
    end

    it 'validates presence of role' do
      user_organization = FactoryBot.create(:user_organization)
      expect(user_organization).to be_valid
    end

    it 'validates role type among predefined role type' do
      user_organization = FactoryBot.create(:user_organization)
      expect(user_organization).to be_valid
    end

    it 'invalidates null invitation' do
      user_organization = UserOrganization.new(user: User.new, organization: Organization.new, role: 'non-admin')
      expect(user_organization).not_to be_valid
    end

    it 'invalidates invitation type not among predefined invitation type' do
      user_organization = UserOrganization.new(user: User.new, organization: Organization.new, invitation: 'invalid', role: 'non-admin')
      expect(user_organization).not_to be_valid
    end

    it 'invalidates null role' do
      user_organization = UserOrganization.new(user: User.new, organization: Organization.new, invitation: 'pending')
      expect(user_organization).not_to be_valid
    end

    it 'invalidates role type not among predefined role type' do
      user_organization = UserOrganization.new(user: User.new, organization: Organization.new, invitation: 'pending', role: 'unknown')
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