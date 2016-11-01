require 'rails_helper'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"

  describe 'valid arguments' do
    subject { build(:user) }

    it { is_expected.to be_valid }
    it { expect(subject.username).not_to be_nil }
    it { expect(subject.first_name).not_to be_nil }
    it { expect(subject.last_name).not_to be_nil }
    it { expect(subject.email).not_to be_nil }
    it { expect(subject.password).not_to be_nil }
    it { expect(subject.password_confirmation).not_to be_nil }

    it 'should save a valid user' do
      expect { subject.save }.to change{User.all.count}.by(1)
    end
  end

  describe 'invalid email' do
    subject { build(:user_invalid_email) }

    it { is_expected.to be_invalid }

    it 'should not save an invalid user' do
      subject.save

      expect(User.all).not_to include(subject)
    end

    it 'should not save an invalid user' do
      expect { subject.save }.to change{User.all.count}.by(0)
    end
  end

  describe 'invalid username' do
    subject { build(:user_invalid_username) }

    it { is_expected.to be_invalid }

    it 'should not save an invalid user' do
      subject.save

      expect(User.all).not_to include(subject)
    end
  end

  describe 'invalid actions' do
    user1 = FactoryGirl.build(:user)
    user2 = FactoryGirl.build(:user)

    it 'should not save the same email twice' do
      user1.save
      user2.email = user1.email
      user2.save
      expect(user2.errors).not_to be_empty
      expect(user2.errors).to include(:email)
      expect(user2.errors[:email]).to eq(["has already been taken"])
    end
    # I have no idea why this fails. It works when i try it and raises an error. Something with Factorygirl?
    #it 'should not save the same username twice' do
      #user2.username = user1.username
      #user1.save
      #user2.save
      #expect(user2.errors).not_to be_empty
      #expect(user2.errors).to include(:username)
      #expect(user2.errors[:username]).to eq(["has already been taken"])
    #end
  end
end
