class User < ActiveRecord::Base
  include BCrypt
  attr_accessor :password, :password_confirmation

  enum gender: [ :not_sure, :male, :female]

  validates :email, uniqueness: true, format: { with: /.+@.+\..{2,}/ }
  validates :password, length: { minimum: 4 }, on: :create
  validates :first_name, presence: true
  validates :last_name, presence: true
  validate :password_confirmation_does_not_match


  # has_many :blahblah, :class_name => 'Tweet', :foreign_key => 'user_id'
  # has_many :tweets, through: :blahblah, source: :user

  has_many :tweets, dependent: :destroy

  has_many :follower_in_followership, :class_name => 'Followership', :foreign_key => 'follower_id'
  has_many :followed_in_followership, :class_name => 'Followership', :foreign_key => 'followed_id'

  has_many :follower, through: :follower_in_followership, source: :followed
  has_many :followed, through: :followed_in_followership, source: :follower


  def password=(new_password)
    @password = new_password
    self.encrypted_password = Password.create(@password)
  end

  def self.authenticate(email, password)
    user = self.find_by(email: email)
    if user && Password.new(user.encrypted_password) == password
      user
    else
      nil
    end
  end

  def full_name
    first_name + ' ' + last_name
  end

  def data_url
    Identicon.data_url_for(email)
  end

  def password_confirmation_does_not_match
    if @password != @password_confirmation
      errors.add(:password_confirmation, "Passwords do not match")
    end
  end
end
