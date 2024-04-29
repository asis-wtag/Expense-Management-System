require 'rails_helper'

RSpec.describe OrganizationPolicy do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  subject { described_class.new(user, organization) }

  describe '#create?' do
    it 'returns true' do
      expect(subject.create?).to eq(true)
    end
  end

  describe '#new?' do
    it 'delegates to #create?' do
      expect(subject.new?).to eq(subject.create?)
    end
  end

  describe '#invite_people?' do
    context 'when user is an admin of the organization' do
      before do
        create(:user_organization, user: user, organization: organization, role: 'admin', invitation: 'accepted')
      end

      it 'returns true' do
        expect(subject.invite_people?).to eq(true)
      end
    end

    context 'when user is not an admin of the organization' do
      it 'returns false' do
        expect(subject.invite_people?).to eq(false)
      end
    end
  end

  describe '#accept_invitation?' do
    it 'delegates to #create?' do
      expect(subject.accept_invitation?).to eq(subject.create?)
    end
  end

  describe '#reject_invitation?' do
    it 'delegates to #create?' do
      expect(subject.reject_invitation?).to eq(subject.create?)
    end
  end

  describe '#my_organizations?' do
    it 'delegates to #create?' do
      expect(subject.my_organizations?).to eq(subject.create?)
    end
  end

  describe '#add_people?' do
    it 'delegates to #invite_people?' do
      expect(subject.add_people?).to eq(subject.invite_people?)
    end
  end

  describe '#remove_people?' do
    it 'delegates to #invite_people?' do
      expect(subject.remove_people?).to eq(subject.invite_people?)
    end
  end

  describe '#show?' do
    it 'delegates to #invite_people?' do
      expect(subject.show?).to eq(subject.invite_people?)
    end
  end

  describe '#invitations?' do
    it 'delegates to #create?' do
      expect(subject.invitations?).to eq(subject.create?)
    end
  end

  describe '#make_admin?' do
    it 'delegates to #invite_people?' do
      expect(subject.make_admin?).to eq(subject.invite_people?)
    end
  end

  describe '#delete_organization?' do
    it 'delegates to #invite_people?' do
      expect(subject.delete_organization?).to eq(subject.invite_people?)
    end
  end

  describe '#tradings?' do
    context 'when user has accepted invitation to the organization & an admin' do
      before { create(:user_organization, user: user, organization: organization, invitation: 'accepted', role: 'admin') }

      it 'returns true' do
        expect(subject.tradings?).to eq(true)
      end
    end

    context 'when user has not accepted invitation to the organization' do
      it 'returns false' do
        expect(subject.tradings?).to eq(false)
      end
    end
  end

  describe '#add_trading?' do
    it 'delegates to #tradings?' do
      expect(subject.add_trading?).to eq(subject.tradings?)
    end
  end

  describe '#create_trading?' do
    it 'delegates to #tradings?' do
      expect(subject.create_trading?).to eq(subject.tradings?)
    end
  end

  describe '#delete_trading?' do
    it 'delegates to #tradings?' do
      expect(subject.delete_trading?).to eq(subject.tradings?)
    end
  end

  describe '#search_trading?' do
    it 'delegates to #tradings?' do
      expect(subject.search_trading?).to eq(subject.tradings?)
    end
  end

  describe '#filtered_tradings?' do
    it 'delegates to #tradings?' do
      expect(subject.filtered_tradings?).to eq(subject.tradings?)
    end
  end

  describe '#add_comment?' do
    it 'delegates to #tradings?' do
      expect(subject.add_comment?).to eq(subject.tradings?)
    end
  end

  describe '#delete_comment?' do
    it 'delegates to #tradings?' do
      expect(subject.delete_comment?).to eq(subject.tradings?)
    end
  end
end
