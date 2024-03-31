require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      user = FactoryBot.create(:user)
      expect(user).to be_valid
    end

    it 'validates name length in range' do
      user = FactoryBot.create(:user)
      expect(user).to be_valid
    end

    it 'validates acceptable email' do
      user = FactoryBot.create(:user)
      expect(user).to be_valid
    end

    it 'validates email length in range' do
      user = FactoryBot.create(:user)
      expect(user).to be_valid
    end

    it 'validates uniquene email' do
      unique_user = FactoryBot.create(:user)
      expect(unique_user).to be_valid
    end

    it 'validates format of email' do
      user = User.new(email: 'test@example')
      expect(user).not_to be_valid
    end

    it 'invalidates null name' do
      user = User.new(name: nil)
      expect(user).not_to be_valid
    end

    it 'invalidates excess length of name' do
      user = User.new(name: 'a' * 31)
      expect(user).not_to be_valid
    end

    it 'invalidates null email' do
      user = User.new(email: nil)
      expect(user).not_to be_valid
    end

    it 'invalidates access length of email' do
      user = User.new(email: 'a' * 51)
      expect(user).not_to be_valid
    end

    it 'invalidates duplicate email' do
      existing_user = create(:user)
      user = User.new(email: existing_user.email)
      expect(user).not_to be_valid
    end
  end
end
