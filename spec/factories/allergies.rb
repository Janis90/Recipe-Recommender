FactoryGirl.define do
  factory :allergy do
    name  FFaker::Name.name
  end

  factory :invalid_allergy, parent: :allergy do |a|
    a.name nil
  end
end
