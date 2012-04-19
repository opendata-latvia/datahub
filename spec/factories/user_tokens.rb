# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_token do
    association :user, :factory => :user
    provider "twitter"
    uid "1234567890"
  end
end
