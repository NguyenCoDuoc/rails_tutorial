class User < ApplicationRecord
  before_save {email.downcase!}

  validates :name, presence: true,
    length: {maximum: Settings.models.users.maximum_name}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
    length: {maximum: Settings.models.users.maximum_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.models.users.minimum_pass}

  has_secure_password
end