# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :forum do
    sequence(:title) {|n| "Forum #{n}" }
    sequence(:slug) {|n| "forum-#{n}" }
    description "Here goes stuff"
    position 1
  end
end
