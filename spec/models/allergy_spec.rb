require 'rails_helper'

RSpec.describe Allergy, type: :model do
  describe 'valid arguments' do
    subject{ build(:allergy) }

    it { expect(subject.name).not_to be_nil }

    it 'should save a valid allergy' do
      expect { subject.save }.to change{Allergy.all.count}.by(1)
    end
  end
  describe 'invalid arguments' do
    subject{ build(:invalid_allergy) }

    it 'should not save an invalid allergy' do
      expect { subject.save }.to change{Allergy.all.count}.by(0)
    end

    it 'should not save an invalid allergy' do
      expect { subject.save }.to change{Allergy.all.count}.by(0)
      expect(subject.errors).not_to be_empty
      expect(subject.errors).to include(:name)
      # gets can't be blank; shows no alert message
      expect(subject.errors[:name]).to eq(["can't be empty"])
    end
  end
end

