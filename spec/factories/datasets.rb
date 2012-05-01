# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dataset do
    sequence(:shortname) {|n| "dataset#{n}" }
    sequence(:name) {|n| "Dataset #{n}" }
  end
end
