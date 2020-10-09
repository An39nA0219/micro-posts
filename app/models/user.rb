class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
                    format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},
                    uniqueness: {case_sensitive: false}
  
  has_secure_password
  
  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  def follow(other_user)
    ##self にはuser.follow(other)をしたときのuserが代入されている
    
    unless self == other_user
      
      ##find_or_create_byは見つかればRelationshipモデルインスタンスを返す、見つからなければフォロー関係を保存
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    ##自分の関係性を探す。follow_idから、フォローを外したい人のidで
    relationship = self.relationships.find_by(follow_id: other_user.id)
    ##もしfollow_idからフォローを外したい人のidが見つかれば、既にフォローをしていることが判明するので、
    ##関係性をdestroyしていく
    relationship.destroy if relationship
  end

  def following?(other_user)
    ##self.followingsで自分をフォローしている人たちを参照
    ##include?(other_user)で、other_userがその中に含まれているか確認
    self.followings.include?(other_user)
  end
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
end
