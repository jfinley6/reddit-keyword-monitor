FactoryBot.define do
  factory :setting do
    subreddit_name { "MyString" }
    keywords { "MyString" }
    refresh { false }
    refresh_time { "MyString" }
    loading { false }
    created_at { "2023-01-04 12:23:21" }
    updated_at { "2023-01-04 12:23:21" }
  end
end
