# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    commentable_type "Topic"
    commentable_id 1
    association :user
    content "Mu comments"
  end
end
