class Post < ApplicationRecord
    validates :keywords, presence: true
end
