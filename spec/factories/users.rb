# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:login) {|n| "user#{n}" }
    sequence(:email) {|n| "user#{n}@example.com" }
    password 'secret'
    password_confirmation 'secret'
  end
end
