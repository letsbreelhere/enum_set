require 'database'
require 'enum_set'

describe EnumSet do
  context 'when the enum is defined with an array' do
    class UserWithArrayRoles < User
      include EnumSet

      enum_set roles: [:admin, :super_user, :basic_user]
    end

    let!(:user) { UserWithArrayRoles.create!(:roles => [:super_user]) }

    it 'defines a boolean method for each value' do
      expect(user).to be_super_user
      expect(user).to_not be_admin
    end

    it 'retrieves applicable enum values' do
      expect(user.roles).to eq [:super_user]
    end

    describe 'array setters' do
      it 'lets enum values be set' do
        user.roles <<= :admin
        user.save!
        expect(user.reload).to be_admin
      end

      context 'when a nonexistent enum value is provided' do
        it 'raises a NameError' do
          expect {
            user.roles <<= :gender
          }.to raise_error EnumSet::EnumError
        end
      end
    end

    describe 'integer setters' do
      let(:admin_and_basic_user) { UserWithArrayRoles.roles[:admin] | UserWithArrayRoles.roles[:basic_user] }

      it 'lets enum values be set by integers' do
        user.roles = admin_and_basic_user
        expect(user).to be_admin
        expect(user).to be_basic_user
        expect(user).to_not be_super_user
      end
    end

    it 'scopes by enum value' do
      expect(UserWithArrayRoles.super_user).to include user
      expect(UserWithArrayRoles.admin).to_not include user
    end

    describe 'class method getter' do
      it 'returns a hash of names to bit values' do
        expect(UserWithArrayRoles.roles[:super_user]).to eq 2
      end
    end
  end
end
