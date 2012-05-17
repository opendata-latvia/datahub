# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic do
    association :forum
    association :user
    sequence(:title) {|n| "Forum #{n}" }
    sequence(:slug) {|n| "forum-#{n}" }
    description "MyText"
    commentable true
  end
end
