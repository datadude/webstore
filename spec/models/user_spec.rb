require 'rails_helper'

RSpec.describe User, :type => :model do

  describe 'roles' do
    before :each do
      @user_attribs = {
                first_name: 'Rob',
                last_name: 'Martin',
                email: 'rob@example.com',
                password: 'something_nice',
                role: 'admin'
               }
    end
    it 'Should add a user' do
      myuser = User.new(@user_attribs)
      expect(myuser.email).to eq('rob@example.com')
    end
    it 'should allow a valid role' do
      myuser = User.new(@user_attribs)
      myuser.save
      expect(myuser.errors[:role]).to be_empty
    end
    it 'should not allow an invalid role' do
      expect{
        User.new(@user_attribs.merge({role:'bogus'}))
      }.to raise_error(ArgumentError, "'bogus' is not a valid role")
    end

    it 'should have an enum value for role' do
      myuser = User.new(@user_attribs)
      myuser.save
      expect(myuser.admin?).to be_truthy
    end

    it 'should set is_admin?' do
      myuser = User.new(@user_attribs)
      expect(myuser.is_admin?).to be_truthy
    end

  end

  describe 'fixtures' do
    fixtures :users
    it 'should have loaded the fixtures' do
      record = User.find(1)
      expect(record.first_name).to eq('Robert')
    end
  end


end
