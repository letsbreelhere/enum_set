require 'database'
require 'enum_set'

describe EnumSet do
  context 'when the enum is defined with a hash' do
    class UserWithHashRoles < User
      include EnumSet

      enum_set roles: { king: 16, kaiser: 256 }
    end

    let!(:user) { UserWithHashRoles.create!(:roles => [:kaiser]) }

    it 'defines a boolean method for each value' do
      expect(user).to be_kaiser
      expect(user).to_not be_king
    end

    it 'retrieves applicable enum values' do
      expect(user.roles).to eq [:kaiser]
    end

    describe 'array setters' do
      it 'lets enum values be set' do
        user.roles <<= :king
        user.save!
        expect(user.reload).to be_king
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
      let(:kaiser) { 256 }

      it 'lets enum values be set by integers' do
        user.roles = kaiser
        expect(user).to be_kaiser
        expect(user).to_not be_king
      end
    end

    it 'scopes by enum value' do
      expect(UserWithHashRoles.kaiser).to include user
      expect(UserWithHashRoles.king).to_not include user
    end
  end

  describe 'class method getter' do
    it 'returns a hash of names to bit values' do
      expect(UserWithHashRoles.roles[:king]).to eq 16
    end
  end
end
