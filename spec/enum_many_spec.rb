require 'database'
require 'enum_set'

describe EnumSet do
  class User < ActiveRecord::Base
    include EnumSet

    enum_set roles: [:admin, :super_user, :basic_user]
  end

  let!(:user) { User.create!(:roles => [:super_user]) }

  it 'defines a boolean method for each value' do
    expect(user).to be_super_user
    expect(user).to_not be_admin
  end

  it 'retrieves applicable enum values' do
    expect(user.roles).to eq [:super_user]
  end

  it 'lets enum values be set' do
    user.roles <<= :admin
    user.save!
    expect(user.reload).to be_admin
  end

  it 'scopes by enum value' do
    expect(User.super_user).to include user
    expect(User.admin).to_not include user
  end
end
