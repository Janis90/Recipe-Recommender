FactoryGirl.define do
  factory :user do
    username              FFaker::Internet.user_name
    first_name            FFaker::Name.first_name
    last_name             FFaker::Name.last_name
    email                 FFaker::Internet.email
    password              "password"
    password_confirmation "password"
  end

    factory :user_wrong_pw, parent: :user do |u|
      u.password_confirmation "wrong_pw"
    end

    factory :user_invalid_username, parent: :user do |u|
      u.username nil
    end

    factory :user_invalid_email, parent: :user do |u|
      u.email nil
    end

    factory :user_valid_1, parent: :user do |u|
      u.email 'xxx@xxx.de'
      u.username 'Hans'
    end

    factory :user_valid_2, parent: :user do |u|
      u.email 'yyy@yyy.de'
      u.username 'Wurst'
    end
end
