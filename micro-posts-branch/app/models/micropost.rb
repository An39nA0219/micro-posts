class Micropost < ApplicationRecord
  belongs_to :user
  
  validates :content, presence: :true, length: {maximum: 255}
  
  ##ここからfavorite
  has_many :users
  has_many :favored_users, through: :favorites, source: :user
  
end
